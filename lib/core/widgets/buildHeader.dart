import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MedLinkHeader extends StatelessWidget {
  final double height;
  final double logoSize;
  final double titleFontSize;
  final bool showShadow;
  final bool showAnimation;

  const MedLinkHeader({
    super.key,
    this.height = 250,
    this.logoSize = 120,
    this.titleFontSize = 32,
    this.showShadow = true,
    this.showAnimation = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height.h,
      width: double.infinity,
      child: Stack(
        children: [
          // Background curved shape
          _buildBackground(),

          // Logo and title
          _buildLogoAndTitle(context),

          // Optional decorative elements
          if (showAnimation) _buildAnimatedElements(),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF023856), Color(0xFF035891)],
          ),
          boxShadow: showShadow ? [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 5),
            )
          ] : null,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoAndTitle(BuildContext context) {
    return Positioned(
      top: 40.h,
      left: 0,
      right: 0,
      child: Column(
        children: [
          // Logo with shadow
          Container(
            width: logoSize.w,
            height: logoSize.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 1,
                )
              ],
            ),
            child: Hero(
              tag: 'medlink_logo',
              child: ClipOval(
                child: Image.asset(
                  'assets/images/لوجو التخرج 1.png',
                  width: logoSize.w,
                  height: logoSize.h,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          SizedBox(height: 20.h),

          // Title with animated glow effect
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.5, end: 1.0),
            duration: const Duration(seconds: 2),
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: child,
              );
            },
            child: _buildMedlinkText(),
          ),

          // Tagline
          Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: Text(
              "Your Health Connection",
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.white.withOpacity(0.9),
                letterSpacing: 1.2,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedlinkText() {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return const LinearGradient(
          colors: [Colors.white, Colors.white70],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(bounds);
      },
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: titleFontSize.sp,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
          children: const [
            TextSpan(
              text: 'M',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w900,
              ),
            ),
            TextSpan(
              text: 'E',
              style: TextStyle(color: Colors.white),
            ),
            TextSpan(
              text: 'D',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w900,
              ),
            ),
            TextSpan(
              text: 'LINK',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedElements() {
    return Positioned.fill(
      child: IgnorePointer(
        child: CustomPaint(
          painter: CirclePainter(),
        ),
      ),
    );
  }
}

// Custom painter for decorative background circles
class CirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.fill;

    // Draw several circles with different sizes
    canvas.drawCircle(
      Offset(size.width * 0.1, size.height * 0.2),
      size.width * 0.08,
      paint,
    );

    canvas.drawCircle(
      Offset(size.width * 0.85, size.height * 0.3),
      size.width * 0.06,
      paint,
    );

    canvas.drawCircle(
      Offset(size.width * 0.4, size.height * 0.85),
      size.width * 0.05,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}