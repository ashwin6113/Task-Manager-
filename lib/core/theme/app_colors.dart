import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {


  const AppColors({
    required this.success,
    required this.warning,
    required this.info,
    required this.cardBackground,
    required this.shimmerBase,
    required this.shimmerHighlight,
  });
  // ── Stitch Design Colors ──
  static const primary = Color(0xFF2563EB);
  static const primaryDark = Color(0xFF0053DC);
  static const primaryGradientStart = Color(0xFF0053DC);
  static const primaryGradientEnd = Color(0xFF3E76FE);
  static const secondary = Color(0xFF506076);
  static const background = Color(0xFFF7F9FB);
  static const surface = Color(0xFFF7F9FB);
  static const surfaceLow = Color(0xFFF0F4F7);
  static const surfaceContainer = Color(0xFFEAEFF2);
  static const surfaceLowest = Color(0xFFFFFFFF);
  static const outlineVariant = Color(0xFFACB3B7);
  final Color success;
  final Color warning;
  final Color info;
  final Color cardBackground;
  final Color shimmerBase;
  final Color shimmerHighlight;

  // ── Light Colors ──
  static const light = AppColors(
    success: Color(0xFF2E7D32),
    warning: Color(0xFFED6C02),
    info: Color(0xFF0288D1),
    cardBackground: Color(0xFFF5F5F5),
    shimmerBase: Color(0xFFE0E0E0),
    shimmerHighlight: Color(0xFFF5F5F5),
  );

  // ── Dark Colors ──
  static const dark = AppColors(
    success: Color(0xFF66BB6A),
    warning: Color(0xFFFFA726),
    info: Color(0xFF29B6F6),
    cardBackground: Color(0xFF1E1E1E),
    shimmerBase: Color(0xFF2C2C2C),
    shimmerHighlight: Color(0xFF3D3D3D),
  );

  @override
  AppColors copyWith({
    Color? success,
    Color? warning,
    Color? info,
    Color? cardBackground,
    Color? shimmerBase,
    Color? shimmerHighlight,
  }) {
    return AppColors(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      info: info ?? this.info,
      cardBackground: cardBackground ?? this.cardBackground,
      shimmerBase: shimmerBase ?? this.shimmerBase,
      shimmerHighlight: shimmerHighlight ?? this.shimmerHighlight,
    );
  }

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      shimmerBase: Color.lerp(shimmerBase, other.shimmerBase, t)!,
      shimmerHighlight: Color.lerp(shimmerHighlight, other.shimmerHighlight, t)!,
    );
  }
}
