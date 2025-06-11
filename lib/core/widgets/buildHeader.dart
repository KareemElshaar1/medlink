import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' show sin;

class ColorsManager {
  static const Color primary = Color(0xFF2196F3);
  static const Color secondary = Color(0xFF03A9F4);
  static const Color textDark = Color(0xFF333333);
  static const Color gray = Color(0xFF757575);
  static const Color error = Color(0xFFE53935);
}

class MedLinkHeader extends StatefulWidget {
  final double height;
  final double logoSize;
  final double titleFontSize;
  final bool showShadow;
  final bool showAnimation;
  final VoidCallback? onTap;

  const MedLinkHeader({
    super.key,
    this.height = 280,
    this.logoSize = 85,
    this.titleFontSize = 28,
    this.showShadow = true,
    this.showAnimation = true,
    this.onTap,
  });

  @override
  State<MedLinkHeader> createState() => _MedLinkHeaderState();
}

class _MedLinkHeaderState extends State<MedLinkHeader>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _floatingController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _floatingAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _floatingController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _floatingAnimation = Tween<double>(
      begin: -10,
      end: 10,
    ).animate(CurvedAnimation(
      parent: _floatingController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height.h,
      width: double.infinity,
      child: Stack(
        children: [
          // Modern gradient background with app colors
          _buildModernBackground(),

          // Floating elements
          if (widget.showAnimation) _buildFloatingElements(),

          // Main content
          _buildMainContent(),

          // Bottom wave decoration
          _buildBottomWave(),
        ],
      ),
    );
  }

  Widget _buildModernBackground() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              ColorsManager.primary, // Primary blue
              ColorsManager.primary.withOpacity(0.9),
              ColorsManager.secondary, // Secondary blue
            ],
            stops: const [0.0, 0.6, 1.0],
          ),
          boxShadow: widget.showShadow
              ? [
                  BoxShadow(
                    color: ColorsManager.primary.withOpacity(0.3),
                    blurRadius: 25,
                    offset: const Offset(0, 8),
                    spreadRadius: 2,
                  )
                ]
              : null,
        ),
      ),
    );
  }

  Widget _buildFloatingElements() {
    return Positioned.fill(
      child: CustomPaint(
        painter: ModernFloatingElementsPainter(
          pulseAnimation: _pulseAnimation,
          floatingAnimation: _floatingAnimation,
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return Positioned(
      top: 50.h,
      left: 0,
      right: 0,
      child: Column(
        children: [
          // Logo container with modern styling
          GestureDetector(
            onTap: widget.onTap,
            child: AnimatedBuilder(
              animation: widget.showAnimation
                  ? _pulseAnimation
                  : const AlwaysStoppedAnimation(1.0),
              builder: (context, child) {
                return Transform.scale(
                  scale: widget.showAnimation ? _pulseAnimation.value : 1.0,
                  child: Container(
                    width: widget.logoSize.w + 20,
                    height: widget.logoSize.h + 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.white.withOpacity(0.3),
                          Colors.white.withOpacity(0.1),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.7, 1.0],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.2),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                        BoxShadow(
                          color: ColorsManager.primary.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Hero(
                        tag: 'medlink_logo',
                        child: Container(
                          width: 100.w,
                          height: 100.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: ColorsManager.primary.withOpacity(0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/logo.png',
                              width: 70.w,
                              height: widget.logoSize.h,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.white,
                                  child: Icon(
                                    Icons.medical_services_rounded,
                                    size: widget.logoSize.w * 0.6,
                                    color: ColorsManager.primary,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 24.h),

          // Modern title with better typography
          AnimatedBuilder(
            animation: widget.showAnimation
                ? _floatingAnimation
                : const AlwaysStoppedAnimation(0.0),
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(
                    0, widget.showAnimation ? _floatingAnimation.value : 0),
                child: _buildModernTitle(),
              );
            },
          ),

          SizedBox(height: 12.h),

          // Enhanced tagline
          AnimatedBuilder(
            animation: widget.showAnimation
                ? _floatingAnimation
                : const AlwaysStoppedAnimation(0.0),
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0,
                    widget.showAnimation ? -_floatingAnimation.value / 2 : 0),
                child: _buildTagline(),
              );
            },
          ),

          SizedBox(height: 16.h),

          // Status indicators
          _buildStatusIndicators(),
        ],
      ),
    );
  }

  Widget _buildModernTitle() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: ShaderMask(
        shaderCallback: (Rect bounds) {
          return LinearGradient(
            colors: [
              Colors.white,
              Colors.white.withOpacity(0.9),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(bounds);
        },
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(
              fontSize: widget.titleFontSize.sp,
              fontWeight: FontWeight.w800,
              letterSpacing: 2.0,
              height: 1.2,
            ),
            children: [
              TextSpan(
                text: 'MED',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: widget.titleFontSize.sp,
                ),
              ),
              TextSpan(
                text: 'LINK',
                style: TextStyle(
                  color: const Color(
                      0xFF00E676), // Keeping the green accent for medical theme
                  fontSize: widget.titleFontSize.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTagline() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40.w),
      child: Column(
        children: [
          Text(
            "Your Digital Health Companion",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.white.withOpacity(0.95),
              fontWeight: FontWeight.w500,
              letterSpacing: 0.8,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            "Connect • Care • Cure",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.white.withOpacity(0.7),
              fontWeight: FontWeight.w400,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStatusDot(Colors.green, "Online"),
        SizedBox(width: 20.w),
        _buildStatusDot(const Color(0xFF00E676), "24/7 Support"),
        SizedBox(width: 20.w),
        _buildStatusDot(ColorsManager.secondary, "Secure"),
      ],
    );
  }

  Widget _buildStatusDot(Color color, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8.w,
            height: 8.w,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.5),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          SizedBox(width: 6.w),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomWave() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: ClipPath(
        clipper: WaveClipper(),
        child: Container(
          height: 30.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white.withOpacity(0.1),
                Colors.white.withOpacity(0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Custom painter for modern floating elements
class ModernFloatingElementsPainter extends CustomPainter {
  final Animation<double> pulseAnimation;
  final Animation<double> floatingAnimation;

  ModernFloatingElementsPainter({
    required this.pulseAnimation,
    required this.floatingAnimation,
  }) : super(repaint: Listenable.merge([pulseAnimation, floatingAnimation]));

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Medical cross elements
    _drawMedicalCrosses(canvas, size, paint);

    // Floating circles
    _drawFloatingCircles(canvas, size, paint);

    // DNA helix pattern
    _drawDNAPattern(canvas, size, paint);
  }

  void _drawMedicalCrosses(Canvas canvas, Size size, Paint paint) {
    paint.color = Colors.white.withOpacity(0.1);

    final crossSize = 15.0;
    final positions = [
      Offset(size.width * 0.15, size.height * 0.25),
      Offset(size.width * 0.85, size.height * 0.35),
      Offset(size.width * 0.75, size.height * 0.75),
    ];

    for (final pos in positions) {
      // Horizontal bar
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: pos,
            width: crossSize,
            height: crossSize / 3,
          ),
          const Radius.circular(2),
        ),
        paint,
      );

      // Vertical bar
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: pos,
            width: crossSize / 3,
            height: crossSize,
          ),
          const Radius.circular(2),
        ),
        paint,
      );
    }
  }

  void _drawFloatingCircles(Canvas canvas, Size size, Paint paint) {
    final circles = [
      {
        'pos': Offset(size.width * 0.1, size.height * 0.6),
        'radius': 25.0,
        'opacity': 0.08
      },
      {
        'pos': Offset(size.width * 0.9, size.height * 0.2),
        'radius': 35.0,
        'opacity': 0.06
      },
      {
        'pos': Offset(size.width * 0.2, size.height * 0.9),
        'radius': 20.0,
        'opacity': 0.1
      },
    ];

    for (final circle in circles) {
      final pos = circle['pos'] as Offset;
      final radius = circle['radius'] as double;
      final opacity = circle['opacity'] as double;

      paint.color = Colors.white.withOpacity(opacity * pulseAnimation.value);

      canvas.drawCircle(
        Offset(
          pos.dx,
          pos.dy + floatingAnimation.value,
        ),
        radius * pulseAnimation.value,
        paint,
      );
    }
  }

  void _drawDNAPattern(Canvas canvas, Size size, Paint paint) {
    paint.color = Colors.white.withOpacity(0.05);
    paint.strokeWidth = 2;
    paint.style = PaintingStyle.stroke;

    final path = Path();
    final amplitude = 30.0;
    final frequency = 0.02;

    for (double x = 0; x < size.width; x++) {
      final y = size.height * 0.4 +
          amplitude * sin(x * frequency + floatingAnimation.value * 0.1);

      if (x == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Wave clipper for bottom decoration
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.7);

    final firstControlPoint = Offset(size.width * 0.25, size.height);
    final firstEndPoint = Offset(size.width * 0.5, size.height * 0.8);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    final secondControlPoint = Offset(size.width * 0.75, size.height * 0.6);
    final secondEndPoint = Offset(size.width, size.height * 0.9);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
