import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:picsa/domain/service/repository/camera_repository.dart';
import 'package:picsa/domain/service/repository/image_repository.dart';

part 'camera_state.dart';

class CameraCubit extends Cubit<CameraState> {
  CameraCubit() : super(CameraInitial());

  Future<void> captureImage({
    required CameraController controller,
  }) async {
    final path = await CameraRepository().takePicture(controller: controller);
    emit(CameraCaptured(path: path));
  }

  void initialize() async {
    CameraController newController = await CameraRepository().initialize();
    emit(CameraChanged(controller: newController));
  }

  void toggleCamera({
    required CameraController controller,
    required bool isCameraChanged,
  }) async {
    final controllers = await CameraRepository().toggleCamera(
      controller: controller,
      isCameraChanged: isCameraChanged,
    );
    emit(CameraChanged(controller: controllers));
  }

  void toggleFlash(
      {required CameraController controller, required bool isFlashOn}) async {
    await CameraRepository()
        .toggleFlash(controller: controller, isFlashOn: isFlashOn);
  }

  void uploadImage({required String path, required String eventId,}) async {
    await ImageRepository().uploadImage(path: path, eventId: eventId);
  }
}
