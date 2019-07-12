class User {
  User(this.id, this.userName, {this.externalId, this.photoUrl});

  factory User.fromMap(Map map) {
    final User user = User(map['id'], map['userName'],
        externalId: map['externalId'], photoUrl: map['photoUrl']);
    return user;
  }
  String id;
  String externalId;
  String userName;
  String photoUrl;

  Map<String, dynamic> toJson() => {
        'externalId': externalId,
        'userName': userName,
        'photoUrl': photoUrl,
      };

  @override
  String toString() {
    return 'User{id: $id, externalId: $externalId, userName: $userName, photoUrl: $photoUrl}';
  }
}
