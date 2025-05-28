import 'package:flutter/material.dart';
import 'Navbar.dart';
import 'Component.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      {'title': 'คำว่าอะไร 1', 'subtitle': ''},
      {'title': 'คำว่าอะไร 2', 'subtitle': ''},
      {'title': 'คำว่าอะไร 3', 'subtitle': ''},
      {'title': 'คำว่าอะไร 4', 'subtitle': ''},
    ];
    return Scaffold(
      drawer: const Navbar(),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).padding.top,
              color: Colors.white,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top,
            left: 0,
            right: 0,
            child: Container(height: 8, color: const Color(0xFF004382)),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 0,
            right: 0,
            child: Container(
              height: 60,
              color: const Color.fromARGB(204, 255, 189, 48),
              child: Stack(
                children: [
                  Positioned(
                    left: 8.0,
                    top: 0,
                    bottom: 0,
                    child: Builder(
                      builder:
                          (context) => GestureDetector(
                            onTap: () {
                              Scaffold.of(context).openDrawer();
                            },
                            child: const Menuicon(),
                          ),
                    ),
                  ),
                  const Center(
                    child: Text(
                      'ประวัติการแปล',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 16.0,
                    top: 0,
                    bottom: 0,
                    child: const Favorite(),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 68,
            left: 0,
            right: 0,
            bottom: 0,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(color: const Color(0xCCFFBD30)),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 25),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 0, 67, 130),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Card(
                          child: ListTile(
                            title: Text(
                              item['title']!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
