import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CategoryIcon {
  static String getIconPath(int categoryId) {
    switch (categoryId) {
      case 1:
        return 'assets/icons/road.svg';
      case 2:
        return 'assets/icons/traffic-lights-fill.svg';
      case 3:
        return 'assets/icons/light.svg';
      case 4:
        return 'assets/icons/garbage.svg';
      case 5:
      default:
        return 'assets/icons/building.svg';
    }
  }

  static Widget build(int categoryId, {double size = 24, Color? color}) {
    return SvgPicture.asset(
      getIconPath(categoryId),
      width: size,
      height: size,
      colorFilter: color != null
          ? ColorFilter.mode(color, BlendMode.srcIn)
          : null,
    );
  }
}
