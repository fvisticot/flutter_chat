class User {
  String id;
  String externalId;
  String userName;
  String photoUrl;

  User(this.id,
      this.userName,
      {this.externalId,
        this.photoUrl});

  factory User.fromMap(Map map) {
    User user = User(
        map['id'],
        map['userName'],
        externalId: map['externalId'],
        photoUrl: map['photoUrl']
    );
        return user;
  }

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
