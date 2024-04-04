import 'package:flutter/material.dart';

abstract class AppThemeData {
  static ThemeData lightTheme(BuildContext context) => ThemeData.light().copyWith(
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.pink.shade200)),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.pink.shade800)),
        ),
        colorScheme: ColorScheme.light(
          primary: Colors.pink.shade100,
          onPrimary: Colors.grey.shade800,
          secondary: Colors.pink.shade200,
          onSecondary: Colors.grey.shade800,
        ),
        textTheme: Theme.of(context).textTheme.apply(
              fontFamily: 'Cera',
              bodyColor: Colors.grey.shade800,
            ),
        expansionTileTheme: Theme.of(context).expansionTileTheme.copyWith(
              shape: const RoundedRectangleBorder(),
              expandedAlignment: Alignment.centerLeft,
              tilePadding: const EdgeInsets.symmetric(horizontal: 8),
              collapsedIconColor: Colors.grey.shade800,
              iconColor: Colors.grey.shade800,
            ),
        cardTheme: CardTheme(
          elevation: 0,
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          clipBehavior: Clip.hardEdge,
          color: Colors.pink.shade100,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        listTileTheme: ListTileTheme.of(context).copyWith(
          tileColor: Colors.pink.shade100,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          leadingAndTrailingTextStyle: TextStyle(
            fontSize: MediaQuery.sizeOf(context).width <= 320 ? 14 : 16,
            color: Colors.grey.shade800,
            fontFamily: 'Cera',
          ),
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: MediaQuery.sizeOf(context).width <= 320 ? 20 : 24,
            color: Colors.grey.shade800,
            fontFamily: 'Cera',
          ),
        ),
        snackBarTheme: SnackBarThemeData(contentTextStyle: TextStyle(color: Colors.grey.shade200)),
        highlightColor: Colors.pink.shade200,
      );

  static ThemeData darkTheme(BuildContext context) => ThemeData.dark().copyWith(
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.pink.shade100)),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.pink.shade200)),
        ),
        textTheme: Theme.of(context).textTheme.apply(
              fontFamily: 'Cera',
              bodyColor: Colors.grey.shade300,
            ),
        colorScheme: ColorScheme.dark(
          primary: Colors.grey.shade800,
          onPrimary: Colors.grey.shade200,
          secondary: Colors.grey.shade700,
          onSecondary: Colors.grey.shade200,
        ),
        expansionTileTheme: Theme.of(context).expansionTileTheme.copyWith(
              expandedAlignment: Alignment.centerLeft,
              shape: const RoundedRectangleBorder(),
              tilePadding: const EdgeInsets.symmetric(horizontal: 8),
              collapsedIconColor: Colors.grey.shade200,
              iconColor: Colors.grey.shade200,
            ),
        cardTheme: CardTheme(
          elevation: 0,
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          clipBehavior: Clip.hardEdge,
          color: Colors.grey.shade800,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        listTileTheme: ListTileTheme.of(context).copyWith(
          tileColor: Colors.grey.shade800,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          leadingAndTrailingTextStyle: TextStyle(
            fontSize: MediaQuery.sizeOf(context).width <= 320 ? 16 : 20,
            color: Colors.grey.shade300,
            fontFamily: 'Cera',
          ),
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: MediaQuery.sizeOf(context).width <= 320 ? 20 : 24,
            color: Colors.grey.shade300,
            fontFamily: 'Cera',
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          contentTextStyle: TextStyle(color: Colors.grey.shade200),
        ),
        highlightColor: Colors.grey.shade700,
      );
}
