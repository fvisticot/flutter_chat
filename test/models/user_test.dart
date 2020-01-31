import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_chat/src/models/user.dart';

void main() {
  test('User constructor with all parameters', () {
    const String id = 'userId';
    const String externalId = 'userExternalId';
    const String userName = 'userName';
    const String photoUrl = 'userPhotoUrl';

    final User user =
        User(id, userName, externalId: externalId, photoUrl: photoUrl);

    expect(user.id, id);
    expect(user.userName, userName);
    expect(user.externalId, externalId);
    expect(user.photoUrl, photoUrl);
  });

  test('User constructor without externalId', () {
    const String id = 'userId';
    const String userName = 'userName';
    const String photoUrl = 'userPhotoUrl';

    final User user = User(id, userName, photoUrl: photoUrl);

    expect(user.id, id);
    expect(user.userName, userName);
    expect(user.externalId, null);
    expect(user.photoUrl, photoUrl);
  });

  test('User constructor without photoUrl', () {
    const String id = 'userId';
    const String userName = 'userName';
    const String externalId = 'userExternalId';

    final User user = User(id, userName, externalId: externalId);

    expect(user.id, id);
    expect(user.userName, userName);
    expect(user.externalId, externalId);
    expect(user.photoUrl, null);
  });

  test('User.fromMap with all parameters', () {
    const String id = 'userId';
    const String externalId = 'userExternalId';
    const String userName = 'userName';
    const String photoUrl = 'userPhotoUrl';

    final Map map = {
      'id': id,
      'externalId': externalId,
      'userName': userName,
      'photoUrl': photoUrl
    };
    final User user = User.fromMap(map);

    expect(user.id, id);
    expect(user.userName, userName);
    expect(user.externalId, externalId);
    expect(user.photoUrl, photoUrl);
  });

  test('User.fromMap without externalId', () {
    const String id = 'userId';
    const String userName = 'userName';
    const String photoUrl = 'userPhotoUrl';

    final Map map = {'id': id, 'userName': userName, 'photoUrl': photoUrl};
    final User user = User.fromMap(map);

    expect(user.id, id);
    expect(user.userName, userName);
    expect(user.externalId, null);
    expect(user.photoUrl, photoUrl);
  });

  test('User.fromMap without photoUrl', () {
    const String id = 'userId';
    const String externalId = 'userExternalId';
    const String userName = 'userName';

    final Map map = {'id': id, 'externalId': externalId, 'userName': userName};
    final User user = User.fromMap(map);

    expect(user.id, id);
    expect(user.userName, userName);
    expect(user.externalId, externalId);
    expect(user.photoUrl, null);
  });

  test('User.toJson with all parameters', () {
    const String id = 'userId';
    const String externalId = 'userExternalId';
    const String userName = 'userName';
    const String photoUrl = 'userPhotoUrl';

    final Map<String, dynamic> map = {
      'externalId': externalId,
      'userName': userName,
      'photoUrl': photoUrl
    };
    final User user =
        User(id, userName, externalId: externalId, photoUrl: photoUrl);

    expect(user.toJson(), map);
  });

  test('User.toString with all parameters', () {
    const String id = 'userId';
    const String externalId = 'userExternalId';
    const String userName = 'userName';
    const String photoUrl = 'userPhotoUrl';

    final User user =
        User(id, userName, externalId: externalId, photoUrl: photoUrl);

    expect(user.toString(),
        'User{id: $id, externalId: $externalId, userName: $userName, photoUrl: $photoUrl}');
  });

  test('User.toString without externalId', () {
    const String id = 'userId';
    const String userName = 'userName';
    const String photoUrl = 'userPhotoUrl';

    final User user = User(id, userName, photoUrl: photoUrl);

    expect(user.toString(),
        'User{id: $id, externalId: ${null}, userName: $userName, photoUrl: $photoUrl}');
  });

  test('User.toString without photoUrl', () {
    const String id = 'userId';
    const String externalId = 'userExternalId';
    const String userName = 'userName';

    final User user = User(id, userName, externalId: externalId);

    expect(user.toString(),
        'User{id: $id, externalId: $externalId, userName: $userName, photoUrl: ${null}}');
  });
}
