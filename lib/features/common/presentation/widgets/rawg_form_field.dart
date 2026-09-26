import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rawg/core/theme/app_font.dart';
import 'package:rawg/core/theme/app_palette.dart';
import 'package:rawg/core/theme/app_spacing.dart';

class RawgFormField extends StatefulWidget {
  const RawgFormField({super.key, this.enabled = true, this.isPassword = false, required this.hintText, required this.label, required this.controller, this.keyboardType = TextInputType.text});

  final bool enabled;
  final bool isPassword;

  final String hintText;
  final String label;

  final TextEditingController controller;

  final TextInputType keyboardType;

  @override
  State<RawgFormField> createState() => _RawgFormFieldState();
}

class _RawgFormFieldState extends State<RawgFormField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) => MergeSemantics(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(widget.label, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppFont.style(fontSize: 13)),
        const SizedBox(height: AppSpacing.sm),
        TextField(
          controller: widget.controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.lg),
            fillColor: AppPalette.gray4,
            filled: true,
            hintStyle: AppFont.style(color: AppPalette.gray1, fontSize: 18),
            hintText: widget.hintText,
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(_obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: AppPalette.gray1, size: AppSpacing.iconMd),
                    onPressed: () => setState(() => _obscureText = !_obscureText),
                    tooltip: _obscureText ? 'auth.showPassword'.tr() : 'auth.hidePassword'.tr(),
                  )
                : null,
          ),
          enabled: widget.enabled,
          keyboardType: widget.keyboardType,
          obscureText: widget.isPassword && _obscureText,
          style: AppFont.style(fontSize: 18),
        ),
      ],
    ),
  );
}
