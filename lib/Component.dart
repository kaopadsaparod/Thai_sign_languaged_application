import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'Favorite.dart';
import 'TSl.dart';
import 'Camera.dart';
import 'main.dart';
import 'Tsl_translator.dart';

class Cameraicon extends StatefulWidget {
  const Cameraicon({super.key, required VoidCallback onPressed});
  @override
  State<Cameraicon> createState() => _CameraiconState();
}

class _CameraiconState extends State<Cameraicon>
    with SingleTickerProviderStateMixin {
  bool _isClicked = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  void _toggleIcon() {
    setState(() {
      _isClicked = !_isClicked;
      if (_isClicked) {
        _controller.forward();
      } else {
        _controller.reverse();
        // เมื่อกดรอบที่สอง (isClicked == false) ให้ไปหน้า Tsl_translator
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Tsl_translator()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleIcon,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.scale(
            scale: 1 + (_animation.value * 0.2), // Slightly enlarge on click
            child: Image.asset(
              _isClicked
                  ? 'assets/images/camera_clicked.png'
                  : 'assets/images/camera.png',
              width: 70, // ปรับขนาดให้ใหญ่ขึ้น
              height: 70,
            ),
          );
        },
      ),
    );
  }
}

class Menuicon extends StatelessWidget {
  const Menuicon({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: null, // Set to null for now
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0), // เพิ่มระยะห่างจากขอบซ้าย
        child: Image.asset(
          'assets/images/menu.png',
          width: 20, // ปรับขนาดให้เล็กลง
          height: 20,
        ),
      ),
    );
  }
}

class CameraSwapButton extends StatefulWidget {
  final VoidCallback? onSwap;
  const CameraSwapButton({super.key, this.onSwap});

  @override
  State<CameraSwapButton> createState() => _CameraSwapButtonState();
}

class _CameraSwapButtonState extends State<CameraSwapButton> {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _scale = 0.8;
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _scale = 1.0;
    });
  }

  void _onTapCancel() {
    setState(() {
      _scale = 1.0;
    });
  }

  void _onTap() {
    if (widget.onSwap != null) widget.onSwap!();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: _onTap,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        child: Image.asset(
          'assets/images/cameraswap.png',
          width: 35,
          height: 35,
        ),
      ),
    );
  }
}

class BeforeFlash extends StatefulWidget {
  final GlobalKey<CameraFrameWidgetState> cameraKey;
  final bool isFrontCamera; // เพิ่มตัวแปรนี้
  const BeforeFlash({super.key, required this.cameraKey, required this.isFrontCamera});

  @override
  State<BeforeFlash> createState() => _BeforeFlashState();
}

class _BeforeFlashState extends State<BeforeFlash> {
  bool _isFlashOn = false;

  @override
  void initState() {
    super.initState();
    _syncFlashState();
  }

  void _syncFlashState() {
    final cameraState = widget.cameraKey.currentState;
    final flash = cameraState?.isFlashOn ?? false;
    setState(() {
      _isFlashOn = flash;
    });
  }

  void _toggleFlash() async {
    final cameraState = widget.cameraKey.currentState;
    if (cameraState != null) {
      await cameraState.toggleFlash();
      _syncFlashState();
    }
  }

  @override
  Widget build(BuildContext context) {
    // ถ้าเป็นกล้องหน้า ให้ปุ่ม flash กดไม่ได้ (opacity 0.4, onTap: null)
    if (widget.isFrontCamera) {
      return Opacity(
        opacity: 0.4,
        child: Image.asset(
          'assets/images/Beforeflash.png',
          width: 35,
          height: 35,
        ),
      );
    }
    // ...ปกติ (กล้องหลัง)
    return GestureDetector(
      onTap: _toggleFlash,
      child: Image.asset(
        _isFlashOn ? 'assets/images/flash.png' : 'assets/images/Beforeflash.png',
        width: 35,
        height: 35,
      ),
    );
  }
}

