part of 'camera_cubit.dart';

@immutable
sealed class CameraState {}

final class CameraInitial extends CameraState {}

final class CameraChanged extends CameraState {
  CameraChanged({required this.controller});

  final CameraController controller;
}

final class CameraCaptured extends CameraState {
  CameraCaptured({required this.path});

  final String path;
}

final class CameraError extends CameraState {
  CameraError({required this.message});

  final String message;
}
