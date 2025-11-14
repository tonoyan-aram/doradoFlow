import 'package:flutter/material.dart';

class FruitBackground extends StatelessWidget {
  final Widget child;
  final List<Color>? colors;

  const FruitBackground({
    super.key,
    required this.child,
    this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final gradientColors = colors ??
        const [
          Color(0xFF13CF8D),
          Color(0xFFFFBA4C),
          Color(0xFF7C3AED),
        ];
    final size = MediaQuery.sizeOf(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -size.width * 0.15,
            left: -size.width * 0.05,
            child: _FruitGlow(
              assetPath: 'assets/images/1.png',
              size: size.width * 0.55,
              opacity: 0.18,
            ),
          ),
          Positioned(
            bottom: -size.width * 0.25,
            right: -size.width * 0.1,
            child: _FruitGlow(
              assetPath: 'assets/images/2.png',
              size: size.width * 0.7,
              opacity: 0.2,
            ),
          ),
          Positioned(
            top: size.height * 0.35,
            left: size.width * 0.55,
            child: _FruitGlow(
              assetPath: 'assets/images/3.png',
              size: size.width * 0.35,
              opacity: 0.16,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.08),
                  Colors.transparent,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _FruitGlow extends StatelessWidget {
  final String assetPath;
  final double size;
  final double opacity;

  const _FruitGlow({
    required this.assetPath,
    required this.size,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Opacity(
        opacity: opacity,
        child: Image.asset(
          assetPath,
          width: size,
          height: size,
          color: Colors.white,
          colorBlendMode: BlendMode.modulate,
        ),
      ),
    );
  }
}

