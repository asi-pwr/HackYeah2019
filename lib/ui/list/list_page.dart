import 'package:flutter/material.dart';
import 'package:flutter1/common/bloc/stack_questions_bloc.dart';
import 'package:flutter1/common/model/stack_questions/stack_questions.dart';
import 'package:flutter1/ui/list/list_item.dart';

class ListPage extends StatefulWidget {
  ListPage(this.stackQuestionsBloc, {Key key, this.title}) : super(key: key);

  final StackQuestionsBloc stackQuestionsBloc;
  final String title;

  @override
  State<StatefulWidget> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  Future<void> _refreshStackQuestions() async {
    widget.stackQuestionsBloc.requestStackQuestions(forceUpdate: true);
  }

  @override
  Widget build(BuildContext context) {
    var list = ["one", "two", "three", "four"];
    return Scaffold(
        appBar: AppBar(title: Text('Your friends')),
        body: Center(
            child: ListView(
                children: list
                    .map((item) => new Card(
                            child: Row(children: <Widget>[
                          Text(item),
                          Align(
                              alignment: Alignment.centerRight,
                              child: Text("xd"))
                        ])))
                    .toList())));
  }

//      new Column(children: list.map((item) => new Card(child: Text(item))).toList());

  Widget _listViewBuilder(StackQuestions response) {
    return ListView.separated(
        itemCount: response.items.length,
        padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
        itemBuilder: (BuildContext context, int index) =>
            ListItem(index: index, model: response.items[index]),
        separatorBuilder: (BuildContext context, int index) => const Divider());
  }

  Widget _fetchErrorMsg(Exception e) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(12.0),
          child: Expanded(
            child: Card(
              child: Text("Unable to fetch: " + e.toString()),
            ),
          ),
        ),
      ],
    );
  }
}
