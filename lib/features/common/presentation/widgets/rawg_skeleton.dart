import 'package:flutter/material.dart';
import 'package:rawg/core/theme/app_palette.dart';
import 'package:rawg/core/theme/app_spacing.dart';

class RawgSkeleton extends StatefulWidget {
  const RawgSkeleton({super.key, this.radius = AppRadius.xs, required double this.height, this.width}) : textStyle = null;

  const RawgSkeleton.text({super.key, required TextStyle this.textStyle, this.width}) : height = null, radius = AppRadius.xs;

  static const String _lineGlyph = ' ';

  final double radius;

  final double? height;
  final double? width;

  final TextStyle? textStyle;

  @override
  State<RawgSkeleton> createState() => _RawgSkeletonState();
}

class _RawgSkeletonState extends State<RawgSkeleton> with SingleTickerProviderStateMixin {
  static const double _minOpacity = 0.4;

  static const Duration _pulse = Duration(milliseconds: 900);

  late final AnimationController _controller = AnimationController(duration: _pulse, lowerBound: _minOpacity, vsync: this);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.value = 1;
    } else if (!_controller.isAnimating) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = widget.textStyle;
    return ExcludeSemantics(
      child: FadeTransition(
        opacity: _controller,
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(widget.radius)), color: AppPalette.gray6),
          height: widget.height,
          width: widget.width,
          child: textStyle == null ? null : Text(RawgSkeleton._lineGlyph, maxLines: 1, style: textStyle),
        ),
      ),
    );
  }
}
