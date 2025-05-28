import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Component.dart';
import 'Navbar.dart';

// Thai_translator แบบใหม่ที่รับ text ได้
class Thai_translator extends StatelessWidget {
  final String text;
  const Thai_translator({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Thai_translator_original(); // เรียกหน้าเก่าที่ไม่มี parameter
  }
}

// รีเนมของเดิมเป็น Thai_translator_original (ถ้าไม่อยากแก้ของเดิม)
class Thai_translator_original extends StatelessWidget {
  const Thai_translator_original({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const Navbar(),
      drawerScrimColor: Colors.transparent,
      body: Column(
        children: [
          Container(height: statusBarHeight, color: Colors.white),
          Container(
            height: screenHeight * 0.008,
            color: const Color.fromARGB(255, 0, 67, 130),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  offset: const Offset(0, 2),
                  blurRadius: 5,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              child: Container(
                color: const Color.fromARGB(204, 255, 189, 48),
                height: screenHeight * 0.07, // ≈ 65 บน Pixel 6
                child: Stack(
                  children: [
                    Positioned(
                      left: screenWidth * 0.03, // ≈ 12
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
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: screenHeight * 0.015, // ≈ 15
                      child: const Center(
                        child: Text(
                          "Thai SL",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: screenWidth * 0.06, // ≈ 25
                      top: screenHeight * 0.020, // ≈ 18
                      child: Favorite(),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(
                        60,
                        90,
                        60,
                        0,
                      ), // Corrected Padding syntax
                      height: screenHeight * 0.280,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(
                          255,
                          224,
                          224,
                          224,
                        ), // Fixed Color usage
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color.fromARGB(255, 224, 224, 224),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'GIF',
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 25,
                          ),
                        ),
                      ),
                    ),

                    Container(
                      margin: const EdgeInsets.fromLTRB(60, 360, 60, 0),
                      child: const FavoriteIcon(),
                    ),

                    Positioned(
                      top:
                          constraints.maxHeight *
                          0.63, // เดิมคือ 500 (เช่น 35% จากความสูงจอ)
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: const Home3(),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Home3 extends StatelessWidget {
  const Home3({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double _ = MediaQuery.of(context).size.width;

    return Container(
      color: const Color.fromARGB(255, 0, 67, 130),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: screenHeight * 0.10,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.04),
                child: const ThaiSwapTSL(),
              ),
              const SizedBox(height: 25),
              Stack(
                alignment: Alignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [const Speakerbutton()],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
