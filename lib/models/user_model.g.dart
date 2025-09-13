// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 0;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      id: fields[0] as String,
      name: fields[1] as String,
      email: fields[2] as String,
      profileImageUrl: fields[3] as String?,
      bio: fields[4] as String,
      interests: (fields[5] as List).cast<String>(),
      latitude: fields[6] as double,
      longitude: fields[7] as double,
      city: fields[8] as String,
      age: fields[9] as int,
      occupation: fields[10] as String,
      isVerified: fields[11] as bool,
      blockedUsers: (fields[12] as List).cast<String>(),
      createdAt: fields[13] as DateTime,
      lastActive: fields[14] as DateTime,
      isOnline: fields[15] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.profileImageUrl)
      ..writeByte(4)
      ..write(obj.bio)
      ..writeByte(5)
      ..write(obj.interests)
      ..writeByte(6)
      ..write(obj.latitude)
      ..writeByte(7)
      ..write(obj.longitude)
      ..writeByte(8)
      ..write(obj.city)
      ..writeByte(9)
      ..write(obj.age)
      ..writeByte(10)
      ..write(obj.occupation)
      ..writeByte(11)
      ..write(obj.isVerified)
      ..writeByte(12)
      ..write(obj.blockedUsers)
      ..writeByte(13)
      ..write(obj.createdAt)
      ..writeByte(14)
      ..write(obj.lastActive)
      ..writeByte(15)
      ..write(obj.isOnline);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
