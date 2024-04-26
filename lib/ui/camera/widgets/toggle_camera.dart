import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picsa/domain/blocs/minimal/bool/bool_cubit.dart';

import '../../../domain/blocs/app/camera_cubit.dart';

class ToggleCamera extends StatelessWidget {
  const ToggleCamera({
    super.key,
    required this.height,
    required this.width,
    required this.isCameraChanged,
    required this.controller,
  });

  final double height;
  final double width;
  final bool isCameraChanged;
  final CameraController controller;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: height * 0.08,
      right: width * 0.2,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: GestureDetector(
          onTap: () {
            context
                .read<BoolCubit>()
                .change(value: isCameraChanged);
            context.read<CameraCubit>().toggleCamera(
                  isCameraChanged: isCameraChanged,
                );
          },
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.black.withOpacity(0.4),
            ),
            child: const Icon(
              Icons.cameraswitch,
              color: Colors.white,
              size: 15,
            ),
          ),
        ),
      ),
    );
  }
}
