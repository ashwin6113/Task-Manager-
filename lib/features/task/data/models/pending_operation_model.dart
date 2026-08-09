import 'package:hive/hive.dart';

import '../../../../core/constants/type.dart';

@HiveType(typeId: 1)
class PendingOperationModel extends HiveObject { // 'PENDING', 'SYNCING', 'FAILED'

  PendingOperationModel({
    required this.id,
    required this.operationType,
    required this.payload,
    required this.createdAt,
    required this.status,
  });
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String operationType; // 'CREATE', 'UPDATE', 'DELETE', 'TOGGLE'

  @HiveField(2)
  final JSONObject payload; // Serialized Task data or other context

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  final String status;
}
