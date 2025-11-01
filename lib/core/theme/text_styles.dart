import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppTextStyles {
  // Headlines
  static TextStyle get s32w700 => GoogleFonts.poppins(
    fontSize: 32.sp,
    fontWeight: FontWeight.w700,
    height: 1.60,
  );
  static TextStyle get s24w700 =>
      GoogleFonts.poppins(fontSize: 24.sp, fontWeight: FontWeight.w700);
  static TextStyle get s20w700 =>
      GoogleFonts.poppins(fontSize: 20.sp, fontWeight: FontWeight.w700);

  // Body
  static TextStyle get s16w400 => GoogleFonts.poppins(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    height: 1.60,
  );
  static TextStyle get s18w400 => GoogleFonts.poppins(
    fontSize: 18.sp,
    fontWeight: FontWeight.w400,
    height: 1.60,
  );
  static TextStyle get s10w400 =>
      GoogleFonts.poppins(fontSize: 10.sp, fontWeight: FontWeight.w400);
  static TextStyle get s14w400 =>
      GoogleFonts.poppins(fontSize: 14.sp, fontWeight: FontWeight.w400);

  // Labels/Buttons
  static TextStyle get s18w500 => GoogleFonts.poppins(
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,
    height: 1.60,
  );
  static TextStyle get s18w700 => GoogleFonts.poppins(
    fontSize: 18.sp,
    fontWeight: FontWeight.w700,
    height: 1.60,
  );
  static TextStyle get s16w500 => GoogleFonts.poppins(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    height: 1.60,
  );
  static TextStyle get s14w600 =>
      GoogleFonts.poppins(fontSize: 14.sp, fontWeight: FontWeight.w600);
  static TextStyle get s12w400 =>
      GoogleFonts.poppins(fontSize: 12.sp, fontWeight: FontWeight.w400);
  static TextStyle get s18w600 =>
      GoogleFonts.poppins(fontSize: 18.sp, fontWeight: FontWeight.w600);
  static TextStyle get s26w700 =>
      GoogleFonts.poppins(fontSize: 26.sp, fontWeight: FontWeight.w700);
  static TextStyle get s28w700 =>
      GoogleFonts.poppins(fontSize: 28.sp, fontWeight: FontWeight.w700);
  static TextStyle get s22w600 =>
      GoogleFonts.poppins(fontSize: 22.sp, fontWeight: FontWeight.w600);
}

extension TextStyleX on TextStyle {
  TextStyle c(Color color) => copyWith(color: color);
}
