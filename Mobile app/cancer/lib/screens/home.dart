import 'package:cancer/screens/account.dart';
import 'package:cancer/screens/login.dart';
import 'package:cancer/screens/manage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import 'records.dart';
import 'package:flutter_session/flutter_session.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController sexController = TextEditingController();

  //Check if user is authenticated
  dynamic checkAuth() async {
    var session = FlutterSession();
     return await session.get("id");
  }

  @override
  Widget build(BuildContext context) {

    return checkAuth() == null ? const LoginScreen() : Scaffold(
      backgroundColor: theme,
      appBar: appBar,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () => Navigator.push(context,
                      CupertinoPageRoute(builder: (context) => const Manage())),
                  child: const NavigationButton(
                    nav: "Manage",
                    icon: Icon(
                      Icons.people,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const Records(),
                    ),
                  ),
                  child: const NavigationButton(
                    nav: "Records",
                    icon: Icon(
                      Icons.dataset,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
                GestureDetector(
                  child: const NavigationButton(
                    nav: "Stats",
                    icon: Icon(
                      Icons.bar_chart,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const Account(),
                    ),
                  ),
                  child: const NavigationButton(
                    nav: "Account",
                    icon: Icon(
                      Icons.settings,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 350, child: Image.asset("images/img1.png")),
            TextInput(controller: nameController, label: "Patient Name"),
            TextInput(controller: ageController, label: "Patient Age"),
            TextInput(controller: sexController, label: "Patient Sex"),
            const Text(
              "Image picker here",
              style: TextStyle(color: Colors.white),
            ),
            GestureDetector(
              onTap: () async {},
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                ),
                margin: const EdgeInsets.all(10.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: null,
                    child: const Text("Detect and Classify"),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}

class TextInput extends StatelessWidget {
  const TextInput({super.key, required this.controller, required this.label});

  final TextEditingController controller;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        validator: (val) => val != null ? 'This field is required' : null,
        controller: controller,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class NavigationButton extends StatelessWidget {
  const NavigationButton({super.key, required this.nav, required this.icon});

  final String nav;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        icon,
        Text(
          nav,
          style: const TextStyle(color: Colors.white),
        )
      ],
    );
  }
}
