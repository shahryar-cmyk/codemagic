class JsonUser {
  JsonUser({
    this.token,
    this.userEmail,
    this.userNicename,
    this.userDisplayName,
    this.userRole,
    this.userId,
    this.avatar,
  });

  String token;
  String userEmail;
  String userNicename;
  String userDisplayName;
  List<String> userRole;
  int userId;
  String avatar;

  factory JsonUser.fromJson(Map<String, dynamic> json) => JsonUser(
        token: json["token"],
        userEmail: json["user_email"],
        userNicename: json["user_nicename"],
        userDisplayName: json["user_display_name"],
        userRole: List<String>.from(json["user_role"].map((x) => x)),
        userId: json["user_id"],
        avatar: json["avatar"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "user_email": userEmail,
        "user_nicename": userNicename,
        "user_display_name": userDisplayName,
        "user_role": List<dynamic>.from(userRole.map((x) => x)),
        "user_id": userId,
        "avatar": avatar,
      };
}
