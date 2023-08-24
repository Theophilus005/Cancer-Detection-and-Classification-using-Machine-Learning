import 'dart:convert';
import 'package:cancer/screens/loading.dart';
import 'package:cancer/screens/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../widgets/textInput.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_session/flutter_session.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  TextEditingController oldController = TextEditingController();
  TextEditingController newController = TextEditingController();

  List account = [];
  bool isLoading = true;
  String error = "";

  //Fetch Account
  Future fetchAccount() async {
    var id = await FlutterSession().get("id");
    http.Response response;

    response = await http.get(
        Uri.parse('https://cancer-0269.restdb.io/rest/auth?q={"_id": "$id"}'),
        headers: {
          'content-type': "application/json",
          'x-apikey': "b94869cad9c05798c0282f577707871a8db92",
          'cache-control': "no-cache"
        });
    if (response.statusCode == 200) {
      setState(() {
        account = json.decode(response.body);
        isLoading = false;
      });
    }
  }

  //Change Password
  Future changePassword(String oldPassword, String newPassword) async {
    setState(() {
      isLoading = true;
    });
    var id = await FlutterSession().get("id");
    if (account[0]["password"] == oldPassword) {
      http.Response response;
      response = await http
          .put(Uri.parse('https://cancer-0269.restdb.io/rest/auth/$id'), body: {
        'password': newPassword
      }, headers: {
        'x-apikey': "b94869cad9c05798c0282f577707871a8db92",
        'cache-control': "no-cache"
      });
      print(response.statusCode);
      if (response.statusCode == 200) {
        await fetchAccount();
        setState(() {
          isLoading = false;
          error = "Password Changed Successfully";
        });
      }
    } else {
      setState(() {
        isLoading = false;
        error = "Old Password is not correct";
      });
    }
  }

  @override
  void initState() {
    fetchAccount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const LoadingScreen()
        : Scaffold(
            appBar: AppBar(
              title: const Text("Account"),
              backgroundColor: theme,
            ),
            backgroundColor: theme,
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 70,
                          child: Icon(
                            Icons.person,
                            color: Colors.black45,
                            size: 100,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  "Username: ",
                                  style: TextStyle(color: Colors.white),
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  account[0]["username"],
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),

                            const SizedBox(height: 14),

                            Row(
                              children: [
                                const Text(
                                  "Account Type: ",
                                  style: TextStyle(color: Colors.white),
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  account[0]["account_type"],
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),

                            const SizedBox(height: 14),

                            Row(
                              children: [
                                const Text(
                                  "Created: ",
                                  style: TextStyle(color: Colors.white),
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  (account[0]["created_on"])
                                      .toString()
                                      .substring(0, 10),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),

                            const SizedBox(height: 14),
                            //LogOut button
                            GestureDetector(
                              onTap: () async {
                                setState(() {
                                  isLoading = true;
                                });
                                var session = FlutterSession();
                                await session.set("username", null);
                                await session.set("id", null);

                                Navigator.pushReplacement(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) =>
                                            const LoginScreen()));
                              },
                              child: Container(
                                  width: 100,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: const Center(child: Text("Log Out"))),
                            ),
                          ],
                        ),
                      ],
                    ),

                    //Change Password
                    const Padding(
                      padding: EdgeInsets.only(left: 15, top: 40, bottom: 10),
                      child: Text(
                        "Change Password",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),

                    TextInput(controller: oldController, label: "Old Password"),
                    TextInput(controller: newController, label: "New Password"),

                    //Change password button
                    GestureDetector(
                      onTap: () => changePassword(
                          oldController.text, newController.text),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Center(
                            child: Text(
                              "Change Password",
                            ),
                          ),
                        ),
                      ),
                    ),

                    //Status
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 15, top: 40, bottom: 10),
                        child: Text(
                          error,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
