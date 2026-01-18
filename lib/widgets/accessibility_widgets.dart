import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import '../core/services/accessibility_service.dart';

/// Wrapper widget that provides accessibility features throughout the app
class AccessibilityWrapper extends StatefulWidget {
  final Widget child;

  const AccessibilityWrapper({super.key, required this.child});

  @override
  State<AccessibilityWrapper> createState() => _AccessibilityWrapperState();

  /// Get the accessibility service from context
  static AccessibilityService of(BuildContext context) {
    final state = context.findAncestorStateOfType<_AccessibilityWrapperState>();
    return state?._accessibilityService ?? AccessibilityService();
  }
}

class _AccessibilityWrapperState extends State<AccessibilityWrapper> {
  final AccessibilityService _accessibilityService = AccessibilityService();

  @override
  void initState() {
    super.initState();
    _initAccessibility();
  }

  Future<void> _initAccessibility() async {
    await _accessibilityService.init();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _accessibilityService,
      builder: (context, child) {
        return Semantics(
          container: true,
          explicitChildNodes: _accessibilityService.isTalkBackEnabled,
          child: widget.child,
        );
      },
    );
  }
}

/// A widget that speaks its content when tapped (if Read Aloud is enabled)
class ReadAloudText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const ReadAloudText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    final service = AccessibilityService();

    return GestureDetector(
      onLongPress: service.isReadAloudEnabled
          ? () => service.speak(text)
          : null,
      child: Semantics(
        label: service.isTalkBackEnabled ? text : null,
        child: Text(
          text,
          style: style,
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
        ),
      ),
    );
  }
}

/// A button that provides accessibility features
class AccessibleButton extends StatelessWidget {
  final String label;
  final String? semanticHint;
  final VoidCallback onPressed;
  final Widget child;
  final bool announceOnPress;

  const AccessibleButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.child,
    this.semanticHint,
    this.announceOnPress = true,
  });

  @override
  Widget build(BuildContext context) {
    final service = AccessibilityService();

    return Semantics(
      button: true,
      label: service.getSemanticLabel(label, hint: semanticHint),
      child: GestureDetector(
        onTap: () {
          if (announceOnPress && service.isReadAloudEnabled) {
            service.speak(label);
          }
          onPressed();
        },
        child: child,
      ),
    );
  }
}

/// A card that can be read aloud
class ReadAloudCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? description;
  final Widget child;

  const ReadAloudCard({
    super.key,
    required this.title,
    this.subtitle,
    this.description,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final service = AccessibilityService();
    
    String fullContent = title;
    if (subtitle != null) fullContent += '. $subtitle';
    if (description != null) fullContent += '. $description';

    return Semantics(
      label: service.isTalkBackEnabled ? fullContent : null,
      child: GestureDetector(
        onLongPress: service.isReadAloudEnabled
            ? () => service.speak(fullContent)
            : null,
        child: child,
      ),
    );
  }
}

/// Floating action button for Read Aloud
class ReadAloudFAB extends StatelessWidget {
  final String contentToRead;

  const ReadAloudFAB({
    super.key,
    required this.contentToRead,
  });

  @override
  Widget build(BuildContext context) {
    final service = AccessibilityService();

    if (!service.isReadAloudEnabled) {
      return const SizedBox.shrink();
    }

    return FloatingActionButton(
      onPressed: () {
        if (service.isSpeaking) {
          service.stop();
        } else {
          service.speak(contentToRead);
        }
      },
      backgroundColor: service.isSpeaking ? Colors.red : null,
      child: Icon(
        service.isSpeaking ? Icons.stop : Icons.volume_up,
      ),
    );
  }
}
