const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const rateLimit = require('express-rate-limit');
const compression = require('compression');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

// Security middleware
app.use(helmet());
app.use(compression());

// Rate limiting
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // limit each IP to 100 requests per windowMs
  message: 'Too many requests from this IP, please try again later.',
});
app.use(limiter);

// CORS configuration
app.use(cors({
  origin: '*', // In production, specify your app's domain
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
  allowedHeaders: ['Content-Type', 'Authorization'],
}));

// Body parsing middleware
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));

// In-memory storage (for demo - use database in production)
let users = [];
let groups = [];
let events = [];
let messages = [];

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({ 
    status: 'OK', 
    timestamp: new Date().toISOString(),
    uptime: process.uptime()
  });
});

// User endpoints
app.post('/api/users', (req, res) => {
  try {
    const user = req.body;
    
    // Validate required fields
    if (!user.id || !user.email || !user.name) {
      return res.status(400).json({ error: 'Missing required fields' });
    }

    // Check if user exists
    const existingUserIndex = users.findIndex(u => u.id === user.id);
    
    if (existingUserIndex >= 0) {
      // Update existing user
      users[existingUserIndex] = { ...users[existingUserIndex], ...user };
    } else {
      // Add new user
      users.push(user);
    }

    res.json({ 
      status: 'success', 
      id: user.id,
      message: 'User synced successfully'
    });
  } catch (error) {
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.get('/api/users', (req, res) => {
  try {
    res.json(users);
  } catch (error) {
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.get('/api/users/:id', (req, res) => {
  try {
    const user = users.find(u => u.id === req.params.id);
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }
    res.json(user);
  } catch (error) {
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Group endpoints
app.post('/api/groups', (req, res) => {
  try {
    const group = req.body;
    
    // Validate required fields
    if (!group.id || !group.name || !group.creatorId) {
      return res.status(400).json({ error: 'Missing required fields' });
    }

    // Check if group exists
    const existingGroupIndex = groups.findIndex(g => g.id === group.id);
    
    if (existingGroupIndex >= 0) {
      // Update existing group
      groups[existingGroupIndex] = { ...groups[existingGroupIndex], ...group };
    } else {
      // Add new group
      groups.push(group);
    }

    res.json({ 
      status: 'success', 
      id: group.id,
      message: 'Group synced successfully'
    });
  } catch (error) {
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.get('/api/groups', (req, res) => {
  try {
    res.json(groups);
  } catch (error) {
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.get('/api/groups/:id', (req, res) => {
  try {
    const group = groups.find(g => g.id === req.params.id);
    if (!group) {
      return res.status(404).json({ error: 'Group not found' });
    }
    res.json(group);
  } catch (error) {
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Event endpoints
app.post('/api/events', (req, res) => {
  try {
    const event = req.body;
    
    // Validate required fields
    if (!event.id || !event.title || !event.organizerId) {
      return res.status(400).json({ error: 'Missing required fields' });
    }

    // Check if event exists
    const existingEventIndex = events.findIndex(e => e.id === event.id);
    
    if (existingEventIndex >= 0) {
      // Update existing event
      events[existingEventIndex] = { ...events[existingEventIndex], ...event };
    } else {
      // Add new event
      events.push(event);
    }

    res.json({ 
      status: 'success', 
      id: event.id,
      message: 'Event synced successfully'
    });
  } catch (error) {
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.get('/api/events', (req, res) => {
  try {
    res.json(events);
  } catch (error) {
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.get('/api/events/:id', (req, res) => {
  try {
    const event = events.find(e => e.id === req.params.id);
    if (!event) {
      return res.status(404).json({ error: 'Event not found' });
    }
    res.json(event);
  } catch (error) {
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Message endpoints
app.post('/api/messages', (req, res) => {
  try {
    const message = req.body;
    
    // Validate required fields
    if (!message.id || !message.content || !message.senderId || !message.groupId) {
      return res.status(400).json({ error: 'Missing required fields' });
    }

    // Add new message
    messages.push(message);

    res.json({ 
      status: 'success', 
      id: message.id,
      message: 'Message synced successfully'
    });
  } catch (error) {
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.get('/api/messages/:groupId', (req, res) => {
  try {
    const groupMessages = messages.filter(m => m.groupId === req.params.groupId);
    res.json(groupMessages);
  } catch (error) {
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Sync endpoint for bulk operations
app.post('/api/sync', (req, res) => {
  try {
    const { users: syncUsers, groups: syncGroups, events: syncEvents, messages: syncMessages } = req.body;
    
    let syncedCount = 0;
    
    // Sync users
    if (syncUsers && Array.isArray(syncUsers)) {
      syncUsers.forEach(user => {
        const existingIndex = users.findIndex(u => u.id === user.id);
        if (existingIndex >= 0) {
          users[existingIndex] = { ...users[existingIndex], ...user };
        } else {
          users.push(user);
        }
        syncedCount++;
      });
    }
    
    // Sync groups
    if (syncGroups && Array.isArray(syncGroups)) {
      syncGroups.forEach(group => {
        const existingIndex = groups.findIndex(g => g.id === group.id);
        if (existingIndex >= 0) {
          groups[existingIndex] = { ...groups[existingIndex], ...group };
        } else {
          groups.push(group);
        }
        syncedCount++;
      });
    }
    
    // Sync events
    if (syncEvents && Array.isArray(syncEvents)) {
      syncEvents.forEach(event => {
        const existingIndex = events.findIndex(e => e.id === event.id);
        if (existingIndex >= 0) {
          events[existingIndex] = { ...events[existingIndex], ...event };
        } else {
          events.push(event);
        }
        syncedCount++;
      });
    }
    
    // Sync messages
    if (syncMessages && Array.isArray(syncMessages)) {
      syncMessages.forEach(message => {
        messages.push(message);
        syncedCount++;
      });
    }

    res.json({ 
      status: 'success', 
      syncedCount,
      message: `Synced ${syncedCount} items successfully`
    });
  } catch (error) {
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Error handling middleware
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ error: 'Something went wrong!' });
});

// 404 handler
app.use((req, res) => {
  res.status(404).json({ error: 'Endpoint not found' });
});

// Start server
app.listen(PORT, () => {
  console.log(`Sisterhood Server running on port ${PORT}`);
  console.log(`Health check: http://localhost:${PORT}/health`);
});

module.exports = app;
