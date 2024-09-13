import 'package:e_commerce_app/utils/constants/colors.dart';
import 'package:e_commerce_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class TRoundedContainer extends StatelessWidget {
  const TRoundedContainer({
    super.key,
    this.width,
    this.height,
    this.radius = TSizes.lg,
    this.child,
    this.showBorder = false,
    this.borderColor = TColors.borderPrimary,
    this.backgroundColor = TColors.white,
    this.padding,
    this.margin
  });

  final double? width , height ;
  final double radius ;
  final Widget? child ;
  final bool showBorder ;
  final Color borderColor , backgroundColor ;
  final EdgeInsetsGeometry? padding , margin ;

  @override
  Widget build(BuildContext context) {
    return Container(
      width : width ,
      height: height,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(radius),
        border: showBorder ? Border.all(color: borderColor) : null ,
      ),
      child: child,
    );
  }
}
