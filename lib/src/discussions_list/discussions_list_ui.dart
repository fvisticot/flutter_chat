import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat/src/group_management/group_management.dart';
import 'package:flutter_chat/src/models/user.dart';
import 'package:flutter_chat/src/repositories/firebase_repository.dart';

import 'discussions_list.dart';

class DiscussionsListPage extends StatefulWidget {
  final FirebaseRepository firebaseRepository;
  final GroupManagementBloc groupManagementBloc;
  final User currentUser;

  DiscussionsListPage(
      this.firebaseRepository, this.groupManagementBloc, this.currentUser)
      : assert(firebaseRepository != null),
        assert(currentUser != null);

  @override
  _DiscussionsListPageState createState() => _DiscussionsListPageState();
}

class _DiscussionsListPageState extends State<DiscussionsListPage> {
  DiscussionsListBloc _discussionsListBloc;
  @override
  void initState() {
    super.initState();
    _discussionsListBloc = DiscussionsListBloc(widget.firebaseRepository,
        widget.groupManagementBloc, widget.currentUser.id);
    _discussionsListBloc.dispatch(GetDiscussionsList());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiscussionsListEvent, DiscussionsListState>(
        bloc: _discussionsListBloc,
        builder: (context, discussionsListState) {
          if (discussionsListState is DiscussionsInitial) {
            return Container();
          }
          if (discussionsListState is DiscussionsLoading) {
            return Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (discussionsListState is DiscussionsSuccess) {
            if (discussionsListState.discussions.length > 0) {
              List<String> keys =
                  discussionsListState.discussions.keys.toList();
              return ListView.builder(
                  itemCount: keys.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(discussionsListState.discussions[keys[index]]
                          ['title']),
                      subtitle: Text(
                        discussionsListState.discussions[keys[index]]
                            ['lastMsg'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: IconButton(
                          icon: Icon(Icons.message),
                          onPressed: () {
                            _discussionsListBloc.groupManagementBloc
                                .dispatch(NavigateToGroup(keys[index]));
                          }),
                    );
                  });
            } else {
              return Center(
                child: Text('No discussions available'),
              );
            }
          }
        });
  }
}
