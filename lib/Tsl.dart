import 'package:flutter/material.dart';
import 'Component.dart';
import 'Navbar.dart';
import 'Camera.dart';
import 'package:camera/camera.dart';

class Tsl extends StatefulWidget {
  const Tsl({super.key});
  @override
  State<Tsl> createState() => _TslState();
}

class _TslState extends State<Tsl> {
  bool isRecording = false;
  XFile? lastVideoFile;
  final GlobalKey<CameraFrameWidgetState> cameraKey = GlobalKey<CameraFrameWidgetState>();
  bool isFrontCamera = false; // Track camera direction

  void _onCameraIconPressed() async {
    final cameraState = cameraKey.currentState;
    if (cameraState == null || cameraState.cameraController == null) return;
    final controller = cameraState.cameraController!;
    if (!isRecording) {
      await controller.startVideoRecording();
      setState(() { isRecording = true; });
    } else {
      final file = await controller.stopVideoRecording();
      setState(() {
        isRecording = false;
        lastVideoFile = file;
      });
      // TODO: ส่ง file ไป AI API ที่นี่
    }
  }

  // เรียก sync flash state หลัง swapCamera
  void _onCameraSwapPressed() async {
    await cameraKey.currentState?.swapCamera(); // รอให้กล้องใหม่ initialize เสร็จ
    await Future.delayed(const Duration(milliseconds: 200)); // หน่วงให้กล้อง init เสร็จ
    // Update isFrontCamera after swap
    final cameraState = cameraKey.currentState;
    bool front = false;
    if (cameraState != null && cameraState.cameraController != null) {
      front = cameraState.cameraController!.description.lensDirection == CameraLensDirection.front;
    }
    if (mounted) {
      await _handleToggleFlash(true); // justCheck = true
      setState(() {
        isFrontCamera = front;
      });
    }
  }

  // --- ฟังก์ชันควบคุมแฟลช: toggle หรือแค่เช็คสถานะ ---
  Future<bool> _handleToggleFlash([bool justCheck = false]) async {
    final cameraState = cameraKey.currentState;
    if (cameraState != null && cameraState.cameraController != null) {
      final controller = cameraState.cameraController!;
      try {
        if (controller.description.lensDirection == CameraLensDirection.front) {
          await controller.setFlashMode(FlashMode.off);
          return false;
        }
        if (justCheck) {
          // ถ้าแค่เช็คสถานะหลัง swapCamera: ให้ปิดแฟลชเสมอ (ป้องกันเปิดเอง)
          await controller.setFlashMode(FlashMode.off);
          return false;
        }
        // toggle ปกติ (กดปุ่มแฟลช)
        await controller.setFlashMode(
          controller.value.flashMode == FlashMode.torch ? FlashMode.off : FlashMode.torch,
        );
        await controller.setFlashMode(controller.value.flashMode); // force sync
        return controller.value.flashMode == FlashMode.torch;
      } catch (e) {
        return false;
      }
    }
    return false;
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
      body: Stack(
        children: [
          Column(
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
                      // ignore: deprecated_member_use
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
                    height: screenHeight * 0.07, // จากเดิม 65
                    child: Stack(
                      children: [
                        Positioned(
                          left: screenWidth * 0.03, // จากเดิม 12
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
                          bottom: screenHeight * 0.015, // จากเดิม 15
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
                          right: screenWidth * 0.06, // จากเดิม 25
                          top: screenHeight * 0.022, // จากเดิม 18
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
                        // Container สีขาว (header) เล็ก
                        Positioned(
                          top: constraints.maxHeight * 0.6,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: constraints.maxHeight * 0.08,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(40),
                                bottomRight: Radius.circular(40),
                              ),
                            ),
                          ),
                        ),
                        // Home2
                        Positioned(
                          top: constraints.maxHeight * 0.63,
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Home2(
                            onCameraIconPressed: _onCameraIconPressed,
                            onCameraSwapPressed: _onCameraSwapPressed,
                            cameraKey: cameraKey,
                            isFrontCamera: isFrontCamera,
                          ),
                        ),
                        // CameraFrame (กรอบนิ่ง) ให้อยู่ตรงกลางและซ้อนกับกล้องจริง
                        Positioned(
                          top: constraints.maxHeight * 0.08, // ให้ตรงกับตำแหน่งใน main.dart เดิม
                          left: 0,
                          right: 0,
                          child: Center(
                            child: SizedBox(
                              width: 420, // ให้ขนาดเท่ากับ CameraFrame
                              height: 420,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  CameraFrame(
                                    width: 650,
                                    height: 750,
                                  ),
                                  CameraFrameWidget(
                                    key: cameraKey,
                                    isRecording: isRecording,
                                    initialWidth: 270, // ให้ขนาดเท่ากัน
                                    initialHeight: 400,
                                    onVideoRecorded: (file) {
                                      // : ส่ง file ไป AI API ที่นี่
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Home2 extends StatelessWidget {
  final VoidCallback onCameraIconPressed;
  final VoidCallback onCameraSwapPressed;
  final GlobalKey<CameraFrameWidgetState> cameraKey;
  final bool isFrontCamera;

  const Home2({
    super.key,
    required this.onCameraIconPressed,
    required this.onCameraSwapPressed,
    required this.cameraKey,
    required this.isFrontCamera,
  });

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
                padding: EdgeInsets.only(
                  top: screenHeight * 0.04, // จากเดิม 60
                ),
                child: const TSLSwapThai(),
              ),
              const SizedBox(height: 25),
              Stack(
                alignment: Alignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Cameraicon(onPressed: onCameraIconPressed),
                    ],
                  ),
                  Positioned(
                    left: screenWidth * 0.17, // จากเดิม 65
                    child: BeforeFlash(cameraKey: cameraKey, isFrontCamera: isFrontCamera),
                  ),
                  Positioned(
                    right: screenWidth * 0.17,
                    child: CameraSwapButton(onSwap: onCameraSwapPressed),
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
