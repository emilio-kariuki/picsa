import 'package:camera/camera.dart';

class CameraRepository {

  Future<CameraDescription> getCamera() async {
    final cameras = await availableCameras();
    return cameras.first;
  }

  void captureImage() {}

  void dispose({required CameraController controller}) {
    controller.dispose();
  }

  void initialize( {required CameraController controller}) {
    controller.initialize();
  }

  void takePicture( {required CameraController controller}) {
    controller.takePicture();
  }

  void toggleCamera({required CameraController controller}) async {
    List<CameraDescription> cameras = await availableCameras();
    controller = CameraController(
      cameras.firstWhere(
        (element) =>
            element.lensDirection == controller.description.lensDirection,
      ),
      ResolutionPreset.max,
    );
  }

  void toggleFlash({required CameraController controller}) {
    controller = CameraController(
      controller.description == controller.description
          ? controller.description
          : controller.description,
      ResolutionPreset.max,
    );
  }

  void toggleFrontCamera({required CameraController controller}) {
    controller = CameraController(
      controller.description == controller.description
          ? controller.description
          : controller.description,
      ResolutionPreset.max,
    );
  }

  void toggleRearCamera({required CameraController controller}) {
    controller = CameraController(
      controller.description == controller.description
          ? controller.description
          : controller.description,
      ResolutionPreset.max,
    );
  }

  void toggleTorch({required CameraController controller}) {
    controller = CameraController(
      controller.description == controller.description
          ? controller.description
          : controller.description,
      ResolutionPreset.max,
    );
  }
}
