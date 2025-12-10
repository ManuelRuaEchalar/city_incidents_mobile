class UserModel {
  final int userId;
  final String username;
  final String email;
  final String? profilePicUrl;
  final bool isVerified;
  final String role;
  final DateTime createdAt;

  UserModel({
    required this.userId,
    required this.username,
    required this.email,
    this.profilePicUrl,
    required this.isVerified,
    required this.role,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['user_id'],
      username: json['username'],
      email: json['email'],
      profilePicUrl: json['profile_pic_url'],
      isVerified: json['is_verified'],
      role: json['role'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'username': username,
      'email': email,
      'profile_pic_url': profilePicUrl,
      'is_verified': isVerified,
      'role': role,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class UserStatsModel {
  final int totalReports;
  final int resolvedReports;
  final int followingReports;

  UserStatsModel({
    required this.totalReports,
    required this.resolvedReports,
    required this.followingReports,
  });

  factory UserStatsModel.fromJson(Map<String, dynamic> json) {
    return UserStatsModel(
      totalReports: json['total_reports'],
      resolvedReports: json['resolved_reports'],
      followingReports: json['following_reports'],
    );
  }
}
