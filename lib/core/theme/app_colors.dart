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
