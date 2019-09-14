import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
                'Flutter tests/samples:',
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: RaisedButton(
                child: Text(
                  'Network fetched list + local RAM cache',
                ),
                onPressed: (){
                  Navigator.pushNamed(context, '/list');
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: RaisedButton(
                child: Text(
                  'My room',
                ),
                onPressed: (){
                  Navigator.pushNamed(context, '/room', arguments: "globalRoom"); //todo local room name
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: RaisedButton(
                child: Text(
                  'Firebase login',
                ),
                onPressed: (){
                  Navigator.pushNamed(context, '/login');
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
