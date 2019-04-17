import 'package:flutter/material.dart';
import 'package:flutter_chat/src/models/user.dart';
import 'package:flutter_chat/src/repositories/firebase_repository.dart';
import 'package:flutter_chat/src/search_user/search_user.dart';
import 'package:flutter_chat/src/search_user/search_user_ui.dart';

class ChatHomePage extends StatefulWidget {
  FirebaseRepository firebaseRepository;
  User currentUser;

  ChatHomePage(this.firebaseRepository, this.currentUser)
      : assert(firebaseRepository != null),
        assert(currentUser != null);

  @override
  _ChatHomePageState createState() => _ChatHomePageState();
}

class _ChatHomePageState extends State<ChatHomePage> {
  SearchUserBloc searchUserBloc;

  TextEditingController _searchTextFieldEditingController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    searchUserBloc = SearchUserBloc(widget.firebaseRepository);
    _searchTextFieldEditingController.addListener(() {
      searchUserBloc
          .dispatch(SearchUserEvent(_searchTextFieldEditingController.text));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Chat'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _buildSearchBar(),
            Expanded(child: SearchUserResults(searchUserBloc))
          ],
        ));
  }

  Widget _buildSearchBar() {
    return Container(
      child: new Card(
        child: new ListTile(
          leading: new Icon(Icons.search),
          title: new TextField(
            controller: _searchTextFieldEditingController,
            decoration: new InputDecoration(
                hintText: 'Rechercher', border: InputBorder.none),
          ),
          trailing: new IconButton(
            icon: new Icon(Icons.cancel),
            onPressed: () {
              _searchTextFieldEditingController.clear();
            },
          ),
        ),
      ),
    );
  }
}
