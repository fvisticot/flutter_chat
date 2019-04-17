import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'search_user.dart';

class SearchUserResults extends StatefulWidget {
  final SearchUserBloc searchUserBloc;

  SearchUserResults(this.searchUserBloc) : assert(searchUserBloc != null);

  @override
  _SearchUserResultsState createState() => _SearchUserResultsState();
}

class _SearchUserResultsState extends State<SearchUserResults> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchUserEvent, SearchUserState>(
        bloc: widget.searchUserBloc,
        builder: (context, searchUserState) {
          if (searchUserState is SearchUserList) {
            if (searchUserState.users.length == 0) {
              return Container();
            } else {
              List<String> keys = searchUserState.users.keys.toList();
              return ListView.builder(
                  itemCount: searchUserState.users.length,
                  itemBuilder: (BuildContext context, int index) =>
                      _buildUserTile(
                          keys[index], searchUserState.users[keys[index]]));
            }
          } else {
            return Container();
          }
        });
  }

  Widget _buildUserTile(userId, userName) {
    return ListTile(
      title: Text(userName),
      trailing: IconButton(icon: Icon(Icons.message), onPressed: null),
    );
  }
}
