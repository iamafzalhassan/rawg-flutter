import 'package:flutter/cupertino.dart';
import 'package:rawg/core/theme/app_palette.dart';
import 'package:rawg/core/theme/app_spacing.dart';

class RawgLoader extends StatelessWidget {
  const RawgLoader({super.key, this.radius = AppSpacing.loaderMd, this.color = AppPalette.gray1});

  final double radius;

  final Color color;

  @override
  Widget build(BuildContext context) => CupertinoActivityIndicator(color: color, radius: radius);
}
