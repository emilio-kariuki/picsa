import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:meta/meta.dart';
import 'package:picsa/domain/service/repository/camera_repository.dart';

part 'camera_state.dart';

class CameraCubit extends Cubit<CameraState> {
  CameraCubit() : super(CameraInitial());

  void captureImage({required CameraController controller}) async {
    CameraRepository().takePicture(controller: controller);
  }

  void dispose({required CameraController controller}) {
    CameraRepository().dispose(controller: controller);
  }

  void initialize({required CameraController controller}) {
    CameraRepository().initialize(controller: controller);
  }

  void toggleCamera({required CameraController controller}) {
    CameraRepository().toggleCamera(controller: controller);
  }

  void toggleFlash({required CameraController controller}) {
    CameraRepository().toggleFlash(controller: controller);
  }

  
}
