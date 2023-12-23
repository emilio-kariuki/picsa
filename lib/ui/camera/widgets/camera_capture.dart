import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picsa/domain/blocs/app_functionality/camera/camera_cubit.dart';

class CameraCapture extends StatelessWidget {
  const CameraCapture({
    super.key,
    required this.height,
    required this.controller,
  });

  final double height;
  final CameraController controller;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      bottom: height * 0.065,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: GestureDetector(
          onTap: () {
            context
                .read<CameraCubit>()
                .captureImage(controller: controller);
          },
          child: Container(
            padding: const EdgeInsets.all(2.5),
            decoration: const BoxDecoration(
                shape: BoxShape.circle,
                border: Border.fromBorderSide(BorderSide(
                    color: Colors.deepOrange, width: 2))),
            child: Container(
              height: height * 0.08,
              width: height * 0.08,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
