import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        children: [
          Container(
            width: size.width,
            height: size.height * 0.17,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[Color(0xFF3B8D9B), Color(0xFF00FFB7)],
                begin: .topLeft,
                end: .bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: ListTile(
                title: const Text(
                  'Hi, Jane Doe!',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),

                subtitle: const Text(
                  // DateFormat('dd MMM yyy').format(DateTime.now()),
                  '01 Jan 2026',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                trailing: IconButton(
                  style: IconButton.styleFrom(backgroundColor: Colors.white),
                  onPressed: () {},
                  icon: Icon(Icons.person, color: Colors.green, size: 30),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
