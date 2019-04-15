import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_chat/src/models/user.dart';

void main() {
  test('User constructor with all parameters', (){
    String id = 'userId';
    String externalId = 'userExternalId';
    String userName = 'userName';
    String photoUrl = "userPhotoUrl";

    User user = User(id, userName, externalId: externalId, photoUrl: photoUrl);

    expect(user.id, id);
    expect(user.userName, userName);
    expect(user.externalId, externalId);
    expect(user.photoUrl, photoUrl);
  });

  test('User constructor without externalId', (){
    String id = 'userId';
    String userName = 'userName';
    String photoUrl = "userPhotoUrl";

    User user = User(id, userName, photoUrl: photoUrl);

    expect(user.id, id);
    expect(user.userName, userName);
    expect(user.externalId, null);
    expect(user.photoUrl, photoUrl);
  });

  test('User constructor without photoUrl', (){
    String id = 'userId';
    String userName = 'userName';
    String externalId = 'userExternalId';

    User user = User(id, userName, externalId: externalId);

    expect(user.id, id);
    expect(user.userName, userName);
    expect(user.externalId, externalId);
    expect(user.photoUrl, null);
  });

  test('User.fromMap with all parameters', (){
    String id = 'userId';
    String externalId = 'userExternalId';
    String userName = 'userName';
    String photoUrl = "userPhotoUrl";

    Map map = {'id':id, 'externalId':externalId, 'userName':userName, 'photoUrl':photoUrl};
    User user = User.fromMap(map);

    expect(user.id, id);
    expect(user.userName, userName);
    expect(user.externalId, externalId);
    expect(user.photoUrl, photoUrl);
  });

  test('User.fromMap without externalId', (){
    String id = 'userId';
    String userName = 'userName';
    String photoUrl = "userPhotoUrl";

    Map map = {'id':id, 'userName':userName, 'photoUrl':photoUrl};
    User user = User.fromMap(map);

    expect(user.id, id);
    expect(user.userName, userName);
    expect(user.externalId, null);
    expect(user.photoUrl, photoUrl);
  });

  test('User.fromMap without photoUrl', (){
    String id = 'userId';
    String externalId = 'userExternalId';
    String userName = 'userName';

    Map map = {'id':id, 'externalId':externalId, 'userName':userName};
    User user = User.fromMap(map);

    expect(user.id, id);
    expect(user.userName, userName);
    expect(user.externalId, externalId);
    expect(user.photoUrl, null);
  });

  test('User.toJson with all parameters', (){
    String id = 'userId';
    String externalId = 'userExternalId';
    String userName = 'userName';
    String photoUrl = "userPhotoUrl";

    Map<String, dynamic> map = {'externalId': externalId, 'userName': userName, 'photoUrl': photoUrl};
    User user = User(id, userName, externalId: externalId, photoUrl: photoUrl);

    expect(user.toJson(), map);
  });

  test('User.toString with all parameters', (){
    String id = 'userId';
    String externalId = 'userExternalId';
    String userName = 'userName';
    String photoUrl = "userPhotoUrl";

    User user = User(id, userName, externalId: externalId, photoUrl: photoUrl);

    expect(user.toString(), 'User{id: $id, externalId: $externalId, userName: $userName, photoUrl: $photoUrl}');
  });

  test('User.toString without externalId', (){
    String id = 'userId';
    String userName = 'userName';
    String photoUrl = "userPhotoUrl";

    User user = User(id, userName, photoUrl: photoUrl);

    expect(user.toString(), 'User{id: $id, externalId: ${null}, userName: $userName, photoUrl: $photoUrl}');
  });

  test('User.toString without photoUrl', (){
    String id = 'userId';
    String externalId = 'userExternalId';
    String userName = 'userName';

    User user = User(id, userName, externalId: externalId);

    expect(user.toString(), 'User{id: $id, externalId: $externalId, userName: $userName, photoUrl: ${null}}');
  });

}