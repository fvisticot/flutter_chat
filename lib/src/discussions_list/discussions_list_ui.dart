import 'package:flutter/material.dart';

class DiscussionsListPage extends StatefulWidget {
  @override
  _DiscussionsListPageState createState() => _DiscussionsListPageState();
}

class _DiscussionsListPageState extends State<DiscussionsListPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> discussions = {
      "id1": {
        "title": "Title group 1",
        "lastMsg": "Bonjour à tous",
        "updatedAt": "2019-04-18T15:23:19.300035"
      },
      "id2": {
        "title": "Title group 1",
        "lastMsg": "Bonjour à tous",
        "updatedAt": "2019-04-18T15:24:19.300035"
      },
    };
    List<String> keys = discussions.keys.toList();
    return ListView.builder(
        itemCount: discussions.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(discussions[keys[index]]['title']),
            subtitle: Text(discussions[keys[index]]['lastMsg']),
          );
        });
  }
}
