import 'package:picsa/domain/service/repository/repository.dart';
import 'package:picsa/utilities/packages.dart';

class CameraProvider extends CameraTemplate {
  final CameraRepository _cameraRepository;
  CameraProvider({required CameraRepository cameraRepository})
      : _cameraRepository = cameraRepository;

  @override
  Future<CameraController> initialize() {
    return _cameraRepository.initialize();
  }

  @override
  Future<String> takePicture({required CameraController controller}) {
    return _cameraRepository.takePicture(controller: controller);
  }

  @override
  Future<CameraController> toggleCamera({
    required CameraController controller,
    required bool isCameraChanged,
  }) {
    return _cameraRepository.toggleCamera(
      controller: controller,
      isCameraChanged: isCameraChanged,
    );
  }

  @override
  Future<void> toggleFlash({
    required CameraController controller,
    required bool isFlashOn,
  }) {
    return _cameraRepository.toggleFlash(
      controller: controller,
      isFlashOn: isFlashOn,
    );
  }

  @override
  Future<List<CameraDescription>> getCamera() {
    return _cameraRepository.getCamera();
  }

  @override
  Future<CameraController> toggleZoom(
      {required CameraController controller, required double zoom}) {
    return _cameraRepository.toggleZoom(controller: controller, zoom: zoom);
  }
  
  @override
  Future<CameraController> dispose({required CameraController controller}) {
    return _cameraRepository.dispose(controller: controller);
  }
  
  @override
  Future<CameraController> toggleFocus({required CameraController controller}) {
    return _cameraRepository.toggleFocus(controller: controller);
  }
}
