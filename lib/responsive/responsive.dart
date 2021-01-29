import 'package:flutter/material.dart';

responsive(MediaQueryData data) {
  double _height = data.size.height;
  print(_height);
  if (_height < 500) {
    return 0.35;
  } else if (_height < 750) {
    return 0.40;
  } else {
    return 0.45;
  }
}
