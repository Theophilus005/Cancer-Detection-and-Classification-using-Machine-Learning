import 'dart:convert';
import 'package:cancer/constants.dart';
import 'package:cancer/screens/loading.dart';
import 'package:cancer/screens/login.dart';
import 'package:cancer/screens/predict.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;

class Records extends StatefulWidget {
  const Records({super.key});

  @override
  State<Records> createState() => _RecordsState();
}

class _RecordsState extends State<Records> {
  List records = [];
  bool isLoading = true;

  dynamic checkAuth() async {
    var session = FlutterSession();
    return await session.get("id");
  }

  Future fetchRecords() async {
    http.Response response;
    response = await http.get(
        Uri.parse("https://cancer-0269.restdb.io/rest/patients"),
        headers: {
          'content-type': "application/json",
          'x-apikey': "b94869cad9c05798c0282f577707871a8db92",
          'cache-control': "no-cache"
        });
    if (response.statusCode == 200) {
      setState(() {
        records = json.decode(response.body);
        isLoading = false;
      });
    }
  }

  //Delete User
  Future deleteRecord(String id) async {
    setState(() {
      isLoading = true;
    });
    http.Response response;
    response = await http.delete(
        Uri.parse("https://cancer-0269.restdb.io/rest/patients/$id"),
        headers: {
          'content-type': "application/json",
          'x-apikey': "b94869cad9c05798c0282f577707871a8db92",
          'cache-control': "no-cache"
        });
    print(response.statusCode);
    if (response.statusCode == 200) {
      await fetchRecords();
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    fetchRecords();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const LoadingScreen()
        : Scaffold(
            appBar: AppBar(
              title: const Text("Records"),
              elevation: 0.0,
              backgroundColor: theme,
            ),
            backgroundColor: theme,
            body: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.33,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 190, 190, 190),
                      ),
                      child: const Center(child: Text("Patient")),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.33,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 190, 190, 190),
                      ),
                      child: const Center(
                        child: Text("Date"),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.33,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 190, 190, 190),
                      ),
                      child: const Center(
                        child: Text("Delete"),
                      ),
                    ),
                  ],
                ),

                ListView.builder(
                    itemCount: records.length,
                    shrinkWrap: true,
                    itemBuilder: ((context, index) {
                      String date = records[index]["date"];
                      String name = records[index]["patient_name"];
                      return GestureDetector(
                        onTap: () => Navigator.push(context, CupertinoPageRoute(builder: (context) => Predict(id: records[index]["_id"],))),
                        child: Record(
                          username: name,
                          date: date.substring(0, 10),
                          delete: () => {
                            deleteRecord(records[index]["_id"]),
                          },
                        ),
                      );
                    }))
                //Record(username: "John", date: "10/3/2032", delete: () => {}),
              ],
            ),
          );
  }
}

class Record extends StatelessWidget {
  const Record(
      {super.key,
      required this.username,
      required this.date,
      required this.delete});

  final String username;
  final String date;
  final VoidCallback delete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.33,
            height: 40,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(child: Text(username)),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.33,
            height: 40,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Center(
              child: Text(date),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.33,
            height: 40,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Center(
                child: IconButton(
              onPressed: delete,
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            )),
          ),
        ],
      ),
    );
  }
}
