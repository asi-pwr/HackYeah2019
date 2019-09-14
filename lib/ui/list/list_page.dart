import 'package:flutter/material.dart';
import 'package:flutter1/common/bloc/stack_questions_bloc.dart';
import 'package:flutter1/common/model/stack_questions/stack_questions.dart';
import 'package:flutter1/common/rx/rx_response.dart';
import 'package:flutter1/common/rx/rx_status.dart';
import 'package:flutter1/ui/list/list_item.dart';

class ListPage extends StatefulWidget {
  ListPage(this.stackQuestionsBloc, {Key key, this.title}): super(key: key);

  final StackQuestionsBloc stackQuestionsBloc;
  final String title;

  @override
  State<StatefulWidget> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage>{

  bool _activeSearchBar;

  @override
  void initState() {
    super.initState();
    _activeSearchBar = false;
    widget.stackQuestionsBloc.requestStackQuestions(forceUpdate: false);
  }

  Future<void> _refreshStackQuestions() async {
    widget.stackQuestionsBloc.requestStackQuestions(forceUpdate: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: RefreshIndicator(
        child: StreamBuilder(
          stream: widget.stackQuestionsBloc.questionStream,
            builder: (context, AsyncSnapshot<RxResponse<StackQuestions>> snapshot) {
              if (snapshot.hasData && snapshot.data.status == RxStatus.SUCCESS) {
                return _listViewBuilder(snapshot.data.data);
              } else if (snapshot.hasError || snapshot.data?.status == RxStatus.ERROR) {
                return _fetchErrorMsg(snapshot.error);
              }
              return Center(child: CircularProgressIndicator());
            }),
        onRefresh: _refreshStackQuestions,
      ),
    );
  }

  Widget _appBar() {
    return !_activeSearchBar ?
    AppBar(
      title: Text(widget.stackQuestionsBloc.lastSearch() != null
          ? "Tag: " + widget.stackQuestionsBloc.lastSearch()
          : widget.title),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () => setState(() => _activeSearchBar = true),
        ),
      ],
    ) : AppBar(
      leading: Icon(Icons.search),
      title: TextFormField(
          initialValue: widget.stackQuestionsBloc.lastSearch(),
          decoration: InputDecoration(
            hintText: "Search stack question topic",
          ),
          autofocus: true,
          onFieldSubmitted: (input) {
            widget.stackQuestionsBloc.requestStackQuestions(
                search: input, forceUpdate: true);
            setState(() => _activeSearchBar = false);
          }),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.close),
          onPressed: () => setState(() => _activeSearchBar = false),
        ),
      ],
    );
  }

  Widget _listViewBuilder(StackQuestions response){
    return ListView.separated(
        itemCount: response.items.length,
        padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
        itemBuilder: (BuildContext context, int index) =>
            ListItem(index: index, model: response.items[index]),
        separatorBuilder: (BuildContext context,
            int index) => const Divider());
  }

  Widget _fetchErrorMsg(Exception e) {
    return Column(children: <Widget>[
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

  @override
  void dispose() {
    super.dispose();
    widget.stackQuestionsBloc.dispose();
  }
}