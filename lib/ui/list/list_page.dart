import 'package:flutter/material.dart';
import 'package:flutter1/common/bloc/stack_questions_bloc.dart';
import 'package:flutter1/common/model/EventStatus.dart';

class ListPage extends StatefulWidget {
  ListPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {

  @override
  Widget build(BuildContext context) {
    var list = [
      EventStatus(1, "jestem w domu", ["a", "b", "c"])
    ];
    return Scaffold(
        appBar: AppBar(title: Text('Your friends')), body: EventsList(list));
  }

  Widget EventsList(List<EventStatus> list) {
    return Center(
        child: ListView(children: list.map((item) => EventRow(item)).toList()));
  }

  Widget EventRow(EventStatus item) {
    return Card(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(item.name),
              UsersIcons(item.userPhotoUrls)
            ]
        )
    );
  }

  Widget UsersIcons(List<String> icons) {
    return CircleAvatar(backgroundImage: NetworkImage(
        "https://lh6.googleusercontent.com/-YjRRGsiDyS8/AAAAAAAAAAI/AAAAAAAAAAA/ACHi3rcu2PDsha1A2cVzOea9jfd86EQN8A/s96-c/photo.jpg"));

  }

}
