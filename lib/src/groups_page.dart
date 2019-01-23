import 'package:flutter/material.dart';
import 'package:flutter_chat/flutter_chat.dart';

class GroupsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  @override
  void initState() {
    super.initState();
  }

  _userGroups() async {
    List<Group> groups = await Chat().userGroups();
    print(groups);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
          future: Chat().userGroups(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Text('Loading'),
              );
            } else {
              final groups = snapshot.data;
              return ListView.separated(
                //controller: _scrollController,
                physics: ClampingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: groups.length,
                separatorBuilder: (BuildContext context, int index) {
                  return Divider();
                },
                itemBuilder: (BuildContext context, int index) {
                  Group group = groups[index];
                  return GestureDetector(
                      onTap: () {
                        _displayChat(group.id);
                      },
                      child: _buildGroupTile(group));
                },
              );
            }
          }),
    );
  }

  _buildGroupTile(Group group) {
    return ListTile(
      title: Text(group.name),
    );
  }

  _displayChat(String groupId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) {
          return ChatPage(groupId);
        },
      ),
    );
  }
}
