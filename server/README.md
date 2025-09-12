# Sisterhood App Server

A secure, lightweight sync server for the Sisterhood mobile app built with Node.js and Express.

## Features

- 🔒 **Secure API endpoints** with rate limiting and CORS protection
- 📱 **Mobile-optimized** for Flutter apps
- 🚀 **Lightweight** - minimal resource usage
- 🌐 **Worldwide access** via Railway deployment
- 📊 **Health monitoring** with uptime tracking
- 🔄 **Real-time sync** for users, groups, events, and messages

## Quick Deploy to Railway

### Option 1: One-Click Deploy
[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/template/deploy)

### Option 2: Manual Deploy

1. **Fork this repository**
2. **Go to [Railway.app](https://railway.app)**
3. **Sign up/Login** with GitHub
4. **Click "New Project"**
5. **Select "Deploy from GitHub repo"**
6. **Choose your forked repository**
7. **Railway will automatically detect Node.js and deploy**

## Environment Variables

The server will work with default settings, but you can customize:

```bash
PORT=3000
NODE_ENV=production
```

## API Endpoints

### Health Check
```
GET /health
```

### Users
```
POST /api/users          # Sync user data
GET  /api/users          # Get all users
GET  /api/users/:id       # Get specific user
```

### Groups
```
POST /api/groups         # Sync group data
GET  /api/groups         # Get all groups
GET  /api/groups/:id      # Get specific group
```

### Events
```
POST /api/events         # Sync event data
GET  /api/events         # Get all events
GET  /api/events/:id     # Get specific event
```

### Messages
```
POST /api/messages       # Sync message data
GET  /api/messages/:groupId  # Get group messages
```

### Bulk Sync
```
POST /api/sync           # Sync multiple items at once
```

## Security Features

- ✅ **Rate limiting** - 100 requests per 15 minutes per IP
- ✅ **CORS protection** - configurable origins
- ✅ **Helmet security** - security headers
- ✅ **Input validation** - required field checking
- ✅ **Error handling** - graceful error responses
- ✅ **Compression** - gzip compression for faster responses

## Local Development

```bash
# Install dependencies
npm install

# Start development server
npm run dev

# Start production server
npm start
```

## Production Deployment

Railway automatically handles:
- ✅ **SSL certificates** - HTTPS enabled
- ✅ **Auto-scaling** - handles traffic spikes
- ✅ **Zero-downtime deployments** - seamless updates
- ✅ **Monitoring** - built-in metrics
- ✅ **Logs** - real-time log viewing

## Custom Domain (Optional)

1. **Go to Railway dashboard**
2. **Select your project**
3. **Go to Settings > Domains**
4. **Add your custom domain**
5. **Update DNS records** as instructed

## Cost

- ✅ **FREE tier** - 500 hours/month
- ✅ **$5/month** - unlimited hours
- ✅ **No credit card required** for free tier

## Support

- 📧 **Email**: support@railway.app
- 📖 **Docs**: https://docs.railway.app
- 💬 **Discord**: https://discord.gg/railway

## License

MIT License - feel free to use for your projects!
