import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat/src/chat_service/chat_service.dart';
import 'package:flutter_chat/src/common/styles.dart';
import 'package:flutter_chat/src/group_management/group_management.dart';
import 'package:flutter_chat/src/models/discussion.dart';
import 'package:flutter_chat/src/models/user.dart';

import 'discussions_list.dart';

class DiscussionsListPage extends StatefulWidget {
  const DiscussionsListPage(
    this.chatService,
    this.groupManagementBloc,
    this.currentUser,
  )   : assert(chatService != null),
        assert(currentUser != null);
  final ChatService chatService;
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
      widget.chatService,
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
              final List<Discussion> discussions =
                  discussionsListState.discussions;
              return ListView.builder(
                itemCount: discussionsListState.discussions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(discussions[index].title),
                    subtitle: Text(
                      discussions[index].lastMessage,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.message),
                      onPressed: () {
                        _discussionsListBloc.groupManagementBloc.dispatch(
                            NavigateToGroup(discussions[index].groupId));
                      },
                      color: Styles.mainColor,
                    ),
                    onTap: () {
                      _discussionsListBloc.groupManagementBloc.dispatch(
                          NavigateToGroup(discussions[index].groupId));
                    },
                  );
                },
              );
            } else {
              return Center(
                child: const Text('Vous n\'avez pas de discussion'),
              );
            }
          } else if (discussionsListState is DiscussionsError) {
            return Center(
              child: Text(discussionsListState.error),
            );
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
