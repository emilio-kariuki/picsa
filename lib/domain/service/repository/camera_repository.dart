import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraRepository {
  Future<List<CameraDescription>> getCamera() async {
    final cameras = await availableCameras();
    return cameras;
  }

  Future<CameraController> initialize() async {
    try {
      List<CameraDescription> cameras = await availableCameras();
      CameraController controller = CameraController(
        cameras[0],
        ResolutionPreset.max,
      );
      await controller.initialize();
      return controller;
    } on CameraException catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<String> takePicture({required CameraController controller}) async {
    try {
      await AssetsAudioPlayer.newPlayer().open(
        Audio("assets/audio/capture.mp3"),
        autoStart: true,
        showNotification: false,
      );
      final path = await controller.takePicture();
      return path.path;
    } on CameraDescription catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<CameraController> toggleCamera({
    required CameraController controller,
    required bool isCameraChanged,
  }) async {
    try {
      controller.dispose();
      List<CameraDescription> cameras = await availableCameras();
      controller = CameraController(
        isCameraChanged ? cameras[0] : cameras[1],
        ResolutionPreset.max,
      );
      await controller.initialize();
      return controller;
    } on CameraException catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<void> toggleFlash(
      {required CameraController controller, required bool isFlashOn}) async {
    try {
      await controller
          .setFlashMode(isFlashOn ? FlashMode.off : FlashMode.torch);
    } on CameraException catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }
}
