import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Component.dart';
import 'Navbar.dart';
import 'Thai_translator.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  runApp(
    MaterialApp(
      title: "TSL",
      home: const MyApp(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final TextEditingController mainTextController;
  late final FocusNode mainTextFocusNode;

  @override
  void initState() {
    super.initState();
    mainTextController = TextEditingController();
    mainTextFocusNode = FocusNode();
  }

  @override
  void dispose() {
    mainTextController.dispose();
    mainTextFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const Navbar(),
      drawerScrimColor: Colors.transparent,
      resizeToAvoidBottomInset: false, // <--- Prevents layout from resizing when keyboard appears
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
                    // กำหนดให้ TextField อยู่ด้านบน
                    Positioned(
                      top:
                          constraints.maxHeight *
                          0.03, // ตำแหน่งห่างจากขอบบน (5% ของความสูงจอ)
                      left: screenWidth * 0.1, // ขอบซ้าย
                      right: screenWidth * 0, // ขอบขวา
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.02,
                        ),
                        child: Column(
                          // Wrap the TextField in a Column
                          children: [
                            TextField(
                              controller: mainTextController,
                              focusNode: mainTextFocusNode,
                              decoration: InputDecoration(
                                hintText: "พิมพ์ข้อความภาษาไทย...",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: screenHeight * 0.025,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: screenHeight * 0.025,
                              ),
                              inputFormatters: [
                                // กำหนดให้พิมพ์ได้เฉพาะภาษาไทย
                                FilteringTextInputFormatter.allow(
                                  RegExp('[ก-๏]'),
                                ), // ภาษาไทย
                              ],
                              onSubmitted: (value) {
                                // เมื่อผู้ใช้กด Enter หรือ Done
                                if (value.isNotEmpty) {
                                  // ไปยังหน้าถัดไปและส่งค่าข้อความไป
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) =>
                                              Thai_translator(text: value),
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top:
                          constraints.maxHeight *
                          0.63, // เดิมคือ 500 (เช่น 35% จากความสูงจอ)
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Home(
                        mainTextController: mainTextController,
                        mainTextFocusNode: mainTextFocusNode,
                      ),
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

class Home extends StatelessWidget {
  final TextEditingController mainTextController;
  final FocusNode mainTextFocusNode;
  const Home({super.key, required this.mainTextController, required this.mainTextFocusNode});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

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
                    children: [Microphone(controller: mainTextController, focusNode: mainTextFocusNode)],
                  ),
                  Positioned(left: screenWidth * 0.17, child: const Speaker()),
                  Positioned(
                    right: screenWidth * 0.17,
                    child: const CameraSwapButton(),
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
