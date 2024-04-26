import 'package:picsa/domain/service/providers/camera_provider.dart';
import 'package:picsa/domain/service/repository/image_repository.dart';
import 'package:picsa/domain/service/service_locator.dart';
import 'package:picsa/utilities/packages.dart';

class CameraCubit extends Cubit<CameraState> {
  final _cameraProvider = service<CameraProvider>();
  CameraCubit() : super(CameraState());

  void initialize() async {
    emit(
      state.copyWith(
          status: CameraStatus.loading, message: "Initializing camera..."),
    );
    CameraController newController = await _cameraProvider.initialize();
    emit(state.copyWith(
        controller: newController,
        status: CameraStatus.loaded,
        message: "Camera initialized"));
  }

  Future<void> captureImage() async {
    final path =
        await _cameraProvider.takePicture(controller: state.controller!);
    emit(state.copyWith(
        path: path, status: CameraStatus.captured, message: "Image captured"));
  }

  void toggleCamera({
    required bool isCameraChanged,
  }) async {
    final controllers = await _cameraProvider.toggleCamera(
      controller: state.controller!,
      isCameraChanged: isCameraChanged,
    );
    emit(state.copyWith(
        controller: controllers,
        status: CameraStatus.loaded,
        message: "Camera changed"));
  }

  void toggleFlash({required bool isFlashOn}) async {
    await _cameraProvider.toggleFlash(
        controller: state.controller!, isFlashOn: isFlashOn);
  }

  void uploadImage({
    required String path,
    required String eventId,
  }) async {
    await ImageRepository().uploadImage(path: path, eventId: eventId);
  }
}

//* camera state

enum CameraStatus { initial, loading, captured, scanned, loaded, error }

class CameraState {
  final CameraController? controller;
  final String path;
  final String message;
  final CameraStatus status;

  CameraState({
    this.controller,
    this.path = "",
    this.message = "",
    this.status = CameraStatus.initial,
  });

  CameraState copyWith({
    CameraController? controller,
    String path = "",
    String message = "",
    CameraStatus status = CameraStatus.initial,
  }) {
    return CameraState(
      controller: controller ?? this.controller,
      path: path,
      message: message,
      status: status,
    );
  }
}
