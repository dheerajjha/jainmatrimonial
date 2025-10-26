class User {
  final String id;
  final String phoneNumber;
  final String role;
  final bool isVerified;

  User({
    required this.id,
    required this.phoneNumber,
    required this.role,
    required this.isVerified,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? json['_id'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      role: json['role'] ?? '',
      isVerified: json['isVerified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'role': role,
      'isVerified': isVerified,
    };
  }
}
