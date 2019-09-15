//
//
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter1/common/bloc/chat_bloc.dart';

class ChatPage extends StatefulWidget {
  ChatPage(this.chatBloc, {Key key, this.title}) : super(key: key);

  final ChatBloc chatBloc;
  final String title;

  @override
  State<StatefulWidget> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController textEditingController =
      new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: WillPopScope(
            child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[buildListMessages(), buildInput()],
            )
          ],
        )));
  }

  Widget buildListMessages() {
    return Flexible(
      child: Center(
          child: StreamBuilder(
              stream: widget.chatBloc.continuousMessagesStream(),
              builder: (context, snapshot) {
                print(context.widget);
                print(snapshot.data);
                print("BBBBBBBBBBBBBBBB");
                if (snapshot.hasData && snapshot.data.documents.length != 0) {
                  return _listViewBuilder(snapshot);
                }
                return Center(
                    child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text("This chat is empty!"),
                ));
              })),
    );
  }

  void onSendMessage(String content, int type) {
    if (content.trim() != '') {
      textEditingController.clear();

      widget.chatBloc.sendMessage("globalRoom", content);
    } else {
      print('Nothing to send');
    }
  }

//
  Widget _listViewBuilder(AsyncSnapshot<QuerySnapshot> snapshot) {
//    return Text("");
    return ListView.builder(
        itemBuilder: (context, index) =>
//        index < snapshot.data.documents.length
//            ?
            _buildMessage(index, snapshot.data.documents[index != null ? index : 0]));
//            : _buildMessage(snapshot.data.documents.length,
//                snapshot.data.documents[snapshot.data.documents.length]));
  }

//
  Widget _buildMessage(int index, DocumentSnapshot document) {
    print(index);
    print(document);
    print("AAAAAAAAAAAAAAAAA");
    return Row(
      children: <Widget>[
        Container(
          child: Text(document['content']),
        )
      ],
    );
  }

  Widget buildInput() {
    return Container(
        child: Row(
          children: <Widget>[
            // Button send image

            // Edit text
            Flexible(
              child: Container(
                padding: EdgeInsets.all(13.0),
                child: TextField(
                  controller: textEditingController,
                  decoration: InputDecoration.collapsed(
                    hintText: 'Type your message...',
                  ),
                ),
              ),
            ),

            // Button send message
            Material(
              child: new Container(
                margin: new EdgeInsets.symmetric(horizontal: 8.0),
                child: new IconButton(
                  icon: new Icon(Icons.send),
                  onPressed: () => onSendMessage(textEditingController.text, 0),
                ),
              ),
              color: Colors.white,
            ),
          ],
        ),
        width: double.infinity,
        height: 50.0);
//        border: new Border(top: new BorderSide(color: greyColor2, width: 0.5)), color: Colors.white),
  }
}
