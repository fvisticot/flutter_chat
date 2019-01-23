import 'package:flutter/material.dart';
import 'package:flutter_chat/flutter_chat.dart';

class NewGroupPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NewGroupPageState();
}

class _NewGroupPageState extends State<NewGroupPage> {
  Chat _chat;
  TextEditingController _searchTextFieldEditingController =
      TextEditingController();
  bool _isSearching = false;
  List<User> _selectedUsers = [];
  FocusNode _focus = FocusNode();
  GroupCreationWidget _groupCreationWidget;

  @override
  void initState() {
    _chat = Chat();

    _searchTextFieldEditingController.addListener(() {
      setState(() {
        _isSearching = _searchTextFieldEditingController.text.length > 0;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New group'),
      ),
      body: _buildPage(),
    );
  }

  Widget _buildPage() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _buildNewGroup(),
          _buildSearchBar(),
          _buildUsers(),
          _selectedUsers.length > 0 ? _buildSelectedUsers() : Container(),
        ],
      ),
    );
  }

  Widget _buildNewGroup() {
    _groupCreationWidget = GroupCreationWidget();
    return _groupCreationWidget;
  }

  Widget _buildSearchBar() {
    return Container(
      color: Theme.of(context).secondaryHeaderColor,
      child: new Padding(
        padding: const EdgeInsets.all(0),
        child: new Card(
          child: new ListTile(
            contentPadding: EdgeInsets.only(left: 5, right: 0),
            leading: new Icon(Icons.search),
            title: new TextField(
              focusNode: _focus,
              //autofocus: _isSearching,
              controller: _searchTextFieldEditingController,
              decoration: new InputDecoration(
                  hintText: 'Rechercher', border: InputBorder.none),
            ),
            trailing: new IconButton(
              icon: new Icon(Icons.cancel),
              onPressed: () {
                _searchTextFieldEditingController.clear();
                //onSearchTextChanged('');
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUsers() {
    return Flexible(
      child: StreamBuilder<List<User>>(
          stream: _chat.users(
            exceptUsersIds: [_chat.user.id],
            filter: Filter(startWith: _searchTextFieldEditingController.text),
          ),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Text('No data');
            } else {
              List<User> users = snapshot.data;
              return ListView.separated(
                  //controller: _scrollController,
                  physics: ClampingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: users.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider();
                  },
                  itemBuilder: (BuildContext context, int index) {
                    User user = users[index];
                    return GestureDetector(
                        onTap: () async {
                          print('UserId: ${user.id}');
                        },
                        child: _buildUser(user));
                  });
            }
          }),
    );
  }

  Widget _buildUser(User user) {
    return ListTile(
      leading: Utils.buildAvatar(user),
      title: Text('${user.firstName} ${user.lastName}'),
      trailing: Checkbox(
        value: _selectedUsers.contains(user) ? true : false,
        onChanged: (value) {
          if (value) {
            _selectedUsers.add((user));
          } else {
            _selectedUsers.remove(user);
          }
          setState(() {});
        },
      ),
    );
  }

  Widget _buildSelectedUsers() {
    return SafeArea(
      child: Container(
          padding: EdgeInsets.all(8),
          height: 50,
          child: Row(
            children: <Widget>[
              Flexible(
                child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      User user = _selectedUsers[index];
                      return GestureDetector(
                        child: Utils.buildAvatar(user),
                        onTap: () {
                          _selectedUsers.remove(user);
                          setState(() {});
                        },
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Container(
                        width: 2,
                      );
                    },
                    itemCount: _selectedUsers.length),
              ),
              RaisedButton(
                child: Text('Create group'),
                onPressed: () async {
                  final usersIds =
                      _selectedUsers.map((user) => user.id).toList();
                  await _chat.createGroup(
                      _groupCreationWidget.name, _selectedUsers);
                  _selectedUsers.clear();
                  _isSearching = false;
                  _focus.unfocus();
                  _searchTextFieldEditingController.clear();
                },
              )
            ],
          )),
    );
  }
}

class GroupCreationWidget extends StatefulWidget {
  String _name;

  @override
  State<StatefulWidget> createState() => _GroupCreationWidgetState();

  String get name {
    return _name;
  }
}

class _GroupCreationWidgetState extends State<GroupCreationWidget> {
  TextEditingController _textEditingController = TextEditingController();
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    _textEditingController.addListener(() {
      widget._name = _textEditingController.text;
    });
    super.initState();
  }

  @override
  void didUpdateWidget(GroupCreationWidget oldWidget) {
    widget._name = _textEditingController.text;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: () => print('coucou'),
          ),
          Flexible(
              child: TextField(
            style: TextStyle(
              color: Colors.black,
              fontSize: 15.0,
            ),
            controller: _textEditingController,
            decoration: InputDecoration.collapsed(
              hintText: 'Group name',
              hintStyle: TextStyle(color: Colors.grey),
            ),
            focusNode: _focusNode,
          ))
        ],
      ),
    );
  }
}
