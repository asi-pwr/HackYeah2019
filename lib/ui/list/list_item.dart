import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter1/common/model/stack_questions/item.dart';

class ListItem extends StatelessWidget {
  ListItem({Key key, this.index, this.model}) : super(key: key);

  final int index;
  final Item model;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.0,
      child: InkWell(
        onTap: () => _launchUrl(context, model.link),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Card(
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: FadeInImage.assetNetwork(
                        placeholder: 'assets/img/ic_stackoverflow.png',
                        image: model.owner.profileImageUrl ?? ''),
                  )
              ),
              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        flex: 4,
                        child: AutoSizeText("Q: " + model.title,
                          textAlign: TextAlign.start,
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                      Expanded(
                          flex: 3,
                          child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: model.tags.map((tag) =>
                                    Padding(
                                        padding: EdgeInsets.only(right: 4.0),
                                        child: Chip(
                                          label: Text(tag),
                                        )),
                                ).toList(),
                              )
                          )
                      )
                    ],
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _launchUrl(BuildContext context, String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Unable to lunch: " + url),
          );
        },
      );
    }
  }
}