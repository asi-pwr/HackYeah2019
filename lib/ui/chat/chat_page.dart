
import 'package:flutter/cupertino.dart';
import 'package:flutter1/common/bloc/chat_bloc.dart';

class ChatPage extends StatefulWidget {
  ChatPage(this.chatBloc, {Key key, this.title}): super(key:key);


  final ChatBloc chatBloc;
  final String title;

  @override
  State<StatefulWidget> createState() => _ChatPageState();


}
class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              buildListMessages(),
              buildInput()
            ],
          )
        ],
      )
    );
  }

  Widget buildListMessages(){
    return Text("");
  }

  Widget buildInput(){
    return Text("");
  }
}