import 'package:picsa/utilities/packages.dart';
import 'package:vibration/vibration.dart';

abstract class CameraTemplate {
  Future<List<CameraDescription>> getCamera();
  Future<CameraController> initialize();
  Future<String> takePicture({required CameraController controller});
  Future<CameraController> toggleCamera({
    required CameraController controller,
    required bool isCameraChanged,
  });
  Future<void> toggleFlash(
      {required CameraController controller, required bool isFlashOn});
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
      List<CameraDescription> cameras = await availableCameras();
      CameraController controller = CameraController(
          cameras[0], ResolutionPreset.max,
          imageFormatGroup: ImageFormatGroup.jpeg);

      await controller.initialize();
      await controller.setFlashMode(FlashMode.off);
      return controller;
    } on CameraException catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  @override
  Future<String> takePicture({required CameraController controller}) async {
    try {
      final hasVibration = await Vibration.hasVibrator();
      if (hasVibration != null && hasVibration) {
        Vibration.vibrate(duration: 115);
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
}
