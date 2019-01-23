class User {
  String id;
  String externalId;
  String firstName;
  String lastName;
  String photoUrl;
  String pushToken;

  User(
      {this.id,
      this.externalId,
      this.firstName,
      this.lastName,
      this.photoUrl,
      this.pushToken});

  factory User.fromMap(Map map) {
    User user = User(
        externalId: map['externalId'],
        firstName: map['firstName'],
        lastName: map['lastName'],
        photoUrl: map['photoUrl'],
        pushToken: map['pushToken']);

    return user;
  }

  Map<String, dynamic> toJson() => {
        'externalId': externalId,
        'firstName': firstName,
        'lastName': lastName,
        'photoUrl': photoUrl,
        'pushToken': pushToken,
      };

  @override
  String toString() {
    return 'User{id: $id, externalId: $externalId, firstName: $firstName, lastName: $lastName, photoUrl: $photoUrl}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class Group {
  String id;
  DateTime createdAt;
  String createdByUserId;
  final String name;
  String photoUrl;

  Group(this.createdByUserId,
      {this.name, this.photoUrl, this.createdAt, this.id}) {
    createdAt = DateTime.now();
  }

  factory Group.fromMap(Map map) {
    Group group = Group(map['createdByUserId'],
        name: map['name'],
        createdAt: DateTime.parse(map['createdAt']),
        photoUrl: map['photoUrl']);

    return group;
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'createdAt': createdAt.toUtc().toIso8601String(),
        'createdByUserId': createdByUserId,
        'photoUrl': photoUrl,
      };

  @override
  String toString() {
    return 'Group{createdAt: $createdAt, createdByUserId: $createdByUserId, name: $name, photoUrl: $photoUrl}';
  }
}

class Contact {
  final String userId;
  DateTime createdAt;

  Contact(this.userId, {this.createdAt}) {
    if (createdAt == null) {
      createdAt = DateTime.now();
    }
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Contact.fromMap(Map map) {
    Contact contact =
        Contact(map['userId'], createdAt: DateTime.parse(map['createdAt']));

    return contact;
  }

  @override
  String toString() {
    return 'Contact{userId: $userId, createdAt: $createdAt}';
  }
}
