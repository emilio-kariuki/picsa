import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingCircle extends StatelessWidget {
  const LoadingCircle({
    super.key,
    this.size = 35,
    this.color,
  });

  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Center(
        child: SpinKitCircle(
          color: color ?? Theme.of(context).primaryColor,
          size: size!,
        ),
      ),
    );
  }
}
