import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Future.delayed(const Duration(seconds: 3), () {
      Get.offNamed('/home');
    });

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colorScheme.primary.withOpacity(0.9),
              colorScheme.primary.withOpacity(0.6),
              Colors.grey[50]!,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(0.05),
                    alignment: Alignment.center,
                    child:
                        Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white,
                                    colorScheme.primary.withOpacity(0.2),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: colorScheme.primary.withOpacity(0.3),
                                    blurRadius: 16,
                                    spreadRadius: 4,
                                    offset: const Offset(0, 4),
                                  ),
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.5),
                                    offset: const Offset(-4, -4),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons
                                    .work, // Replace with your app's logo asset
                                size: 80,
                                color: colorScheme.primary,
                              ),
                            )
                            .animate()
                            .scale(
                              duration: 1200.ms,
                              curve: Curves.easeOutBack,
                              begin: const Offset(0.7, 0.7),
                            )
                            .then()
                            .shimmer(
                              duration: 2000.ms,
                              color: Colors.white.withOpacity(0.8),
                            ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Freelance Helper',
                    style: GoogleFonts.poppins(
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: colorScheme.primary.withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.3),
                  const SizedBox(height: 16),
                  Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white,
                              colorScheme.primary.withOpacity(0.7),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: colorScheme.primary.withOpacity(0.3),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                          strokeWidth: 3,
                        ),
                      )
                      .animate()
                      .rotate(duration: 1000.ms, curve: Curves.linear)
                      .fadeIn(delay: 600.ms),
                ],
              ),
            ),
            // Wave animation at the bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child:
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          colorScheme.primary.withOpacity(0.2),
                          Colors.transparent,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ).animate().slideY(
                    begin: 0.5,
                    end: 0.0,
                    duration: 1500.ms,
                    curve: Curves.easeInOut,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
