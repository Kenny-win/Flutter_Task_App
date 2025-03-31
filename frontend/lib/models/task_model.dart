import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:frontend/core/constants/utils.dart';

class TaskModel {
  final String id;
  final String uid;
  final String title;
  final Color color;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime dueAt;
  final int isSynced;

  TaskModel({
    required this.id,
    required this.uid,
    required this.title,
    required this.color,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.dueAt,
    required this.isSynced,
  });

  TaskModel copyWith({
    String? id,
    String? uid,
    String? title,
    Color? color,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? dueAt,
    int? isSynced,
  }) {
    return TaskModel(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      title: title ?? this.title,
      color: color ?? this.color,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      dueAt: dueAt ?? this.dueAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'uid': uid});
    result.addAll({'title': title});
    result.addAll({'hexColor': rgbToHex(color)});
    result.addAll({'description': description});
    result.addAll({'createdAt': createdAt.toIso8601String()});
    result.addAll({'updatedAt': updatedAt.toIso8601String()});
    result.addAll({'dueAt': dueAt.toIso8601String()});
    result.addAll({'isSynced': isSynced});

    return result;
  }

  // factory TaskModel.fromMap(Map<String, dynamic> map) {
  //   return TaskModel(
  //     id: map['id'],
  //     uid: map['uid'],
  //     title: map['title'],
  //     color: hexToRgb(map['hexColor']),
  //     description: map['description'] ,
  //     createdAt: DateTime.parse(map['createdAt']),
  //     updatedAt: DateTime.parse(map['updatedAt']),
  //     dueAt: DateTime.parse(map['dueAt']),
  //   );
  // }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] ?? '',
      uid: map['uid'] ?? '',
      title: map['title'] ?? '',
      color: hexToRgb(map['hexColor']),
      description: map['description'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      dueAt: DateTime.parse(map['dueAt']),
      isSynced: map['isSynced'] ?? 1,
    );
  }

  // factory TaskModel.fromMap(Map<String, dynamic> map) {
  //   try {
  //     print("Parsing TaskModel...");
  //     print("Raw data: $map");

  //     return TaskModel(
  //       id: map['id'] ?? '',
  //       uid: map['uid'] ?? '',
  //       title: map['title'] ?? '',
  //       color: (map['color'] is String) ? hexToRgb(map['color']) : Colors.black,
  //       description:
  //           map['description'] is String
  //               ? map['description']
  //               : (map['description'] is Map<String, dynamic> &&
  //                   map['description'].containsKey('text'))
  //               ? map['description']['text']
  //               : '',
  //       createdAt: DateTime.parse(map['createdAt']),
  //       updatedAt: DateTime.parse(map['updatedAt']),
  //       dueAt: DateTime.parse(map['dueAt']),
  //     );
  //   } catch (e, stackTrace) {
  //     print("Error saat parsing TaskModel: $e");
  //     print(stackTrace);
  //     rethrow; // Agar error tetap terlihat di konsol
  //   }
  // }

  String toJson() => json.encode(toMap());

  factory TaskModel.fromJson(String source) =>
      TaskModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TaskModel(id: $id, uid: $uid, title: $title, color: $color, description: $description, createdAt: $createdAt, updatedAt: $updatedAt, dueAt: $dueAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TaskModel &&
        other.id == id &&
        other.uid == uid &&
        other.title == title &&
        other.color == color &&
        other.description == description &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.dueAt == dueAt &&
        other.isSynced == isSynced;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        uid.hashCode ^
        title.hashCode ^
        color.hashCode ^
        description.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        dueAt.hashCode ^
        isSynced.hashCode;
  }
}