class Favorite extends StatelessWidget {
  const Favorite({super.key});

  @override
  Widget build(BuildContext context) {
    final isFavoritePage = ModalRoute.of(context)?.settings.name == '/favorite';
    return GestureDetector(
      onTap: () {
        if (isFavoritePage) {
          Navigator.pop(context); // ถ้าอยู่หน้า favorite ให้ปิด
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FavoritePage(),
              settings: const RouteSettings(name: '/favorite'),
            ),
          );
        }
      },
      child: Image.asset('assets/images/favorite.png', width: 30, height: 30),
    );
  }
}



class FavoriteItem {
  final String title;
  final String subtitle;
  final String? gifPath;
  FavoriteItem({required this.title, required this.subtitle, this.gifPath});

  @override
  bool operator ==(Object other) =>
      other is FavoriteItem &&
      other.title == title &&
      other.subtitle == subtitle &&
      other.gifPath == gifPath;

  @override
  int get hashCode =>
      title.hashCode ^ subtitle.hashCode ^ (gifPath?.hashCode ?? 0);
}

class FavoriteManager extends ChangeNotifier {
  static final FavoriteManager _instance = FavoriteManager._internal();
  factory FavoriteManager() => _instance;
  FavoriteManager._internal();

  final List<FavoriteItem> _favorites = [];
  List<FavoriteItem> get favorites => List.unmodifiable(_favorites);

  bool isFavorite(FavoriteItem item) => _favorites.contains(item);

  void toggleFavorite(FavoriteItem item) {
    if (isFavorite(item)) {
      _favorites.remove(item);
    } else {
      _favorites.add(item);
    }
    notifyListeners();
  }

  void removeFavorite(FavoriteItem item) {
    _favorites.remove(item);
    notifyListeners();
  }
}

class Microphone extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  const Microphone({super.key, required this.controller, required this.focusNode});

  @override
  State<Microphone> createState() => _MicrophoneState();
}

class _MicrophoneState extends State<Microphone>
    with SingleTickerProviderStateMixin {
  bool _isClicked = false;
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;
  late stt.SpeechToText _speech;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    )..addStatusListener((status) {
      if (_isClicked) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      }
    });
    _speech = stt.SpeechToText();
  }

  void _toggleIcon() async {
    setState(() {
      _isClicked = !_isClicked;
    });
    if (_isClicked) {
      bool available = await _speech.initialize(
        onStatus: (status) {
          // ไม่ต้อง stop หรือ setState ที่นี่ ให้ user เป็นคนหยุดเอง
        },
        onError: (error) {
          setState(() {
            _isClicked = false;
          });
          _controller.stop();
        },
      );
      if (available) {
        _controller.forward();
        _speech.listen(
          localeId: 'th_TH',
          listenFor: const Duration(hours: 1), // ฟังได้นานมากจนกว่าจะ stop
          partialResults: true, // อัปเดตผลลัพธ์ระหว่างพูด
          onResult: (result) {
            // ตรวจสอบว่ามีอักษรไทยใน recognizedWords หรือไม่
            final thaiRegExp = RegExp(r'[ก-๏]');
            if (thaiRegExp.hasMatch(result.recognizedWords)) {
              widget.controller.value = widget.controller.value.copyWith(
                text: result.recognizedWords,
                selection: TextSelection.collapsed(offset: result.recognizedWords.length),
              );
            }
            // ถ้าไม่มีอักษรไทย จะไม่อัปเดตข้อความ
          },
        );
      } else {
        setState(() {
          _isClicked = false;
        });
        _controller.stop();
      }
    } else {
      _speech.stop();
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleIcon,
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _isClicked ? _pulseAnimation.value : 1.0,
            child: Image.asset(
              _isClicked
                  ? 'assets/images/microphone_clicked.png'
                  : 'assets/images/microphone.png',
              width: 70,
              height: 70,
            ),
          );
        },
      ),
    );
  }
}

