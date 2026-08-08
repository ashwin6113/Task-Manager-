import 'package:flutter/material.dart';

class AppSpacing {
  AppSpacing._();

  static const double xxs = 2.0;
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;

  // ── Common EdgeInsets shortcuts ──
  static const EdgeInsets paddingSm = EdgeInsets.all(sm);
  static const EdgeInsets paddingMd = EdgeInsets.all(md);
  static const EdgeInsets paddingLg = EdgeInsets.all(lg);
  static const EdgeInsets paddingHorizontalMd =
      EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets paddingVerticalMd =
      EdgeInsets.symmetric(vertical: md);
}

/// Reusable border radius values.
class AppRadius {
  AppRadius._();

  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double full = 999.0;

  static final BorderRadius borderRadiusSm = BorderRadius.circular(sm);
  static final BorderRadius borderRadiusMd = BorderRadius.circular(md);
  static final BorderRadius borderRadiusLg = BorderRadius.circular(lg);
  static final BorderRadius borderRadiusXl = BorderRadius.circular(xl);
  static final BorderRadius borderRadiusFull = BorderRadius.circular(full);
}

/// Reusable size constants for icons, avatars, etc.
class AppSizes {
  AppSizes._();

  static const double iconSm = 16.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;

  static const double avatarSm = 32.0;
  static const double avatarMd = 48.0;
  static const double avatarLg = 72.0;

  static const double buttonHeight = 48.0;
  static const double inputHeight = 56.0;
  static const double appBarHeight = 56.0;
}
