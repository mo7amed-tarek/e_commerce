import 'package:equatable/equatable.dart';

// ── Request Models ─────────────────────────────────────────────────────────

class SignInRequest {
  final String username;
  final String password;

  SignInRequest({required this.username, required this.password});
}

class SignUpRequest {
  final String fullName;
  final String mobile;
  final String email;
  final String password;

  SignUpRequest({
    required this.fullName,
    required this.mobile,
    required this.email,
    required this.password,
  });
}

class ForgotPasswordRequest {
  final String email;

  ForgotPasswordRequest({required this.email});
}

class VerifyOtpRequest {
  final String email;
  final String otp;

  VerifyOtpRequest({required this.email, required this.otp});
}

class ResetPasswordRequest {
  final String email;
  final String otp;
  final String newPassword;

  ResetPasswordRequest({
    required this.email,
    required this.otp,
    required this.newPassword,
  });
}

// ── User Model ──────────────────────────────────────────────────────────────

class UserModel extends Equatable {
  final String? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? role;
  final String? address; // ← أضف ده

  const UserModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.role,
    this.address,
  });

  String? get username => name;

  factory UserModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const UserModel();
    }

    return UserModel(
      id: json['_id'] ?? json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      role: json['role'],
      address: json['address'], // ← أضف ده
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'address': address,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? role,
    String? address, // ← أضف ده
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      address: address ?? this.address,
    );
  }

  @override
  List<Object?> get props => [id, name, email, phone, role, address];
}
