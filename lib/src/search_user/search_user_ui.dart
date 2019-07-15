import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat/src/chat_service/chat_service.dart';
import 'package:flutter_chat/src/common/styles.dart';
import 'package:flutter_chat/src/group_management/group_management.dart';
import 'package:flutter_chat/src/models/models.dart';
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
        .dispatch(SearchUserWithName(_searchTextFieldEditingController.text));
  }

  @override
  void dispose() {
    _searchTextFieldEditingController.removeListener(searchListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchUserEvent, SearchUserState>(
        bloc: searchUserBloc,
        builder: (context, searchUserState) {
          if (searchUserState is SearchUserList) {
            final List<String> keys = searchUserState.users.keys.toList();
            return Column(
              children: <Widget>[
                _buildSearchBar(),
                (searchUserState.users.isNotEmpty)
                    ? Expanded(
                        child: ListView.builder(
                        itemCount: searchUserState.users.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (keys[index] != widget.currentUser.id) {
                            return _buildUserTile(keys[index],
                                searchUserState.users[keys[index]]);
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
              children: <Widget>[_buildSearchBar()],
            );
          }
        });
  }

  Widget _buildSearchBar() {
    return Container(
      child: Card(
        child: ListTile(
          leading: Icon(Icons.search),
          title: TextField(
            controller: _searchTextFieldEditingController,
            decoration: InputDecoration(
                hintText: 'Rechercher un utilisateur',
                border: InputBorder.none),
          ),
          trailing: IconButton(
            icon: Icon(Icons.cancel),
            onPressed: () {
              _searchTextFieldEditingController.clear();
            },
            color: Styles.mainColor,
          ),
        ),
      ),
    );
  }

  Widget _buildUserTile(userId, userName) {
    return ListTile(
      title: Text(userName),
      trailing: IconButton(
        icon: Icon(Icons.message),
        onPressed: () {
          searchUserBloc.dispatch(ChatWithUser(widget.currentUser.id, userId));
        },
        color: Styles.mainColor,
      ),
    );
  }
}
