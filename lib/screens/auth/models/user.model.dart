import '../../../utilities/app.constants.dart' show AppConstants, Utils;

class User {
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.appleId,
    required this.googleId,
    required this.deviceToken,
    required this.createdAt,
    required this.role,
    required this.updatedAt,
  });

  late final String id;
  late final String name;
  late final String email;
  late final String appleId;
  late final String googleId;
  late final String deviceToken;
  late final String createdAt;
  late final String role;
  late final String updatedAt;
  // late final List<String> subscriptions;

  User.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? '';
    name = json['name'] ?? '';
    email = json['email'] ?? '';
    appleId = json['appleId'] ?? '';
    googleId = json['googleId'] ?? '';
    deviceToken = json['deviceToken'] ?? '';
    createdAt = json['createdAt'] ?? '';
    role = json['role'] ?? '';
    updatedAt = json['updatedAt'] ?? '';
    // subscriptions = json['subscriptions'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['appleId'] = appleId;
    data['googleId'] = googleId;
    data['deviceToken'] = deviceToken;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    // data['subscriptions'] = subscriptions;
    return data;
  }
}

class UserResponse {
  final bool success;
  final int? statusCode;
  final String message;
  final UserData data;

  UserResponse({
    required this.success,
    this.statusCode,
    required this.message,
    required this.data,
  });

  /// Creates a UserResponse instance from a JSON map.
  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      success: json['success'] as bool,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] as String,
      data: UserData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  /// Converts the UserResponse instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'statusCode': statusCode,
      'message': message,
      'data': data.toJson(),
    };
  }
}

/// Represents the user details within the response.
class UserData {
  final String? id;
  final String? email;
  final String? name;
  final String? password;
  final String? role;
  final String? provider;
  final int? longestStreak;
  final int? currentStreak;
  final String? readingTime;
  final bool? receiveNotifications;

  // final int? version;
  final List<dynamic> subscriptions;

  UserData({
    this.id,
    this.email,
    this.name,
    this.password,
    this.role,
    // this.version,
    this.provider,
    this.subscriptions = const [],
    this.longestStreak,
    this.currentStreak,
    this.readingTime,
    this.receiveNotifications = true,
  });

  /// Named constructor to create an empty UserData instance
  factory UserData.empty() {
    return UserData(
      id: '',
      email: '',
      name: '',
      password: '',
      role: '',
      // version: 0,
      provider: '',
      subscriptions: [],
      longestStreak: 0,
      currentStreak: 0,
      readingTime: '',
      receiveNotifications: true,
    );
  }

  /// Creates a UserData instance from a JSON map.
  factory UserData.fromJson(Map<String, dynamic> json) {
    AppConstants.name = json['name'] ?? '';
    AppConstants.email = json['email'] ?? '';
    AppConstants.readingTime = json['readingTime'] ?? '';
    AppConstants.receiveNotifications = json['receiveNotifications'] ?? true;
    Utils.logger.f("json: $json");
    return UserData(
      id: json['_id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      password: json['password'] ?? '',
      role: json['role'] ?? '',
      // version: json['__v'] ?? 0,
      provider: json['provider'] ?? '',
      subscriptions: json['subscriptions'] ?? [],
      longestStreak: json['longestStreak'] ?? 0,
      currentStreak: json['currentStreak'] ?? 0,
      readingTime: json['readingTime'] ?? '',
      receiveNotifications: json['receiveNotifications'] ?? true,
    );
  }

  /// Converts the UserData instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      '_id': id ?? '',
      'email': email ?? '',
      'name': name ?? '',
      'password': password ?? '',
      'role': role ?? '',
      'provider': provider ?? '',
      // '__v': version,
      'subscriptions': subscriptions,
      'longestStreak': longestStreak ?? 0,
      'currentStreak': currentStreak ?? 0,
      'readingTime': readingTime ?? '',
      'receiveNotifications': receiveNotifications ?? true,
    };
  }
}
