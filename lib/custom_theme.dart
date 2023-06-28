// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../constants/colors.dart';

class CustomTheme {
  final BoxConstraints constraints;
  CustomTheme(this.constraints);

  final double designWidth = 375.0;
  final double designHeight = 812.0;

  double _getProportionateScreenWidth(inputWidth) {
    return (inputWidth / designWidth) * constraints.maxWidth;
  }

  elevatedButtonTheme() => ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            kPrimaryPurple,
          ),
          foregroundColor: MaterialStateProperty.all(
            Colors.white,
          ),
          elevation: MaterialStateProperty.all(
            0,
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                _getProportionateScreenWidth(4),
              ),
            ),
          ),
          textStyle: MaterialStateProperty.all(
            TextStyle(
              fontSize: _getProportionateScreenWidth(16),
            ),
          ),
          minimumSize: MaterialStateProperty.all(
            Size(
              double.infinity,
              _getProportionateScreenWidth(56),
            ),
          ),
        ),
      );

  outlinedButtonTheme() => OutlinedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            Colors.white,
          ),
          foregroundColor: MaterialStateProperty.all(
            kPrimaryPurple,
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                _getProportionateScreenWidth(4),
              ),
            ),
          ),
          elevation: MaterialStateProperty.all(0),
          side: MaterialStateProperty.all(
            BorderSide(
              width: _getProportionateScreenWidth(
                1.5,
              ),
              color: kPrimaryPurple,
            ),
          ),
          textStyle: MaterialStateProperty.all(
            TextStyle(
              fontSize: _getProportionateScreenWidth(
                16,
              ),
            ),
          ),
          minimumSize: MaterialStateProperty.all(
            Size(
              double.infinity,
              _getProportionateScreenWidth(56),
            ),
          ),
        ),
      );

  textButtonTheme() => TextButtonThemeData(
          style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(
          kPrimaryPurple,
        ),
        textStyle: MaterialStateProperty.all(
          TextStyle(
            fontSize: _getProportionateScreenWidth(17),
            fontWeight: FontWeight.w600,
          ),
        ),
      ));

  dividerTheme() => const DividerThemeData(
        color: kGreyShade3,
        thickness: 2,
      );
}
