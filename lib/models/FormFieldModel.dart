import 'package:flutter/widgets.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class FormFieldModel {
  String textValue;
  TextEditingController specificationCtr;
  RxList<String> reportTypeId;
  RxnString error; // ✅ Use RxnString for nullable reactive string

  FormFieldModel({
    required this.textValue,
    required this.specificationCtr,
    required this.reportTypeId,
    String? error,
  }) : error = RxnString(error);
}
