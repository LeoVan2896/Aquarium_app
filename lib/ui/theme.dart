import 'package:flutter/material.dart';

abstract final class AppColors {
  static const bg = Color(0xFF0A0A0A);
  static const recessed = Color(0xFF141416);
  static const surface = Color(0xFF1D1D1F);
  static const surface2 = Color(0xFF2A2A2C);
  static const surface3 = Color(0xFF38383A);

  static const text = Color(0xFFF5F5F7);
  static const muted = Color(0xFF86868B);
  static const muted2 = Color(0xFF6E6E73);

  static const accent = Color(0xFF2997FF);
  static const accent2 = Color(0xFF0077ED);
  static const pass = Color(0xFF30D158);
  static const fail = Color(0xFFFF453A);
  static const warn = Color(0xFFFF9F0A);

  static const border = Color(0x0FFFFFFF);
  static const border2 = Color(0x24FFFFFF);
}

abstract final class AppSpace {
  static const s1 = 4.0;
  static const s2 = 8.0;
  static const s3 = 14.0;
  static const s4 = 20.0;
  static const s5 = 28.0;
}

abstract final class AppRadius {
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 18.0;
  static const pill = 980.0;
}

abstract final class AppType {
  static const xs = 11.0;
  static const sm = 13.0;
  static const md = 15.0;
  static const lg = 17.0;
  static const xl = 22.0;
  static const largeTitle = 32.0;
}

ThemeData buildAppTheme() {
  const scheme = ColorScheme.dark(
    surface: AppColors.surface,
    onSurface: AppColors.text,
    primary: AppColors.accent,
    onPrimary: Colors.white,
    error: AppColors.fail,
    outline: AppColors.border2,
    outlineVariant: AppColors.border,
  );

  return ThemeData(
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.bg,
    splashFactory: InkSparkle.splashFactory,
    textTheme: const TextTheme(
      bodyMedium: TextStyle(fontSize: AppType.md, color: AppColors.text),
      bodySmall: TextStyle(fontSize: AppType.sm, color: AppColors.muted),
      labelSmall: TextStyle(fontSize: AppType.xs, color: AppColors.muted2),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.border,
      thickness: 1,
      space: 1,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.bg,
      surfaceTintColor: Colors.transparent,
      foregroundColor: AppColors.text,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: AppType.lg,
        fontWeight: FontWeight.w600,
        color: AppColors.text,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface2,
      labelStyle: const TextStyle(color: AppColors.muted),
      floatingLabelStyle: const TextStyle(color: AppColors.muted),
      hintStyle: const TextStyle(color: AppColors.muted2),
      suffixStyle: const TextStyle(color: AppColors.muted),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpace.s3,
        vertical: AppSpace.s3,
      ),
      border: UnderlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        borderSide: BorderSide.none,
      ),
      enabledBorder: UnderlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        borderSide: BorderSide.none,
      ),
      focusedBorder: UnderlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        borderSide: const BorderSide(color: AppColors.accent, width: 2),
      ),
      errorBorder: UnderlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        borderSide: const BorderSide(color: AppColors.fail),
      ),
      focusedErrorBorder: UnderlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        borderSide: const BorderSide(color: AppColors.fail, width: 2),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
        minimumSize: const Size(0, 50),
        shape: const StadiumBorder(),
        textStyle: const TextStyle(
          fontSize: AppType.md + 1,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: AppColors.text),
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: SegmentedButton.styleFrom(
        backgroundColor: AppColors.surface2,
        foregroundColor: AppColors.muted,
        selectedBackgroundColor: AppColors.surface3,
        selectedForegroundColor: AppColors.text,
        side: const BorderSide(color: AppColors.border2),
      ),
    ),
    chipTheme: const ChipThemeData(
      backgroundColor: AppColors.surface2,
      selectedColor: AppColors.surface3,
      checkmarkColor: AppColors.text,
      side: BorderSide(color: AppColors.border2),
      shape: StadiumBorder(),
      labelStyle: TextStyle(fontSize: AppType.md, color: AppColors.text),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: const WidgetStatePropertyAll(Colors.white),
      trackColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? AppColors.pass
            : AppColors.surface3,
      ),
      trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
    ),
  );
}
