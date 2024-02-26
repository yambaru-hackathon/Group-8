import 'package:flutter/material.dart';
import 'package:goup8_app/Pages/account_page.dart';
import 'package:goup8_app/Pages/search_page.dart';

class MapPage extends StatelessWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Row(
        children: [
          // const SizedBox(
          //   width: double.infinity,
          //   child: Column(
          //     children: [
          //       Text(
          //         'Area Name',
          //         style: TextStyle(
          //           color: Colors.grey,
          //           fontSize: 30,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          InteractiveViewer(
            // ignore: deprecated_member_use
            alignPanAxis: false,
            constrained: true,
            panEnabled: true,
            scaleEnabled: true,
            boundaryMargin: const EdgeInsets.all(double.infinity),
            minScale: 0.1,
            maxScale: 10.0,
            child: Image.asset(
              'images/創造実践塔1F.png',
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
