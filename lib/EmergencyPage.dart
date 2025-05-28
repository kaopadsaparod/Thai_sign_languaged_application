import 'package:flutter/material.dart';
import 'Component.dart';
import 'Navbar.dart';

class EmergencyPage extends StatelessWidget {
  const EmergencyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      {'title': 'ช่วยด้วย', 'subtitle': 'ใช้ขอความช่วยเหลือ'},
      {'title': 'ป่วย / ไม่สบาย', 'subtitle': 'บอกอาการเจ็บป่วย'},
      {
        'title': 'โทรศัพท์ / โทรหา',
        'subtitle': 'ขอใช้โทรศัพท์หรือขอความช่วยเหลือในการติดต่อ',
      },
      {'title': 'โรงพยาบาล', 'subtitle': 'ใช้เมื่อต้องการไปโรงพยาบาล'},
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
                      'เหตุฉุกเฉิน',
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
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 16.0,
                              horizontal: 16.0,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['title']!,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        item['subtitle']!,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 100,
                                  height: 100,
                                  margin: const EdgeInsets.only(left: 20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  child: const Center(child: Text('GIF')),
                                ),
                              ],
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
