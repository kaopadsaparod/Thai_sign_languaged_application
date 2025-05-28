import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Component.dart';
import 'Navbar.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );

    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final favoriteItems = [
      {'title': 'สวัสดี', 'subtitle': 'ใช้ในการเริ่มต้นการสนทนา'},
      {'title': 'ทำไม?', 'subtitle': 'ถามเหตุผล'},
      {'title': 'ราคาเท่าไหร่?', 'subtitle': 'ใช้ถามราคาสินค้า'},
      {'title': 'ชื่อเล่น', 'subtitle': 'บอกชื่อเล่นของตน'},
    ];

    return Scaffold(
      drawer: const Navbar(), // เพิ่ม Drawer ให้เหมือน main.dart
      body: Column(
        children: [
          // พื้นหลังของ Status Bar (สีขาว)
          Container(height: statusBarHeight, color: Colors.white),
          // เส้นบางๆ สีฟ้าแยก Status Bar กับ Header
          Container(height: 8, color: const Color(0xFF004382)),
          // Header (AppBar)
          Container(
            height: 60, // ปรับ header ให้สูงเท่า main.dart
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
                    'รายการโปรด',
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
          // Container ฟ้าเข้มโค้ง + List
          Expanded(
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
                    itemCount: favoriteItems.length,
                    itemBuilder: (context, index) {
                      final item = favoriteItems[index];
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
                                // ด้านซ้าย: ข้อความ (font ใหญ่ขึ้น)
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
                                // ด้านขวา: Box สำหรับ gif (ใหญ่ขึ้น)
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
