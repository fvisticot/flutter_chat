import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat/src/chat_service/chat_service.dart';
import 'package:flutter_chat/src/common/styles.dart';
import 'package:flutter_chat/src/group_management/group_management.dart';
import 'package:flutter_chat/src/models/user.dart';
import 'package:flutter_chat/src/search_user/search_user.dart';

class SearchUserPage extends StatefulWidget {
  const SearchUserPage(
    this.chatService,
    this.currentUser,
    this.groupManagementBloc,
  )   : assert(chatService != null),
        assert(currentUser != null),
        assert(groupManagementBloc != null);
  final ChatService chatService;
  final User currentUser;
  final GroupManagementBloc groupManagementBloc;

  @override
  _SearchUserPageState createState() => _SearchUserPageState();
}

class _SearchUserPageState extends State<SearchUserPage> {
  TextEditingController _searchTextFieldEditingController;
  SearchUserBloc searchUserBloc;

  @override
  void initState() {
    _searchTextFieldEditingController = TextEditingController();
    searchUserBloc =
        SearchUserBloc(widget.chatService, widget.groupManagementBloc);
    _searchTextFieldEditingController.addListener(searchListener);
    super.initState();
  }

  void searchListener() {
    searchUserBloc
        .add(SearchUserWithName(_searchTextFieldEditingController.text));
  }

  @override
  void dispose() {
    _searchTextFieldEditingController.removeListener(searchListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchUserBloc, SearchUserState>(
      bloc: searchUserBloc,
      builder: (context, searchUserState) {
        if (searchUserState is SearchUserList) {
          final List<String> keys = searchUserState.users.keys.toList();
          return Column(
            children: <Widget>[
              _SearchBar(controller: _searchTextFieldEditingController),
              (searchUserState.users.isNotEmpty)
                  ? Expanded(
                      child: ListView.builder(
                      itemCount: searchUserState.users.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (keys[index] != widget.currentUser.id) {
                          return _UserTile(
                            bloc: searchUserBloc,
                            userName: searchUserState.users[keys[index]],
                            currentUid: widget.currentUser.id,
                            uid: keys[index],
                          );
                        } else {
                          return Container();
                        }
                      },
                    ))
                  : Container()
            ],
          );
        } else {
          _searchTextFieldEditingController.clear();
          return Column(
            children: <Widget>[
              _SearchBar(controller: _searchTextFieldEditingController),
            ],
          );
        }
      },
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({Key key, @required this.controller}) : super(key: key);
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        elevation: 5,
        child: ListTile(
          leading: Icon(Icons.search),
          title: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Rechercher un utilisateur',
              border: InputBorder.none,
            ),
          ),
          trailing: IconButton(
            icon: Icon(Icons.cancel),
            onPressed: () {
              controller.clear();
            },
            color: Styles.mainColor,
          ),
        ),
      ),
    );
  }
}

class _UserTile extends StatelessWidget {
  const _UserTile({
    Key key,
    @required this.bloc,
    @required this.userName,
    @required this.currentUid,
    @required this.uid,
  }) : super(key: key);
  final SearchUserBloc bloc;
  final String userName;
  final String currentUid;
  final String uid;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        userName,
        style: Styles.userTileText,
      ),
      trailing: Icon(
        Icons.message,
        color: Styles.mainColor,
      ),
      onTap: () {
        bloc.add(ChatWithUser(currentUid, uid));
      },
    );
  }
}
