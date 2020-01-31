class Group {
  Group(this.id, this.users, {this.title});
  String id;
  String title;
  Map<String, String> users;

  @override
  String toString() {
    return 'Group{id: $id, users: $users, title: $title}';
  }
}
