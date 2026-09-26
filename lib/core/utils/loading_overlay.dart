import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rawg/core/theme/app_palette.dart';
import 'package:rawg/core/theme/app_spacing.dart';
import 'package:rawg/features/common/presentation/widgets/rawg_loader.dart';

abstract final class LoadingOverlay {
  static bool _isVisible = false;

  static void hide(BuildContext context) {
    if (!_isVisible) return;
    _isVisible = false;
    Navigator.pop(context);
  }

  static void show(BuildContext context) {
    if (_isVisible) return;
    _isVisible = true;
    showDialog(
      barrierColor: AppPalette.black.withValues(alpha: 0.5),
      barrierDismissible: false,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: AppSpacing.blurSigma, sigmaY: AppSpacing.blurSigma),
        child: const PopScope(
          canPop: false,
          child: Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [RawgLoader(color: AppPalette.white, radius: AppSpacing.loaderXl)],
            ),
          ),
        ),
      ),
      context: context,
    );
  }
}
