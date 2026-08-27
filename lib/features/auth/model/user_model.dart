class UserModel {
  final int id;
  final String firstName;
  final String lastName;
  final String mobile;
  final String email;
  final String membershipType;
  final String createdAt;
  final String updatedAt;
  final String role;

  const UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.mobile,
    required this.email,
    required this.membershipType,
    required this.createdAt,
    required this.updatedAt,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      mobile: json['mobile'] ?? '',
      email: json['email'] ?? '',
      membershipType: json['membership_type'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      role: json['role'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "first_name": firstName,
      "last_name": lastName,
      "mobile": mobile,
      "email": email,
      "membership_type": membershipType,
      "created_at": createdAt,
      "updated_at": updatedAt,
      "role": role,
    };
  }
}