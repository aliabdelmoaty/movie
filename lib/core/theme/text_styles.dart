import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppTextStyles {
  // Headlines
  static TextStyle get s16w700 =>
      GoogleFonts.poppins(fontSize: 16.sp, fontWeight: FontWeight.w700);
  static TextStyle get s18w700 => GoogleFonts.poppins(
    fontSize: 18.sp,
    fontWeight: FontWeight.w700,
    height: 1.60,
  );

  // Body
  static TextStyle get s10w400 =>
      GoogleFonts.poppins(fontSize: 10.sp, fontWeight: FontWeight.w400);
  static TextStyle get s12w400 =>
      GoogleFonts.poppins(fontSize: 12.sp, fontWeight: FontWeight.w400);
  static TextStyle get s14w400 =>
      GoogleFonts.poppins(fontSize: 14.sp, fontWeight: FontWeight.w400);

  // Labels/Buttons
  static TextStyle get s12w500 =>
      GoogleFonts.poppins(fontSize: 12.sp, fontWeight: FontWeight.w500);
  static TextStyle get s12w600 =>
      GoogleFonts.poppins(fontSize: 12.sp, fontWeight: FontWeight.w600);
  static TextStyle get s14w500 =>
      GoogleFonts.poppins(fontSize: 14.sp, fontWeight: FontWeight.w500);
  static TextStyle get s14w600 =>
      GoogleFonts.poppins(fontSize: 14.sp, fontWeight: FontWeight.w600);
  static TextStyle get s14w700 =>
      GoogleFonts.poppins(fontSize: 14.sp, fontWeight: FontWeight.w700);
}

extension TextStyleX on TextStyle {
  TextStyle c(Color color) => copyWith(color: color);
}
