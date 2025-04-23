import 'package:flutter/material.dart';
import 'package:ibh/componant/parentWidgets/CustomeParentBackground.dart';

class Introscreen extends StatefulWidget {
  const Introscreen({super.key});

  @override
  State<Introscreen> createState() => _IntroscreenState();
}

class _IntroscreenState extends State<Introscreen> {
  @override
  Widget build(BuildContext context) {
    return CustomParentScaffold(
      onWillPop: () async {
        return true;
      },
      body: Column(
        children: [Text('Intro Screen')],
      ),
    );
  }
}
