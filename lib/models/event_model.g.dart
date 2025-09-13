// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EventModelAdapter extends TypeAdapter<EventModel> {
  @override
  final int typeId = 2;

  @override
  EventModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EventModel(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      organizerId: fields[3] as String,
      groupId: fields[4] as String,
      startTime: fields[5] as DateTime,
      endTime: fields[6] as DateTime,
      location: fields[7] as String,
      latitude: fields[8] as double,
      longitude: fields[9] as double,
      attendeeIds: (fields[10] as List).cast<String>(),
      maxAttendees: fields[11] as int,
      imageUrl: fields[12] as String?,
      category: fields[13] as String,
      isOnline: fields[14] as bool,
      createdAt: fields[15] as DateTime,
      updatedAt: fields[16] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, EventModel obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.organizerId)
      ..writeByte(4)
      ..write(obj.groupId)
      ..writeByte(5)
      ..write(obj.startTime)
      ..writeByte(6)
      ..write(obj.endTime)
      ..writeByte(7)
      ..write(obj.location)
      ..writeByte(8)
      ..write(obj.latitude)
      ..writeByte(9)
      ..write(obj.longitude)
      ..writeByte(10)
      ..write(obj.attendeeIds)
      ..writeByte(11)
      ..write(obj.maxAttendees)
      ..writeByte(12)
      ..write(obj.imageUrl)
      ..writeByte(13)
      ..write(obj.category)
      ..writeByte(14)
      ..write(obj.isOnline)
      ..writeByte(15)
      ..write(obj.createdAt)
      ..writeByte(16)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
