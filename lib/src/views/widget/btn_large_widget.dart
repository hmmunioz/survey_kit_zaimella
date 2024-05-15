import 'package:flutter/material.dart';
import 'package:survey_kit/src/constants/colors.dart';

class BtnLargeWidget extends StatelessWidget {
  const BtnLargeWidget({
    super.key,
    this.functionToExecute,
    required this.text,
    this.width,
    this.color,
    this.icon,
    this.height,
  });
  final VoidCallback? functionToExecute;
  final String text;
  final IconData? icon;
  final Color? color;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: (0.02 * MediaQuery.of(context).size.height)),
      width: width ?? (0.8 * MediaQuery.of(context).size.width),
      height: height ?? (0.065 * MediaQuery.of(context).size.height),
      child: ElevatedButton(
        onPressed: functionToExecute,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
              color ?? ColorsTheme.mobilmellaTitleText),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  0.02 * MediaQuery.of(context).size.height),
              side: const BorderSide(
                color: ColorsTheme.mobilmellaBackgroundWhite,
                width: 1.0,
              ),
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (icon != null)
              Icon(
                icon,
                color: ColorsTheme.mobilmellaIconsWhite,
              ),
            if (icon != null)
              SizedBox(
                width: 0.04 * MediaQuery.of(context).size.width,
              ),
            Text(
              text,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: .04 * MediaQuery.of(context).size.width,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
