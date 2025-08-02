import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../data/models/project_model.dart';
import '../controllers/home_controller.dart';
import 'calculator_view.dart';
import 'earnings_view.dart' show EarningsView;
import 'project/projects_view.dart';
import 'settings_view.dart' show SettingsView;
import 'dart:math' show pi;

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Animate(
          effects: [
            FadeEffect(duration: 600.ms),
            SlideEffect(
              begin: const Offset(0, -0.2),
              curve: Curves.easeOutQuart,
            ),
          ],
          child: Text(
            'Freelance Hub',
            style: GoogleFonts.poppins(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
              color: Colors.white,
            ),
          ),
        ),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorScheme.primary,
                colorScheme.primary.withOpacity(0.85),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withOpacity(0.3),
                blurRadius: 12,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        ),
        actions: [
          Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(0.05),
            alignment: Alignment.center,
            child: IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: () {
                controller.loadProjects();
                _showRefreshSnackbar(context);
              },
            ).animate().rotate(duration: 600.ms, curve: Curves.easeOutBack),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildLoadingAnimation(context);
        }

        return AnimatedSwitcher(
          duration: 600.ms,
          switchInCurve: Curves.easeOutExpo,
          switchOutCurve: Curves.easeInExpo,
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.03),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          child: _getCurrentPage(context),
        );
      }),
      bottomNavigationBar: _buildCustomNavBar(context),
      floatingActionButton: _buildFloatingActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _getCurrentPage(BuildContext context) {
    switch (controller.currentIndex.value) {
      case 0:
        return _buildHomeDashboard(context);
      case 1:
        return ProjectsView();
      case 2:
        return CalculatorView();
      case 3:
        return EarningsView();
      case 4:
        return SettingsView();
      default:
        return Center(
          child: Text(
            "Page not found",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
        );
    }
  }

  Widget _buildHomeDashboard(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWelcomeHeader(context),
                const SizedBox(height: 28),
                _buildStatsCards(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          sliver: SliverToBoxAdapter(child: _buildRecentProjects(context)),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
          sliver: SliverToBoxAdapter(child: _buildQuickActions(context)),
        ),
      ],
    );
  }

  Widget _buildWelcomeHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome Back,',
          style: GoogleFonts.poppins(
            fontSize: 26,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
            letterSpacing: 0.5,
          ),
        ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1),
        Text(
          'Freelancer!',
          style: GoogleFonts.poppins(
            fontSize: 34,
            fontWeight: FontWeight.w800,
            color: Theme.of(context).colorScheme.primary,
            height: 1.1,
            letterSpacing: 0.5,
          ),
        ).animate().fadeIn(delay: 100.ms, duration: 400.ms).slideY(begin: 0.1),
      ],
    );
  }

  Widget _buildStatsCards() {
    return SizedBox(
      height: 140,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        children: [
          _buildStatCard(
                'Ongoing',
                controller.ongoingProjects.length.toString(),
                Colors.blue,
                Icons.work_outlined,
              )
              .animate()
              .fadeIn(delay: 200.ms)
              .slideX(begin: 0.2)
              .then()
              .rotate(
                begin: -0.02,
                end: 0.0,
                duration: 600.ms,
                curve: Curves.easeOutCubic,
              ),
          const SizedBox(width: 12),
          _buildStatCard(
                'Completed',
                controller.completedProjects.length.toString(),
                Colors.green,
                Icons.check_circle_outlined,
              )
              .animate()
              .fadeIn(delay: 300.ms)
              .slideX(begin: 0.2)
              .then()
              .rotate(
                begin: -0.02,
                end: 0.0,
                duration: 600.ms,
                curve: Curves.easeOutCubic,
              ),
          const SizedBox(width: 12),
          _buildStatCard(
                'Earnings',
                '\$${controller.totalEarnings.value.toStringAsFixed(2)}',
                Colors.amber,
                Icons.attach_money,
              )
              .animate()
              .fadeIn(delay: 400.ms)
              .slideX(begin: 0.2)
              .then()
              .rotate(
                begin: -0.02,
                end: 0.0,
                duration: 600.ms,
                curve: Curves.easeOutCubic,
              ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001) // Slight perspective for 3D effect
        ..rotateY(0.05), // Subtle tilt
      alignment: Alignment.center,
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.2), color.withOpacity(0.1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              offset: const Offset(4, 4),
              blurRadius: 8,
              spreadRadius: 1,
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.5),
              offset: const Offset(-4, -4),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(0.3),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentProjects(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Recent Projects',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.grey[900],
                letterSpacing: 0.5,
              ),
            ),
            const Spacer(),
            if (controller.allProjects.isNotEmpty)
              TextButton(
                    onPressed: () => controller.changePage(1),
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'View All',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(
                          Icons.arrow_forward,
                          size: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ],
                    ),
                  )
                  .animate()
                  .fadeIn(delay: 300.ms)
                  .scale(begin: const Offset(0.9, 0.9)),
          ],
        ),
        const SizedBox(height: 20),
        if (controller.allProjects.isEmpty)
          _buildEmptyState(context)
        else
          ...controller.allProjects
              .take(3)
              .map(
                (project) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildProjectCard(project)
                      .animate()
                      .fadeIn(delay: 400.ms)
                      .slideY(begin: 0.2)
                      .then()
                      .rotate(
                        begin: -0.02,
                        end: 0.0,
                        duration: 600.ms,
                        curve: Curves.easeOutCubic,
                      ),
                ),
              ),
      ],
    );
  }

  Widget _buildProjectCard(Project project) {
    final isCompleted = project.status == 'Completed';
    final color = isCompleted ? Colors.green : Colors.blue;

    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001) // Slight perspective for 3D effect
        ..rotateY(0.05), // Subtle tilt
      alignment: Alignment.center,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => controller.navigateToProjectDetails(project),
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, color.withOpacity(0.05)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  offset: const Offset(4, 4),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.5),
                  offset: const Offset(-4, -4),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          color.withOpacity(0.3),
                          color.withOpacity(0.1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      isCompleted ? Icons.check_circle : Icons.work_outline,
                      color: color,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          project.title,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[900],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${project.clientName} • ${project.status}',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.green.withOpacity(0.2),
                          Colors.green.withOpacity(0.1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      '\$${project.totalAmount.toStringAsFixed(2)}',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001) // Slight perspective for 3D effect
        ..rotateY(0.05), // Subtle tilt
      alignment: Alignment.center,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey[100]!.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              offset: const Offset(4, 4),
              blurRadius: 8,
              spreadRadius: 1,
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.5),
              offset: const Offset(-4, -4),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[200]!.withOpacity(0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[400]!.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.work_outline,
                size: 64,
                color: Colors.grey[500],
              ),
            ).animate().scale(duration: 800.ms, curve: Curves.elasticOut),
            const SizedBox(height: 20),
            Text(
              'No Projects Yet',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Start by adding your first project',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                  onPressed: () => controller.navigateToAddProject(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 14,
                    ),
                    elevation: 0,
                    shadowColor: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.3),
                    surfaceTintColor: Colors.transparent,
                  ),
                  child: Text(
                    'Add Project',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                )
                .animate()
                .fadeIn(delay: 500.ms)
                .scale(begin: const Offset(0.9, 0.9)),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.grey[900],
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 20),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 3,
          children: [
            _buildQuickActionButton(
                  'Add Project',
                  Icons.add,
                  Theme.of(context).colorScheme.primary,
                  () => controller.navigateToAddProject(),
                )
                .animate()
                .fadeIn(delay: 200.ms)
                .scale(begin: const Offset(0.9, 0.9)),
            _buildQuickActionButton(
                  'Calculator',
                  Icons.calculate,
                  Colors.amber,
                  () => controller.changePage(2),
                )
                .animate()
                .fadeIn(delay: 300.ms)
                .scale(begin: const Offset(0.9, 0.9)),
            _buildQuickActionButton(
                  'Earnings',
                  Icons.analytics,
                  Colors.purple,
                  () => controller.changePage(3),
                )
                .animate()
                .fadeIn(delay: 400.ms)
                .scale(begin: const Offset(0.9, 0.9)),
            _buildQuickActionButton(
                  'Settings',
                  Icons.settings,
                  Colors.blueGrey,
                  () => controller.changePage(4),
                )
                .animate()
                .fadeIn(delay: 500.ms)
                .scale(begin: const Offset(0.9, 0.9)),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001) // Slight perspective for 3D effect
        ..rotateY(0.05), // Subtle tilt
      alignment: Alignment.center,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onPressed,
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, color.withOpacity(0.05)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  offset: const Offset(4, 4),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.5),
                  offset: const Offset(-4, -4),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          color.withOpacity(0.3),
                          color.withOpacity(0.1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(icon, size: 22, color: color),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    label,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[900],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomNavBar(BuildContext context) {
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001) // Slight perspective for 3D effect
        ..rotateY(0.05), // Subtle tilt
      alignment: Alignment.center,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey[50]!.withOpacity(0.9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 12,
              spreadRadius: 1,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    0,
                    Icons.home_outlined,
                    Icons.home,
                    'Home',
                    context,
                  ),
                  _buildNavItem(
                    1,
                    Icons.work_outline,
                    Icons.work,
                    'Projects',
                    context,
                  ),
                  const SizedBox(width: 56), // Space for FAB
                  _buildNavItem(
                    2,
                    Icons.calculate_outlined,
                    Icons.calculate,
                    'Calc',
                    context,
                  ),
                  _buildNavItem(
                    3,
                    Icons.analytics_outlined,
                    Icons.analytics,
                    'Stats',
                    context,
                  ),
                  _buildNavItem(
                    4,
                    Icons.analytics_outlined,
                    Icons.analytics,
                    'Settings',
                    context,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    IconData icon,
    IconData activeIcon,
    String label,
    BuildContext context,
  ) {
    return Obx(() {
      final isActive = controller.currentIndex.value == index;
      return GestureDetector(
        onTap: () => controller.changePage(index),
        child:
            AnimatedContainer(
              duration: 300.ms,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: isActive
                    ? LinearGradient(
                        colors: [
                          Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.2),
                          Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                borderRadius: BorderRadius.circular(14),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : [],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isActive ? activeIcon : icon,
                    size: 26,
                    color: isActive
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey[600],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: isActive
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey[600],
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ).animate().scale(
              delay: 200.ms,
              duration: 400.ms,
              curve: Curves.easeOutCubic,
              begin: isActive
                  ? const Offset(1.05, 1.05)
                  : const Offset(1.0, 1.0),
            ),
      );
    });
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001) // Slight perspective for 3D effect
        ..rotateY(0.05), // Subtle tilt
      alignment: Alignment.center,
      child:
          FloatingActionButton(
                onPressed: () => controller.navigateToAddProject(),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                elevation: 4,
                shape: const CircleBorder(),
                child: const Icon(Icons.add, size: 30),
              )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .scale(duration: 1500.ms, curve: Curves.easeInOutSine)
              .then()
              .shake(duration: 1000.ms, hz: 2),
    );
  }

  Widget _buildLoadingAnimation(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.primary.withOpacity(0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.3),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                  strokeWidth: 5,
                ),
              )
              .animate()
              .rotate(duration: 1000.ms, curve: Curves.linear)
              .scale(delay: 200.ms, duration: 800.ms, curve: Curves.elasticOut),
          const SizedBox(height: 28),
          Text(
            'Preparing Your Dashboard...',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ).animate().fadeIn(delay: 300.ms),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation(
              Theme.of(context).colorScheme.primary,
            ),
            minHeight: 5,
          ).animate().fadeIn(delay: 500.ms).then().fadeOut(delay: 1000.ms),
        ],
      ),
    );
  }

  void _showRefreshSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.autorenew, size: 22, color: Colors.white),
            const SizedBox(width: 10),
            Text(
              'Refreshing Data...',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        elevation: 4,
      ),
    );
  }
}
