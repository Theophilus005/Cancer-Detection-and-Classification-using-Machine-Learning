import 'dart:convert';

import 'package:cancer/screens/loading.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import 'package:http/http.dart' as http;

class Predict extends StatefulWidget {
  const Predict({super.key, required this.id});
  final String id;

  @override
  State<Predict> createState() => _PredictState();
}




class _PredictState extends State<Predict> {

  List details = [];
  bool isLoading = true;

    //Fetch Users
  Future fetchDetails() async {
    String id = widget.id;
    print(id);
    http.Response response;
    response = await http
        .get(Uri.parse('https://cancer-0269.restdb.io/rest/patients?q={"_id": "$id"}'), headers: {
      'content-type': "application/json",
      'x-apikey': "b94869cad9c05798c0282f577707871a8db92",
      'cache-control': "no-cache"
    });
    print(response.statusCode);
    if (response.statusCode == 200) {
      setState(() {
        details = json.decode(response.body);
        print(details);
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchDetails();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? const LoadingScreen() : Scaffold(
        appBar: AppBar(
          title: const Text("Results from model"),
          elevation: 0.0,
          backgroundColor: theme,
        ),
        backgroundColor: theme,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: SizedBox(
                    height: 240, child: Image.asset("images/img2.png"))),

            //Patient Details
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 20, bottom: 10),
              child: Text("Patient Details", style: textStyle),
            ),

            //Patient Name
            Detail(type: "Patient Name", value: details[0]["patient_name"]),
            Detail(type: "Sex", value: details[0]["patient_sex"]),
            Detail(type: "Age", value: details[0]["patient_age"]),

            //Cancer Status
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 20, bottom: 10),
              child: Text("Cancer Status", style: textStyle),
            ),

            //Patient Name
            Detail(type: "Cancer Type", value: details[0]["cancer_type"]),
            Detail(type: "Category", value: details[0]["class_name"]),
            Detail(type: "Confidence", value: details[0]["confidence2"].toString()),

            const SizedBox(height: 20),
            //Print Button
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              height: 40,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.white),
              child: const Center(
                child: Text("Print Results"),
              ),
            ),
          ],
        ));
  }
}

class Detail extends StatelessWidget {
  const Detail({super.key, required this.type, required this.value});

  final String type;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Text("$type: ", style: textStyle.copyWith(fontSize: 20)),
          Text(value, style: textStyle.copyWith(fontSize: 20)),
        ],
      ),
    );
  }
}
