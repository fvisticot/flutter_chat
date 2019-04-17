import 'package:equatable/equatable.dart';

class SearchUserEvent extends Equatable {
  String searchName;

  SearchUserEvent(this.searchName)
      : assert(searchName != null),
        super([searchName]);

  @override
  String toString() => 'SearchUserEvent $searchName';
}
