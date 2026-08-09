import 'package:hive/hive.dart';

import 'pending_operation_model.dart';

class PendingOperationModelAdapter extends TypeAdapter<PendingOperationModel> {
  @override
  final int typeId = 1;

  @override
  PendingOperationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PendingOperationModel(
      id: fields[0] as String,
      operationType: fields[1] as String,
      payload: (fields[2] as Map).cast<String, dynamic>(),
      createdAt: fields[3] as DateTime,
      status: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PendingOperationModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.operationType)
      ..writeByte(2)
      ..write(obj.payload)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PendingOperationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