class Speaker extends StatelessWidget {
  const Speaker({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0, // ปรับตำแหน่งขึ้น 20 หน่วยจากด้านบน
      right: 0,
      left: 0,
      bottom: 200, // ปรับตำแหน่งไปทางซ้าย 15 หน่วยจากด้านซ้าย
      child: Align(
        alignment: Alignment.center, // จัดตำแหน่งให้ตรงกลาง
        child: Image.asset('assets/images/speaker.png', width: 40, height: 40),
      ),
    );
  }
}

class ThaiSwapTSL extends StatefulWidget {
  const ThaiSwapTSL({super.key});

  @override
  State<ThaiSwapTSL> createState() => _ThaiSwapTSLState();
}

class _ThaiSwapTSLState extends State<ThaiSwapTSL> {
  bool isSwapped = false;

  void _onSwapPressed() async {
    setState(() {
      isSwapped = !isSwapped;
    });
    // รอให้ animation สลับข้อความเสร็จ (500ms)
    await Future.delayed(const Duration(milliseconds: 500));
    // เปลี่ยนหน้าแบบไม่มี animation
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => isSwapped ? const Tsl() : const MyApp(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        transitionsBuilder: (_, __, ___, child) => child, // ไม่มี animation ใดๆ
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32), // ขยับทั้งแถวลงอีก
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 130,
            height: 50,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              switchInCurve: Curves.easeInOutCubic,
              switchOutCurve: Curves.easeInOutCubic,
              transitionBuilder:
                  (child, animation) => SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(isSwapped ? 1.1 : -1.1, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: FadeTransition(opacity: animation, child: child),
                  ),
              child: _buildBox(
                isSwapped ? "TSL" : "Thai",
                key: ValueKey(isSwapped ? "TSL" : "Thai"),
              ),
            ),
          ),
          const SizedBox(width: 30),
          // ปุ่ม swap ใช้เป็น swap.png ไม่มีพื้นหลังกลม
          GestureDetector(
            onTap: _onSwapPressed,
            child: Image.asset('assets/images/swap.png', width: 50, height: 50),
          ),
          const SizedBox(width: 30),
          SizedBox(
            width: 130,
            height: 50,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              switchInCurve: Curves.easeInOutCubic,
              switchOutCurve: Curves.easeInOutCubic,
              transitionBuilder:
                  (child, animation) => SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(isSwapped ? -1.1 : 1.1, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: FadeTransition(opacity: animation, child: child),
                  ),
              child: _buildBox(
                isSwapped ? "Thai" : "TSL",
                key: ValueKey(isSwapped ? "Thai" : "TSL"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBox(String text, {required Key key}) {
    return Container(
      key: key,
      width: 130,
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class TSLSwapThai extends StatefulWidget {
  const TSLSwapThai({super.key});

  @override
  State<TSLSwapThai> createState() => _TSLSwapThaiState();
}

class _TSLSwapThaiState extends State<TSLSwapThai> {
  // ตัวแปรเก็บสถานะว่าตอนนี้ข้อความถูกสลับหรือยัง
  bool isSwapped = false;

  // ฟังก์ชันที่ทำงานเมื่อผู้ใช้กดปุ่ม swap (ไอคอนรูปภาพ)
  void _onSwapPressed() async {
    setState(() {
      isSwapped = !isSwapped; // เปลี่ยนสถานะให้ตรงข้าม
    });

    // รอ 0.5 วินาที ก่อนเปลี่ยนหน้า
    await Future.delayed(const Duration(milliseconds: 500));

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const MyApp(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        transitionsBuilder: (_, __, ___, child) => child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32), // ขยับทั้งแถวลงอีก
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            width: 130,
            height: 50,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              switchInCurve: Curves.easeInOutCubic,
              switchOutCurve: Curves.easeInOutCubic,
              transitionBuilder:
                  (child, animation) => SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(isSwapped ? 1.1 : -1.1, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: FadeTransition(opacity: animation, child: child),
                  ),
              child: _buildBox(
                isSwapped ? "Thai" : "TSL",
                key: ValueKey(isSwapped ? "Thai" : "TSL"),
              ),
            ),
          ),
          const SizedBox(width: 30),
          // ปุ่ม swap ใช้เป็น swap.png ไม่มีพื้นหลังกลม
          GestureDetector(
            onTap: _onSwapPressed,
            child: Image.asset('assets/images/swap.png', width: 50, height: 50),
          ),
          const SizedBox(width: 30),
          SizedBox(
            width: 130,
            height: 50,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              switchInCurve: Curves.easeInOutCubic,
              switchOutCurve: Curves.easeInOutCubic,
              transitionBuilder:
                  (child, animation) => SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(isSwapped ? -1.1 : 1.1, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: FadeTransition(opacity: animation, child: child),
                  ),
              child: _buildBox(
                isSwapped ? "TSL" : "Thai",
                key: ValueKey(isSwapped ? "TSL" : "Thai"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBox(String text, {required Key key}) {
    return Container(
      key: key,
      width: 130,
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

// --- Reusable UI Components ---
class FavoriteIcon extends StatefulWidget {
  const FavoriteIcon({super.key});

  @override
  State<FavoriteIcon> createState() => _FavoriteIconState();
}

class _FavoriteIconState extends State<FavoriteIcon> {
  bool isFavorited = false;

  void _toggleFavorite() {
    setState(() {
      isFavorited = !isFavorited;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleFavorite,
      child: Image.asset(
        isFavorited
            ? 'assets/images/favorite_button.png'
            : 'assets/images/no_favorite_button.png',
        width: 25,
        height: 25,
      ),
    );
  }
}

// --- Speakerbutton Widget ---
class Speakerbutton extends StatefulWidget {
  const Speakerbutton({super.key});

  @override
  State<Speakerbutton> createState() => _SpeakerbuttonState();
}

class _SpeakerbuttonState extends State<Speakerbutton> {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _scale = 0.8;
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _scale = 1.0;
    });
  }

  void _onTapCancel() {
    setState(() {
      _scale = 1.0;
    });
  }

  void _onTap() {
    debugPrint("Speaker button tapped");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: _onTap,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        child: Image.asset(
          'assets/images/speakerbutton.png',
          width: 70,
          height: 70,
        ),
      ),
    );
  }
}

/// A simple loading spinner centered in its parent.
class LoadingSpinner extends StatelessWidget {
  final double size;
  final Color? color;
  const LoadingSpinner({super.key, this.size = 40, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          valueColor:
              color != null ? AlwaysStoppedAnimation<Color>(color!) : null,
          strokeWidth: 4,
        ),
      ),
    );
  }
}

/// Show a simple app alert dialog
Future<void> showAppAlert(
  BuildContext context,
  String title,
  String message, {
  String buttonText = 'OK',
}) {
  return showDialog<void>(
    context: context,
    builder:
        (context) => AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(buttonText),
            ),
          ],
        ),
  );
}

/// A custom styled button
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final double? width;
  final double? height;
  final Widget? icon;
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.width,
    this.height,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton.icon(
        icon: icon ?? const SizedBox.shrink(),
        label: Text(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}

/// A button with icon and text, horizontally aligned
class IconTextButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  const IconTextButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      icon: Icon(icon, color: color ?? Theme.of(context).primaryColor),
      label: Text(
        text,
        style: TextStyle(color: color ?? Theme.of(context).primaryColor),
      ),
      onPressed: onPressed,
    );
  }
}

/// Empty state widget for when there is no data
class EmptyState extends StatelessWidget {
  final String message;
  final Widget? icon;
  const EmptyState({super.key, required this.message, this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) icon!,
          if (icon != null) const SizedBox(height: 12),
          Text(
            message,
            style: const TextStyle(fontSize: 18, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// --- FavoriteIcon Widget ---
