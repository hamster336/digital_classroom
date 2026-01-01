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
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.menu, size: 30)),
          SizedBox(width: size.width * 0.03),
        ],
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

            Card(child: ListTile(leading: Icon(Icons.menu_book_rounded))),

            Spacer(),

            Center(
              child: Container(
                width: size.width * 0.65,
                height: size.height * 0.06,
                margin: EdgeInsets.only(bottom: size.height * 0.017),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[Color(0xFF3B8D9B), Color(0xFF00FFB7)],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                child: Row(
                  mainAxisAlignment: .spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.home_filled,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.person, color: Colors.white, size: 35),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.settings, color: Colors.white, size: 35),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
