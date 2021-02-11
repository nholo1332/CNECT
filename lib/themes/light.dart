import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final lightTheme = ThemeData(
  primarySwatch: Colors.indigo,
  primaryColor: Colors.indigo.shade900,
  accentColor: Color(0xFF666ad1),
  primaryIconTheme: IconThemeData(color: Colors.white),
  accentIconTheme: IconThemeData(color: Colors.white60),
  brightness: Brightness.light,
  backgroundColor: Color.fromRGBO(148, 199, 189, 1),
  fontFamily: GoogleFonts.montserrat().fontFamily,
  dividerColor: Colors.white54,
  cardTheme: CardTheme(
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
  )
);