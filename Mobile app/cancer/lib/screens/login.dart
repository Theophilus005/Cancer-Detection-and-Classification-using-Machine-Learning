import 'dart:convert';
import 'package:cancer/constants.dart';
import 'package:cancer/screens/home.dart';
import 'package:cancer/screens/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_session/flutter_session.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  List results = [];
  bool isLoading = false;
  bool error = false;

  Future login() async {
    String username = usernameController.text;
    String password = passwordController.text;

    //Set loading to true
    setState(() {
      isLoading = true;
    });

    //Check if user is in database
    http.Response response;
    response = await http.get(
        Uri.parse(
            'https://cancer-0269.restdb.io/rest/auth?q={"username": "$username", "password": "$password"}'),
        headers: {
          'content-type': "application/json",
          'x-apikey': "b94869cad9c05798c0282f577707871a8db92",
          'cache-control': "no-cache"
        });

    //Store response
    if (response.statusCode == 200) {
      setState(() {
        results = json.decode(response.body);
      });
      
      //If user is not in dtabase
      if (results.isEmpty) {
        print("empty");
        setState(() {
          error = true;
          isLoading = false;
        });
      } else {
        //Create session
        var session = FlutterSession();
        await session.set("username", results[0]["username"]);
        await session.set("id", results[0]["_id"]);
        
        setState(() {
          error = false;
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const LoadingScreen()
        : Scaffold(
            backgroundColor: theme,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("LOG IN", style: textStyle.copyWith(fontSize: 30)),
                        const SizedBox(height: 15),

                        const CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 70,
                          child: Icon(
                            Icons.person,
                            color: Colors.black45,
                            size: 100,
                          ),
                        ),
                        const SizedBox(height: 25),

                        //Text fields
                        TextInput(
                            controller: usernameController, label: "Username"),
                        TextInput(
                            controller: passwordController, label: "Password"),

                        //Login Button
                        GestureDetector(
                          onTap: () async {
                            await login();
                            if(error == false) {
                              Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => const HomeScreen()));
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              width: double.infinity,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text("Login",
                                        style: TextStyle(fontSize: 18)),
                                    SizedBox(width: 5),
                                    Icon(Icons.arrow_forward_ios)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        error
                            ? Text("Incorrect Username/Password",
                                style: textStyle)
                            : Container(),
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }
}
