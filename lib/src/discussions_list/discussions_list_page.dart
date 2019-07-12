import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat/src/common/styles.dart';
import 'package:flutter_chat/src/group_management/group_management.dart';
import 'package:flutter_chat/src/models/user.dart';
import 'package:flutter_chat/src/repositories/chat_firebase_repository.dart';

import 'discussions_list.dart';

class DiscussionsListPage extends StatefulWidget {
  const DiscussionsListPage(
    this.firebaseRepository,
    this.groupManagementBloc,
    this.currentUser,
  )   : assert(firebaseRepository != null),
        assert(currentUser != null);
  final ChatFirebaseRepository firebaseRepository;
  final GroupManagementBloc groupManagementBloc;
  final User currentUser;

  @override
  _DiscussionsListPageState createState() => _DiscussionsListPageState();
}

class _DiscussionsListPageState extends State<DiscussionsListPage> {
  DiscussionsListBloc _discussionsListBloc;
  @override
  void initState() {
    super.initState();
    _discussionsListBloc = DiscussionsListBloc(
      widget.firebaseRepository,
      widget.groupManagementBloc,
      widget.currentUser.id,
    );
    _discussionsListBloc.dispatch(GetDiscussionsList());
  }

  @override
  void dispose() {
    _discussionsListBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiscussionsListEvent, DiscussionsListState>(
        bloc: _discussionsListBloc,
        builder: (context, discussionsListState) {
          if (discussionsListState is DiscussionsInitial) {
            return Container();
          }
          if (discussionsListState is DiscussionsSuccess) {
            if (discussionsListState.discussions.isNotEmpty) {
              final List<String> keys =
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
                        },
                        color: Styles.mainColor,
                      ),
                      onTap: () {
                        _discussionsListBloc.groupManagementBloc
                            .dispatch(NavigateToGroup(keys[index]));
                      },
                    );
                  });
            } else {
              return Center(
                child: const Text('No discussions available'),
              );
            }
          } else {
            return Center(
              child: const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
