import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Academia',
          style: TextStyle(
            fontSize: 33,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        // actions: [
        //   IconButton(onPressed: () {}, icon: Icon(Icons.menu, size: 30)),
        //   SizedBox(width: size.width * 0.03),
        // ],
      ),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
        child: Column(
          crossAxisAlignment: .start,

          children: [
            SizedBox(height: size.height * 0.02),
            Text(
              'Good Morning, User!',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w600,
                // letterSpacing: 0.5,
              ),
            ),

            SizedBox(height: size.height * 0.02),

            SizedBox(
              width: size.width * 0.35,
              child: Card(
                elevation: 4,
                child: ListTile(
                  title: Image(
                    image: AssetImage('assets/icons/book.png'),
                    width: size.width * 0.01,
                  ),
                ),
              ),
            ),

            // Center(
            //   child: Container(
            //     width: size.width * 0.7,
            //     // height: size.height * 0.06,
            //     margin: EdgeInsets.only(bottom: size.height * 0.017),
            //     decoration: BoxDecoration(
            //       gradient: LinearGradient(
            //         colors: <Color>[Color(0xFF3B8D9B), Color(0xFF00FFB7)],
            //       ),
            //       borderRadius: BorderRadius.all(Radius.circular(30)),
            //     ),
            //     child: NavigationBar(
            //       indicatorColor: Colors.transparent,
            //       backgroundColor: Colors.transparent,
            //       destinations: [
            //         NavigationDestination(
            //           icon: Icon(
            //             Icons.home_filled,
            //             size: 30,
            //             color: Colors.white,
            //           ),
            //           label: 'Home',
            //         ),
            //         NavigationDestination(
            //           icon: Icon(Icons.person, size: 35, color: Colors.white),
            //           label: 'Profile',
            //         ),
            //         NavigationDestination(
            //           icon: Icon(Icons.settings, size: 30, color: Colors.white),
            //           label: 'Settings',
            //         ),
            //       ],
            //       labelTextStyle: WidgetStateProperty.all(
            //         TextStyle(fontSize: 18, color: Colors.white),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
