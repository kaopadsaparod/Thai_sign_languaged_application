import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraFrameWidget extends StatefulWidget {
  final double initialWidth;
  final double initialHeight;
  final Offset initialOffset;
  final void Function(XFile videoFile)? onVideoRecorded;
  final bool isRecording;

  const CameraFrameWidget({
    Key? key,
    this.initialWidth = 450, // ปรับขนาดเริ่มต้นให้ใหญ่ขึ้น
    this.initialHeight = 600, // ปรับขนาดเริ่มต้นให้ใหญ่ขึ้น
    this.initialOffset = const Offset(40, 80),
    this.onVideoRecorded,
    this.isRecording = false,
  }) : super(key: key);

  @override
  CameraFrameWidgetState createState() => CameraFrameWidgetState();
}

class CameraFrameWidgetState extends State<CameraFrameWidget> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture; // เปลี่ยนเป็น nullable
  late double _width;
  late double _height;
  late Offset _offset;
  List<CameraDescription>? _cameras;
  int _currentCameraIndex = 0;
  bool _isFlashOn = false;
  double? _lastAspectRatio; // เก็บ aspect ratio ล่าสุด

  bool get isFlashOn => _isFlashOn;

  @override
  void initState() {
    super.initState();
    _width = widget.initialWidth;
    _height = widget.initialHeight;
    _offset = widget.initialOffset;
    _initCameras();
  }

  Future<void> _initCameras() async {
    _cameras = await availableCameras();
    await _initCamera(_currentCameraIndex);
  }

  Future<void> _initCamera(int cameraIndex) async {
    if (_controller != null) {
      await _controller!.dispose();
    }
    _controller = CameraController(_cameras![cameraIndex], ResolutionPreset.medium);
    _initializeControllerFuture = _controller!.initialize();
    await _initializeControllerFuture;
    try {
      // ปิดแฟลชเสมอ (รองรับกล้องหน้า/หลังทุกรุ่น)
      await _controller!.setFlashMode(FlashMode.off);
      // ตรวจสอบซ้ำ ถ้า flashMode ยังไม่ off ให้ปิดซ้ำอีกครั้ง (workaround)
      for (int i = 0; i < 3; i++) {
        if (_controller!.value.flashMode != FlashMode.off) {
          await _controller!.setFlashMode(FlashMode.off);
        } else {
          break;
        }
        await Future.delayed(const Duration(milliseconds: 100));
      }
      _isFlashOn = false;
    } catch (e) {
      _isFlashOn = false;
    }
    if (_controller != null && _controller!.value.isInitialized) {
      _lastAspectRatio = _controller!.value.aspectRatio;
    }
    setState(() {});
  }

  Future<void> swapCamera() async {
    if (_cameras == null || _cameras!.length < 2) return;
    _currentCameraIndex = (_currentCameraIndex + 1) % _cameras!.length;
    await _initCamera(_currentCameraIndex);
    // ไม่ต้อง setFlashMode ซ้ำที่นี่
    if (mounted) setState(() {});
  }

  Future<void> toggleFlash() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    if (_controller!.value.flashMode == FlashMode.torch) {
      await _controller!.setFlashMode(FlashMode.off);
    } else {
      await _controller!.setFlashMode(FlashMode.torch);
    }
    _isFlashOn = _controller!.value.flashMode == FlashMode.torch;
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    _controller = null; // <--- Force null to avoid old state lingering
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    final double aspectRatio =
        (_controller != null && _controller!.value.isInitialized && _lastAspectRatio != null)
            ? (_lastAspectRatio = _controller!.value.aspectRatio)
            : (_lastAspectRatio ?? 1.0); // fallback เป็น 1.0 (จัตุรัส)
    return Center(
      child: Container(
        width: _width,
        height: _height,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blueAccent, width: 2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: AspectRatio(
            aspectRatio: aspectRatio,
            child: _initializeControllerFuture == null
                ? Container(
                    color: Colors.black,
                    child: const Center(child: CircularProgressIndicator()),
                  )
                : FutureBuilder(
                    future: _initializeControllerFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done && _controller != null && _controller!.value.isInitialized) {
                        try {
                          return _buildCameraPreview();
                        } catch (e) {
                          // ถ้าเกิด error ใน CameraPreview ให้แสดง loading ปกติ
                          return Container(
                            color: Colors.black,
                            child: const Center(child: CircularProgressIndicator()),
                          );
                        }
                      } else if (snapshot.hasError) {
                        // กรณีเกิด error ใน FutureBuilder (controller init fail)
                        return Container(
                          color: Colors.black,
                          child: const Center(
                            child: Icon(Icons.error, color: Colors.red, size: 48),
                          ),
                        );
                      } else {
                        // แสดง loading พร้อมรักษา aspect ratio เดิม (พื้นหลังดำ)
                        return Container(
                          color: Colors.black,
                          child: const Center(child: CircularProgressIndicator()),
                        );
                      }
                    },
                  ),
          ),
        ),
      ),
    );
  }

  // expose controller for recording
  CameraController? get cameraController => _controller;

  Offset get offset => _offset;

  double get width => _width;
  double get height => _height;

  Widget _buildCameraPreview() {
    if (_controller == null || !_controller!.value.isInitialized) {
      return Container(color: Colors.black);
    }
    final isFrontCamera = _controller!.description.lensDirection == CameraLensDirection.front;
    Widget preview = CameraPreview(_controller!);
    if (isFrontCamera) {
      preview = Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()..scale(-1.0, 1.0, 1.0),
        child: preview,
      );
    }
    return preview;
  }
}

class CameraFrame extends StatelessWidget {
  final double width;
  final double height;
  const CameraFrame({super.key, this.width = 800, this.height = 800}); 

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: width,
        height: height,
        child: Image.asset(
          'assets/images/frame.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
