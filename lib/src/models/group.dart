class Group {
  String id;
  String title;
  Map<String, String> users;

  Group(this.id, this.users, {this.title});

  Map<String, dynamic> toJson() => {
        'title': title,
      };

  @override
  String toString() {
    return 'Group{id: $id, users: $users, title: $title}';
  }
}