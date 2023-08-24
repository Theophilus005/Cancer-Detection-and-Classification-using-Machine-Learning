import 'dart:convert';

import 'package:flutter/material.dart';
import '../constants.dart';
import '../widgets/textInput.dart';
import 'package:http/http.dart' as http;

import 'loading.dart';

class Manage extends StatefulWidget {
  const Manage({super.key});

  @override
  State<Manage> createState() => _ManageState();
}

class _ManageState extends State<Manage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController typeController = TextEditingController();

  List users = [];
  bool isLoading = true;

  //Fetch Users
  Future fetchUsers() async {
    http.Response response;
    response = await http
        .get(Uri.parse("https://cancer-0269.restdb.io/rest/auth"), headers: {
      'content-type': "application/json",
      'x-apikey': "b94869cad9c05798c0282f577707871a8db92",
      'cache-control': "no-cache"
    });
    if (response.statusCode == 200) {
      setState(() {
        users = json.decode(response.body);
        isLoading = false;
      });
    }
  }

  //Add User
  Future addUser(String username, String accountType) async {
    setState(() {
      isLoading = true;
    });
    http.Response response;
    response = await http
        .post(Uri.parse("https://cancer-0269.restdb.io/rest/auth"), headers: {
      'x-apikey': "b94869cad9c05798c0282f577707871a8db92",
      'cache-control': "no-cache"
    }, body: {
      "username": username,
      "account_type": accountType,
      "password": "0000",
      "created_on": DateTime.now().toString(),
      "last_analysis": "N/A"
    });
    print(response.statusCode);
    if (response.statusCode == 201) {
      await fetchUsers();
      setState(() {
        isLoading = false;
      });
    }
  }

  //Delete User
  Future deleteUser(String id) async {
    setState(() {
      isLoading = true;
    });
    http.Response response;
    response = await http.delete(
        Uri.parse("https://cancer-0269.restdb.io/rest/auth/$id"),
        headers: {
          'content-type': "application/json",
          'x-apikey': "b94869cad9c05798c0282f577707871a8db92",
          'cache-control': "no-cache"
        });
    print(response.statusCode);
    if (response.statusCode == 200) {
      await fetchUsers();
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    fetchUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const LoadingScreen()
        : Scaffold(
            appBar: AppBar(
              title: const Text("Manage Users"),
              backgroundColor: theme,
              elevation: 0.0,
            ),
            backgroundColor: theme,
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: theme,
                      content: Stack(
                        children: <Widget>[
                          Positioned(
                            right: -40.0,
                            top: -40.0,
                            child: InkResponse(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: const CircleAvatar(
                                backgroundColor: Colors.red,
                                child: Icon(Icons.close),
                              ),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.person_add,
                                      size: 40,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 10),
                                    Text("Add User",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 30)),
                                  ]),
                              TextInput(
                                  controller: usernameController,
                                  label: "Username"),
                              TextInput(
                                  controller: typeController,
                                  label: "Account type"),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  addUser(usernameController.text,
                                      typeController.text);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    width: double.infinity,
                                    height: 55,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Text("Add",
                                            style: TextStyle(fontSize: 20)),
                                        SizedBox(width: 5),
                                        Icon(Icons.person_add),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              backgroundColor: Colors.white,
              child: Icon(Icons.add, color: Colors.black54, size: 30),
            ),
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
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
                        child: const Center(child: Text("Username")),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.33,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 190, 190, 190),
                        ),
                        child: const Center(
                          child: Text("Account type"),
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
                      itemCount: users.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return User(
                            username: users[index]["username"],
                            type: users[index]["account_type"],
                            delete: () => {deleteUser(users[index]["_id"])},);
                      })

                  //User(username: "Theophilus", type: "Admin", delete: () => {}),
                  //User(username: "Sumaila", type: "Doctor", delete: () => {}),
                ],
              ),
            ),
          );
  }
}

class User extends StatelessWidget {
  const User(
      {super.key,
      required this.username,
      required this.type,
      required this.delete});

  final String username;
  final String type;
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
              child: Text(type),
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
