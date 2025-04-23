import 'package:flutter/material.dart';
import 'package:ibh/api_handle/Register/ApiHandling.dart';


class Testdata extends StatefulWidget {
  const Testdata({super.key});

  @override
  State<Testdata> createState() => _TestdataState();
}

class _TestdataState extends State<Testdata> {
  @override
  void initState() {
    super.initState();

    APIHandling().fetchCityData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(),
    );
  }
}
