import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final darkTheme = ThemeData(
  primarySwatch: Colors.grey,
  primaryColor: Colors.black87,
  accentColor: Colors.grey.shade700,
  primaryIconTheme: IconThemeData(color: Colors.white),
  accentIconTheme: IconThemeData(color: Colors.white60),
  brightness: Brightness.dark,
  backgroundColor: Colors.black,
  fontFamily: GoogleFonts.montserrat().fontFamily,
  dividerColor: Colors.grey.shade800,
  dialogBackgroundColor: Colors.grey[800],
  bottomSheetTheme: BottomSheetThemeData(
    backgroundColor: Colors.grey[900],
  ),
  bottomAppBarColor: Colors.grey[800],
  cardTheme: CardTheme(
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
  )
);