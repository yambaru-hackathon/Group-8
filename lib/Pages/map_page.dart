import 'package:flutter/material.dart';
<<<<<<< HEAD

class MapPage extends StatelessWidget {
  const MapPage({super.key});
=======
import 'package:goup8_app/Pages/account_page.dart';
import 'package:goup8_app/Pages/search_page.dart';

class MapPage extends StatelessWidget {
  const MapPage({Key? key}) : super(key: key);
>>>>>>> d4da72a6fc394fdd44af7364289b529c0b9726d8

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< HEAD
      appBar: AppBar(title: const Text('Map')),
=======
      appBar: AppBar(
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchPage()),
              );
            },
            icon: const Icon(
              Icons.search,
              color: Colors.white,
              size: 30,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AccountPage()),
              );
            },
            icon: const Icon(
              Icons.account_circle,
              color: Colors.white,
              size: 30,
            ),
          ),
          const Text(
            'User Name',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
          const SizedBox(
            width: 20,
          )
        ],
      ),
      body: const SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Text(
              'Area Name',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 30,
              ),
            ),
          ],
        ),
      ),
>>>>>>> d4da72a6fc394fdd44af7364289b529c0b9726d8
    );
  }
}
