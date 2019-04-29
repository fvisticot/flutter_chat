import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat/src/group_management/group_management.dart';
import 'package:flutter_chat/src/models/models.dart';
import 'package:flutter_chat/src/repositories/firebase_repository.dart';

import 'search_user.dart';

class SearchUserPage extends StatefulWidget {
  final FirebaseRepository firebaseRepository;
  final User currentUser;
  final GroupManagementBloc groupManagementBloc;

  SearchUserPage(
      this.firebaseRepository, this.currentUser, this.groupManagementBloc)
      : assert(firebaseRepository != null),
        assert(currentUser != null),
        assert(groupManagementBloc != null);

  @override
  _SearchUserPageState createState() => _SearchUserPageState();
}

class _SearchUserPageState extends State<SearchUserPage> {
  TextEditingController _searchTextFieldEditingController =
      TextEditingController();
  SearchUserBloc searchUserBloc;

  @override
  void initState() {
    searchUserBloc =
        SearchUserBloc(widget.firebaseRepository, widget.groupManagementBloc);
    _searchTextFieldEditingController.addListener(() {
      searchUserBloc
          .dispatch(SearchUserWithName(_searchTextFieldEditingController.text));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchUserEvent, SearchUserState>(
        bloc: searchUserBloc,
        builder: (context, searchUserState) {
          if (searchUserState is SearchUserList) {
            List<String> keys = searchUserState.users.keys.toList();
            return Column(
              children: <Widget>[
                _buildSearchBar(),
                (searchUserState.users.length != 0)
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
                hintText: 'Search username', border: InputBorder.none),
          ),
          trailing: IconButton(
            icon: Icon(Icons.cancel),
            onPressed: () {
              _searchTextFieldEditingController.clear();
            },
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
            searchUserBloc
                .dispatch(ChatWithUser(widget.currentUser.id, userId));
          }),
    );
  }
}
