import 'package:flutter/material.dart';

class AppTheme {
  // App Colors
  static const Color primaryColor = Color(0xFF88D4AB);
  static const Color primaryLightColor = Color(0xFFD1FAE5);
  static const Color primaryDarkColor = Color(0xFF10B981);
  static const Color secondaryColor = Color(0xFF7C3AED);
  static const Color accentColor = Color(0xFF10B981);
  static const Color errorColor = Color(0xFFEF4444);

  // Status Colors
  static const Color openStatusColor = Color(0xFFF97316);
  static const Color inProgressStatusColor = Color(0xFFFACC15);
  static const Color doneStatusColor = Color(0xFF10B981);

  // Text Colors
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Background Colors
  static const Color backgroundColor = Color(0xFFF9FAFB);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  
  // Dark Theme Colors - Material Design 3 based
  static const Color darkBackgroundColor = Color(0xFF1A1C1E);
  static const Color darkSurfaceColor = Color(0xFF1F1F1F);
  static const Color darkAppBarColor = Color(0xFF1F1F1F);
  static const Color darkCardColor = Color(0xFF2C2C2E);
  static const Color darkDividerColor = Color(0xFF3A3A3C);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFD0D0D0);
  static const Color darkTextHint = Color(0xFF8E8E93);
  static const Color darkDisabledColor = Color(0xFF5C5C5C);
  static const Color darkErrorColor = Color(0xFFFFB4AB);
  static const Color darkPrimaryContainer = Color(0xFF0A7EA4);
  static const Color darkOnPrimaryContainer = Color(0xFFE1F0FF);
  static const Color darkSurfaceVariant = Color(0xFF2C2C2E);
  static const Color darkOnSurfaceVariant = Color(0xFFC7C7C7);
  static const Color darkOutline = Color(0xFF5C5C5C);
  static const Color darkSurfaceContainerHighest = Color(0xFF3A3A3C);
  static const Color darkSurfaceContainerHigh = Color(0xFF2F2F31);
  static const Color darkSurfaceContainer = Color(0xFF252527);
  static const Color darkSurfaceContainerLow = Color(0xFF202022);
  static const Color darkSurfaceContainerLowest = Color(0xFF1A1A1C);

  // UI Colors
  static const Color borderColor = Color(0xFFD1D5DB);
  static const Color dividerColor = Color(0xFFE5E7EB);
  static const Color disabledColor = Color(0xFF9CA3AF);

  // Task Block Colors
  static const Color taskBlockYellow = Color(0xFFFEF9C3);
  static const Color taskBlockMint = Color(0xFFD1FAE5);
  static const Color taskBlockLavender = Color(0xFFE0E7FF);

  // Status Badges
  static const Color badgeBackground = Color(0xFFF3F4F6);
  static const Color badgeText = Color(0xFF111827);

  // Text Styles
  static const TextStyle heading1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );

  static const TextStyle bodyText = TextStyle(
    fontSize: 16,
    color: textSecondary,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 14,
    color: textSecondary,
  );

  /// Returns the light theme for the application
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        error: errorColor,
        surface: surfaceColor,
        onPrimary: textOnPrimary,
        onSecondary: textOnPrimary,
        onSurface: textPrimary,
        onError: textOnPrimary,
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'ProductSans',
          fontSize: 57,
          fontWeight: FontWeight.w400,
          color: textPrimary,
          letterSpacing: -0.25,
          height: 1.12,
        ),
        displayMedium: TextStyle(
          fontFamily: 'ProductSans',
          fontSize: 45,
          fontWeight: FontWeight.w400,
          color: textPrimary,
          height: 1.15,
        ),
        displaySmall: TextStyle(
          fontFamily: 'ProductSans',
          fontSize: 36,
          fontWeight: FontWeight.w400,
          color: textPrimary,
          height: 1.22,
        ),
        headlineLarge: TextStyle(
          fontFamily: 'ProductSans',
          fontSize: 32,
          fontWeight: FontWeight.w400,
          color: textPrimary,
          height: 1.25,
        ),
        headlineMedium: heading1.copyWith(
          fontFamily: 'ProductSans',
          fontSize: 28,
          height: 1.29,
        ),
        headlineSmall: heading2.copyWith(
          fontFamily: 'ProductSans',
          fontSize: 24,
          height: 1.33,
        ),
        titleLarge: TextStyle(
          fontFamily: 'ProductSans',
          fontSize: 22,
          fontWeight: FontWeight.w500,
          color: textPrimary,
          height: 1.27,
        ),
        titleMedium: TextStyle(
          fontFamily: 'ProductSans',
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textPrimary,
          letterSpacing: 0.15,
          height: 1.5,
        ),
        titleSmall: TextStyle(
          fontFamily: 'ProductSans',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textPrimary,
          letterSpacing: 0.1,
          height: 1.43,
        ),
        bodyLarge: bodyText.copyWith(
          fontFamily: 'ProductSans',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: textPrimary,
          letterSpacing: 0.5,
          height: 1.5,
        ),
        bodyMedium: bodyText.copyWith(
          fontFamily: 'ProductSans',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textSecondary,
          letterSpacing: 0.25,
          height: 1.43,
        ),
        bodySmall: caption.copyWith(
          fontFamily: 'ProductSans',
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: textSecondary,
          letterSpacing: 0.4,
          height: 1.33,
        ),
        labelLarge: TextStyle(
          fontFamily: 'ProductSans',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textPrimary,
          letterSpacing: 0.1,
          height: 1.43,
        ),
        labelMedium: caption.copyWith(
          fontFamily: 'ProductSans',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textSecondary,
          letterSpacing: 0.5,
          height: 1.33,
        ),
        labelSmall: caption.copyWith(
          fontFamily: 'ProductSans',
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: textTertiary,
          letterSpacing: 0.5,
          height: 1.45,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'ProductSans',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          letterSpacing: 0.15,
        ),
        iconTheme: IconThemeData(color: textPrimary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: textOnPrimary,
          elevation: 0,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: BorderSide(color: primaryColor, width: 1.5),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: errorColor, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: errorColor, width: 2),
        ),
        labelStyle: TextStyle(
          color: textSecondary,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        hintStyle: TextStyle(
          color: textTertiary,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        errorStyle: TextStyle(
          color: errorColor,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      cardTheme: CardTheme(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: dividerColor, width: 1),
        ),
        color: surfaceColor,
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        clipBehavior: Clip.antiAlias,
      ),
      dividerTheme: DividerThemeData(
        color: dividerColor,
        thickness: 1,
        space: 1,
      ),
      tabBarTheme: TabBarTheme(
        labelColor: primaryColor,
        unselectedLabelColor: textSecondary,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(width: 2, color: primaryColor),
        ),
        labelStyle: TextStyle(
          fontFamily: 'ProductSans',
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'ProductSans',
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surfaceColor,
        elevation: 8,
        selectedItemColor: primaryColor,
        unselectedItemColor: textTertiary,
        selectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: textOnPrimary,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: textPrimary,
        contentTextStyle: TextStyle(
          color: textOnPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }

  /// Returns the dark theme for the application
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBackgroundColor,
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        error: darkErrorColor,
        surface: darkSurfaceColor,
        background: darkBackgroundColor,
        onPrimary: darkTextPrimary,
        onSecondary: darkTextPrimary,
        onSurface: darkTextPrimary,
        onError: darkTextPrimary,
        outline: darkOutline,
      ),
      disabledColor: darkDisabledColor,
      dividerColor: darkDividerColor,
      cardColor: darkCardColor,
      canvasColor: darkSurfaceColor,
      hoverColor: Colors.white.withOpacity(0.04),
      highlightColor: Colors.white.withOpacity(0.1),
      indicatorColor: primaryColor,
      cardTheme: CardTheme(
        elevation: 1,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: darkDividerColor, width: 1),
        ),
        color: darkCardColor,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        clipBehavior: Clip.antiAlias,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: darkAppBarColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: heading1.copyWith(color: darkTextPrimary),
        iconTheme: IconThemeData(color: darkTextPrimary),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurfaceColor,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: darkOutline, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: darkOutline, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: darkErrorColor, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: darkErrorColor, width: 2),
        ),
        labelStyle: TextStyle(
          color: darkTextSecondary,
          fontWeight: FontWeight.w400,
        ),
        hintStyle: TextStyle(
          color: darkTextHint,
          fontWeight: FontWeight.w400,
        ),
        errorStyle: TextStyle(
          color: darkErrorColor,
          fontWeight: FontWeight.w400,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: darkTextPrimary,
          disabledBackgroundColor: darkDisabledColor,
          disabledForegroundColor: darkTextHint,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: BorderSide(color: primaryColor),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: darkDividerColor,
        thickness: 1,
        space: 1,
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: darkTextPrimary,
          height: 1.12,
        ),
        displayMedium: TextStyle(
          color: darkTextPrimary,
          height: 1.15,
        ),
        displaySmall: TextStyle(
          color: darkTextPrimary,
          height: 1.22,
        ),
        headlineLarge: TextStyle(
          color: darkTextPrimary,
          height: 1.25,
        ),
        headlineMedium: heading1.copyWith(
          color: darkTextPrimary,
          height: 1.29,
        ),
        headlineSmall: heading2.copyWith(
          color: darkTextPrimary,
          height: 1.33,
        ),
        titleLarge: TextStyle(
          color: darkTextPrimary,
          height: 1.27,
        ),
        titleMedium: TextStyle(
          color: darkTextPrimary,
          height: 1.5,
        ),
        titleSmall: TextStyle(
          color: darkTextSecondary,
          height: 1.43,
        ),
        bodyLarge: bodyText.copyWith(
          color: darkTextSecondary,
          height: 1.5,
        ),
        bodyMedium: bodyText.copyWith(
          color: darkTextSecondary,
          height: 1.43,
        ),
        bodySmall: caption.copyWith(
          color: darkTextHint,
          height: 1.33,
        ),
        labelLarge: TextStyle(
          color: darkTextPrimary,
          height: 1.43,
        ),
        labelMedium: caption.copyWith(
          color: darkTextHint,
          height: 1.33,
        ),
        labelSmall: caption.copyWith(
          color: darkTextHint,
          height: 1.45,
        ),
      ),
      tabBarTheme: TabBarTheme(
        labelColor: primaryColor,
        unselectedLabelColor: darkTextSecondary,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(width: 2, color: primaryColor),
        ),
        labelStyle: TextStyle(
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w400,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: darkSurfaceColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: darkTextSecondary,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: darkTextPrimary,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: darkSurfaceColor,
        contentTextStyle: TextStyle(color: darkTextPrimary),
        actionTextColor: primaryColor,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: darkSurfaceColor,
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      dialogTheme: DialogTheme(
        backgroundColor: darkSurfaceColor,
        titleTextStyle: heading1.copyWith(color: darkTextPrimary),
        contentTextStyle: bodyText.copyWith(color: darkTextSecondary),
      ),
    );
  }
}