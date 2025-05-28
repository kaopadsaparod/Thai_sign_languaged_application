import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'EmergencyPage.dart';
import 'EmotionPage.dart';
import 'GreetingPage.dart';
import 'HistoryPage.dart';
import 'IntroducePage.dart';
import 'QAPage.dart';
import 'ShoppingPage.dart';
import 'TimePage.dart';
import 'TravelPage.dart';
import 'main.dart';

class Navbar extends StatelessWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Drawer(
            backgroundColor: Colors.transparent,
            width:
                screenWidth * 0.7, // ปรับความกว้างของ Drawer เป็น 75% ของหน้าจอ
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(0),
                topRight: Radius.circular(0),
                bottomLeft: Radius.circular(0),
                bottomRight: Radius.circular(40),
              ),
              child: Container(
                color: const Color.fromARGB(204, 255, 189, 48),
                child: Stack(
                  children: [
                    // Header Menu
                    Positioned(
                      top: 28,
                      left: 0,
                      right: 0,
                      child: Container(
                        height:
                            screenHeight *
                            0.07, // ปรับความสูงของ Header Menu ตามหน้าจอ
                        decoration: const BoxDecoration(
                          color: Color(0xFF004382),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(00),
                            topRight: Radius.circular(00),
                            bottomLeft: Radius.circular(00),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(width: 24),
                            Padding(
                              padding: EdgeInsets.only(
                                top:
                                    screenHeight *
                                    0.01, // ขยับ icon ลงเล็กน้อยตามหน้าจอ
                              ),
                              child: Image.asset(
                                'assets/images/menuinmenu.png',
                                width: 24,
                                height: 24,
                              ),
                            ),
                            const SizedBox(width: 24),
                            Padding(
                              padding: EdgeInsets.only(
                                top:
                                    screenHeight *
                                    0.01, // ขยับข้อความขึ้นเล็กน้อยตามหน้าจอ
                                left: 37,
                              ),
                              child: Text(
                                'Menu',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      screenWidth *
                                      0.065, // ปรับขนาดข้อความตามขนาดหน้าจอ
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // ปุ่มเมนูทั้งหมด
                    Positioned(
                      top: screenHeight * 0.12, // ปรับตำแหน่งเริ่มต้นของเมนู
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [
                          _buildMenuItem(
                            context,
                            Icons.home,
                            'หน้าหลัก',
                            screenWidth,
                          ),
                          SizedBox(
                            height: screenHeight * 0.015,
                          ), // เพิ่มช่องว่างระหว่างเมนู
                          _buildMenuItem(
                            context,
                            Icons.search,
                            'ประวัติการแปล',
                            screenWidth,
                          ),
                          SizedBox(height: screenHeight * 0.015),
                          _buildMenuItem(
                            context,
                            Icons.person,
                            'แนะนำตัว',
                            screenWidth,
                          ),
                          SizedBox(height: screenHeight * 0.015),
                          _buildMenuItem(
                            context,
                            Icons.pan_tool,
                            'ทักทาย',
                            screenWidth,
                          ),
                          SizedBox(height: screenHeight * 0.015),
                          _buildMenuItem(
                            context,
                            Icons.chat_bubble,
                            'ถาม - ตอบ',
                            screenWidth,
                          ),
                          SizedBox(height: screenHeight * 0.015),
                          _buildMenuItem(
                            context,
                            Icons.receipt,
                            'ซื้อของ',
                            screenWidth,
                          ),
                          SizedBox(height: screenHeight * 0.015),
                          _buildMenuItem(
                            context,
                            Icons.warning,
                            'เหตุฉุกเฉิน',
                            screenWidth,
                          ),
                          SizedBox(height: screenHeight * 0.015),
                          _buildMenuItem(
                            context,
                            Icons.directions_car,
                            'การเดินทาง',
                            screenWidth,
                          ),
                          SizedBox(height: screenHeight * 0.015),
                          _buildMenuItem(
                            context,
                            Icons.sentiment_satisfied,
                            'อารมณ์',
                            screenWidth,
                          ),
                          SizedBox(height: screenHeight * 0.015),
                          _buildMenuItem(
                            context,
                            Icons.format_list_numbered_rtl_rounded,
                            'เวลา - ตัวเลข',
                            screenWidth,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String title,
    double screenWidth,
  ) {
    Widget leadingIcon;
    switch (title) {
      case 'ประวัติการแปล':
        leadingIcon = Image.asset(
          'assets/images/magnifier.png',
          width: 28,
          height: 28,
          color: Colors.white,
        );
        break;
      case 'ถาม - ตอบ':
        leadingIcon = Image.asset(
          'assets/images/QA.png',
          width: 28,
          height: 28,
          color: Colors.white,
        );
        break;
      case 'เหตุฉุกเฉิน':
        leadingIcon = Image.asset(
          'assets/images/alert.png',
          width: 28,
          height: 28,
          color: Colors.white,
        );
        break;
      case 'การเดินทาง':
        leadingIcon = Image.asset(
          'assets/images/car.png',
          width: 28,
          height: 28,
          color: Colors.white,
        );
        break;
      case 'อารมณ์':
        leadingIcon = Image.asset(
          'assets/images/face.png',
          width: 28,
          height: 28,
          color: Colors.white,
        );
        break;
      case 'ซื้อของ':
        leadingIcon = Image.asset(
          'assets/images/credit.png',
          width: 28,
          height: 28,
          color: Colors.white,
        );
        break;
      case 'เวลา - ตัวเลข':
        leadingIcon = const Icon(
          Icons.onetwothree_rounded,
          color: Colors.white,
          size: 30,
        );
        break;
      case 'ทักทาย':
        leadingIcon = Image.asset(
          'assets/images/wave.png',
          width: 28,
          height: 28,
          color: Colors.white,
        );
        break;
      case 'แนะนำตัว':
        leadingIcon = Image.asset(
          'assets/images/peopleicon.png',
          width: 28,
          height: 28,
          color: Colors.white,
        );
        break;
      default:
        leadingIcon = Icon(icon, color: Colors.white, size: 28);
    }
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0.0),
      child: SizedBox(
        width: double.infinity,
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: const Color(0xFF004382),
            shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(0),
                topRight: Radius.circular(40),
                bottomLeft: Radius.circular(0),
                bottomRight: Radius.circular(40),
              ),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 20.0,
            ),
            alignment: Alignment.centerLeft,
          ),
          onPressed: () {
            Navigator.pop(context);
            if (title == 'หน้าหลัก') {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const MyApp()),
                (route) => false,
              );
            } else if (title == 'ประวัติการแปล') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryPage()),
              );
            } else if (title == 'แนะนำตัว') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const IntroducePage()),
              );
            } else if (title == 'ทักทาย') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const GreetingPage()),
              );
            } else if (title == 'ถาม - ตอบ') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const QAPage()),
              );
            } else if (title == 'ซื้อของ') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ShoppingPage()),
              );
            } else if (title == 'เหตุฉุกเฉิน') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EmergencyPage()),
              );
            } else if (title == 'การเดินทาง') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TravelPage()),
              );
            } else if (title == 'อารมณ์') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EmotionPage()),
              );
            } else if (title == 'เวลา - ตัวเลข') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TimePage()),
              );
            }
          },
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              leadingIcon,
              const SizedBox(width: 14.0),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth * 0.045, // ปรับขนาดฟอนต์ตามขนาดหน้าจอ
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
      ),
    );
  }
}