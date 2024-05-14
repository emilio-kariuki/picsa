import 'package:permission_handler/permission_handler.dart';
import 'package:picsa/utilities/packages.dart';
import 'package:vibration/vibration.dart';

abstract class CameraTemplate {
  Future<List<CameraDescription>> getCamera();
  Future<CameraController> initialize();
  Future<CameraController> dispose({required CameraController controller});
  Future<String> takePicture({required CameraController controller});
  Future<CameraController> toggleCamera({
    required CameraController controller,
    required bool isCameraChanged,
  });
  Future<CameraController> toggleFocus({
    required CameraController controller,
  });
  Future<void> toggleFlash(
      {required CameraController controller, required bool isFlashOn});
  Future<CameraController> toggleZoom(
      {required CameraController controller, required double zoom});
}

class CameraRepository extends CameraTemplate {
  @override
  Future<List<CameraDescription>> getCamera() async {
    final cameras = await availableCameras();
    return cameras;
  }

  @override
  Future<CameraController> initialize() async {
    try {
      await Permission.camera.request();
      final cameras = await availableCameras();
      final controller = CameraController(cameras[0], ResolutionPreset.max,
          imageFormatGroup: ImageFormatGroup.jpeg);
      await controller.initialize();
      return controller;
    } on CameraException catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  @override
  Future<String> takePicture({required CameraController controller}) async {
    try {
      await controller.lockCaptureOrientation(DeviceOrientation.portraitUp);
      final hasVibration = await Vibration.hasVibrator();
      if (hasVibration != null && hasVibration) {
        Vibration.vibrate(duration: 100);
      }
      final path = await controller.takePicture();
      debugPrint(path.path);
      return path.path;
    } on CameraDescription catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  @override
  Future<CameraController> toggleCamera({
    required CameraController controller,
    required bool isCameraChanged,
  }) async {
    try {
      controller.dispose();
      List<CameraDescription> cameras = await availableCameras();
      controller = CameraController(
          isCameraChanged ? cameras[0] : cameras[1], ResolutionPreset.max,
          imageFormatGroup: ImageFormatGroup.jpeg);
      await controller.initialize();
      return controller;
    } on CameraException catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  @override
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

  @override
  Future<CameraController> toggleZoom(
      {required CameraController controller, required double zoom}) async {
    try {
      await controller.setZoomLevel(zoom);
      return controller;
    } on CameraException catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  @override
  Future<CameraController> dispose(
      {required CameraController controller}) async {
    try {
      await controller.dispose();
      return controller;
    } on CameraException catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  @override
  Future<CameraController> toggleFocus(
      {required CameraController controller}) async {
    try {
      await controller.setFocusPoint(const Offset(0.5, 0.5));
      return controller;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }
}
