class User {
  final int? id;
  final String? nama;
  final String? email;
  final int? roleId;

  User({this.id, this.nama, this.email, this.roleId});

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}'),
    nama: json['nama']?.toString() ?? json['name']?.toString(),
    email: json['email']?.toString(),
    roleId: json['roleId'] is int
        ? json['roleId'] as int
        : int.tryParse('${json['roleId']}') ??
              int.tryParse('${json['role_id']}'),
  );

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    if (nama != null) 'nama': nama,
    if (email != null) 'email': email,
    if (roleId != null) 'roleId': roleId,
  };

  User copyWith({int? id, String? nama, String? email, int? roleId}) => User(
    id: id ?? this.id,
    nama: nama ?? this.nama,
    email: email ?? this.email,
    roleId: roleId ?? this.roleId,
  );

  factory User.fromJwtPayload(Map<String, dynamic> payload) => User(
    id: payload['userId'] is int
        ? payload['userId'] as int
        : int.tryParse('${payload['userId']}'),
    email: payload['email']?.toString(),
    roleId: payload['roleId'] is int
        ? payload['roleId'] as int
        : int.tryParse('${payload['roleId']}') ??
              int.tryParse('${payload['role_id']}'),
  );
}
