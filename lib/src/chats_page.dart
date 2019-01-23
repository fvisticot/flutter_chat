import 'package:flutter/material.dart';
import 'package:flutter_chat/flutter_chat.dart';

class ChatsPage extends StatefulWidget {
  ChatsPage();

  @override
  State<StatefulWidget> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  TextEditingController _searchTextFieldEditingController =
      TextEditingController();
  bool _isSearching = false;
  List<User> _selectedUsers = [];
  FocusNode _focus = FocusNode();
  Chat _chat;

  @override
  void initState() {
    _chat = Chat();

    _searchTextFieldEditingController.addListener(() {
      setState(() {
        _isSearching = _searchTextFieldEditingController.text.length > 0;
      });
    });

    _tabController = new TabController(vsync: this, length: 2);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          ;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        title: Text('Chats'),
        /*actions: [
          IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                _displayNewMessage();
              })
        ],*/
        bottom: TabBar(
          controller: _tabController,
          isScrollable: false,
          indicatorColor: Colors.red,
          tabs: [
            Tab(text: 'Contacts'),
            //Tab(text: 'Actifs'),
            Tab(text: 'Groups')
          ],
        ),
      ),
      body: _buildPage(),
      floatingActionButton: (_tabController.index == 1)
          ? FloatingActionButton(
              child: new Icon(Icons.add),
              onPressed: () {
                _displayAddGroup();
              })
          : Container(),
    );
  }

  Widget _buildPage() {
    return TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: [
          _buildContactsPage(),
          //_buildActifsPage(),
          _buildGroupsPage()
        ]);
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

  Widget _buildContactsPage() {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        _buildSearchBar(),
        _isSearching ? _buildUsers() : _buildContacts(),
        _isSearching && _selectedUsers.length > 0
            ? _buildSelectedUsers()
            : Container(),
      ],
    ));
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
                child: Text('Add to contact'),
                onPressed: () async {
                  final usersIds =
                      _selectedUsers.map((user) => user.id).toList();
                  await _chat.createContacts(usersIds);
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

  Widget _buildUsers() {
    return Flexible(
      child: StreamBuilder<List<User>>(
          stream: _chat.users(exceptUsersIds: [
            _chat.user.id
          ], filter: Filter(startWith: _searchTextFieldEditingController.text)),
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

  Widget _buildContacts() {
    return Flexible(
      child: FutureBuilder<List<Contact>>(
          future: _chat.contacts(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Text('No data');
            } else {
              List<Contact> contacts = snapshot.data;
              return ListView.separated(
                  //controller: _scrollController,
                  physics: ClampingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: contacts.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider();
                  },
                  itemBuilder: (BuildContext context, int index) {
                    Contact contact = contacts[index];
                    return Dismissible(
                      background: Container(color: Colors.red),
                      key: Key(contact.userId),
                      onDismissed: (direction) async {
                        await _chat.removeContact(contact.userId);
                        print('====>contact removed, rebuild');
                        setState(() {});
                      },
                      child: GestureDetector(
                          onTap: () async {
                            print('ContactId: ${contact.userId}');
                            String groupId =
                                _chat.groupForContact(contact.userId);
                            print('GroupID: $groupId');
                            _displayChat(groupId);
                          },
                          child: _buildContact(contact.userId)),
                    );
                  });
            }
          }),
    );
  }

  _buildContact(String userId) {
    return FutureBuilder<User>(
      future: _chat.userById(userId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        User user = snapshot.data;
        return ListTile(
          leading: Utils.buildAvatar(user),
          title: Text('${user.firstName} ${user.lastName}'),
        );
      },
    );
  }

  /*
  _buildInline() {
    return Container(
      child: ListView.separated(
        //controller: _scrollController,
        physics: ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            width: 2.0,
          );
        },
        itemBuilder: (BuildContext context, int index) {
          final contact = widget.contacts[index];
          return GestureDetector(
            onTap: () {
              ;
            },
            child: CircleAvatar(child: Text('F')),
          );
        },
      ),
    );
  }
  */

  _buildActifsPage() {
    return Text('Actifs');
  }

  _buildGroupsPage() {
    return GroupsPage();
  }

  _displayAddGroup() {
    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) {
          return NewGroupPage();
        },
      ),
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
