import 'package:cancer/constants.dart';
import 'package:cancer/screens/account.dart';
import 'package:cancer/screens/manage.dart';
import 'package:cancer/screens/records.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen2 extends StatelessWidget {
  const HomeScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme,
      appBar: appBar,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5,),
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Welcome", style: textStyle.copyWith(fontSize: 17)),
                  Row(
                    children: [
                      Text("Theophilus", style: textStyle.copyWith(fontSize: 27)),
                      Text(",", style: textStyle.copyWith(fontSize: 37)),
                    ],
                  ),
                ],
              ),
            ),
      
            Center(child: SizedBox(height: 300, child: Image.asset("images/img1.png"))),
      
            const SizedBox(height: 20),
      
            //First Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //Manage
                HomeNav(
                  nav: "Manage",
                  icon: Icons.people,
                  route: () => {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => const Manage(),
                      ),
                    ),
                  },
                ),
      
                //Records
                HomeNav(
                  nav: "Records",
                  icon: Icons.people,
                  route: () => {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => const Records(),
                      ),
                    ),
                  },
                ),
              ],
            ),
      
            const SizedBox(height: 25),
      
            //Second Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //Statistics
                HomeNav(
                  nav: "Statistics",
                  icon: Icons.bar_chart,
                  route: () => {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => const Manage(),
                      ),
                    ),
                  },
                ),
      
                //Account
                HomeNav(
                  nav: "Account",
                  icon: Icons.settings,
                  route: () => {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => const Account(),
                      ),
                    ),
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class HomeNav extends StatelessWidget {
  const HomeNav(
      {super.key, required this.nav, required this.icon, required this.route});
  final String nav;
  final IconData icon;
  final VoidCallback route;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: route,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        height: 150,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(nav, style: const TextStyle(fontSize: 22)),
            Icon(icon, size: 35),
          ],
        ),
      ),
    );
  }
}
