import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:storyqito_app/core/localization/l10n/app_localizations.dart';

class NotFoundScreen extends StatefulWidget {
  const NotFoundScreen({super.key});

  @override
  State<NotFoundScreen> createState() => _NotFoundScreenState();
}

class _NotFoundScreenState extends State<NotFoundScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _bounceAnimation = Tween<double>(begin: 0, end: 15).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final accentColor = theme.colorScheme.secondary;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _bounceAnimation.value),
                    child: child,
                  );
                },
                child:
                    isDark
                        ? _buildNotFoundDarkMode(accentColor)
                        : _buildNotFoundLightMode(accentColor),
              ),
              const SizedBox(height: 36.0),

              Text(
                AppLocalizations.of(context)!.page_not_found,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16.0),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Text(
                  AppLocalizations.of(context)!.page_not_found_description,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.textTheme.bodyLarge?.color?.withValues(
                      alpha: 0.7,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 36.0),

              // button to go home
              ElevatedButton.icon(
                onPressed: () => context.go("/"),
                icon: Icon(
                  color: theme.colorScheme.surfaceContainerLowest,
                  Icons.home,
                ),
                label: Text(AppLocalizations.of(context)!.go_to_home),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 10.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotFoundLightMode(Color accentColor) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Text(
          "Not Found",
          style: TextStyle(
            fontSize: 120.0,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade200,
          ),
        ),
        Text(
          "Not Found",
          style: TextStyle(
            fontSize: 100.0,
            fontWeight: FontWeight.bold,
            color: accentColor,
          ),
        ),
        Positioned(right: 150.0, top: 30.0, child: _buildMagnifierWidget()),
      ],
    );
  }

  Widget _buildNotFoundDarkMode(Color accentColor) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Text(
          "Not Found",
          style: TextStyle(
            fontSize: 120.0,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
        Text(
          "Not Found",
          style: TextStyle(
            fontSize: 100.0,
            fontWeight: FontWeight.bold,
            foreground:
                Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 3
                  ..color = accentColor,
          ),
        ),
        Positioned(
          right: 150.0,
          top: 30.0,
          child: _buildMagnifierWidget(isDark: true),
        ),
      ],
    );
  }

  Widget _buildMagnifierWidget({bool isDark = false}) {
    return Transform.rotate(
      angle: -math.pi / 4,
      child: Container(
        width: 36.0,
        height: 36.0,
        decoration: BoxDecoration(
          border: Border.all(
            color: isDark ? Colors.white : Colors.black,
            width: 6.0,
          ),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Transform.translate(
            offset: const Offset(28.0, 28.0),
            child: Container(
              width: 6.0,
              height: 24,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
