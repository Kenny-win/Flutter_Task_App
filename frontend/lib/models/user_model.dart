import 'dart:convert';

class UserModel {
  final String id;
  final String email;
  final String name;
  final String token;
  final DateTime createdAt;
  final DateTime updatedAt;
  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.token,
    required this.createdAt,
    required this.updatedAt,
  });

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? token,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      token: token ?? this.token,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'id': id});
    result.addAll({'email': email});
    result.addAll({'name': name});
    result.addAll({'token': token});
    result.addAll({'createdAt': createdAt.toIso8601String()});
    result.addAll({'updatedAt': updatedAt.toIso8601String()});
  
    return result;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      token: map['token'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, name: $name, token: $token, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is UserModel &&
      other.id == id &&
      other.email == email &&
      other.name == name &&
      other.token == token &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      email.hashCode ^
      name.hashCode ^
      token.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
  }
}
