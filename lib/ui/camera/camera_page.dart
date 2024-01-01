import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:picsa/ui/camera/widgets/shots_container.dart';
import 'package:picsa/utilities/app_images.dart';

import '../../domain/blocs/app_functionality/camera/camera_cubit.dart';
import '../../domain/blocs/minimal_functionality/bool/bool_cubit.dart';
import 'widgets/back_button.dart';

class CameraPage extends StatelessWidget {
  CameraPage({
    super.key,
    required this.eventId,
  });

  final String eventId;

  late CameraController controller;

  bool isCameraChanged = false;

  bool isFlashOn = false;

  bool isFrontCamera = false;

  List<String> paths = [];

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return BlocConsumer<CameraCubit, CameraState>(
      bloc: context.read<CameraCubit>()..initialize(),
      listener: (context, state) {
        if (state is CameraChanged) {
          controller = state.controller;
        }
      },
      builder: (context, state) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarBrightness: Brightness.light,
          ),
          child: Scaffold(
            body: Column(
              children: [
                if (state is CameraChanged &&
                    state.controller.value.isInitialized)
                  SizedBox(
                    height: height * 0.93,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                      child: CameraPreview(
                        state.controller,
                        child: Stack(
                          fit: StackFit.loose,
                          children: [
                            toggleCamera(height, width),
                            captureImage(height),
                            toogleFlash(height, width),
                            PopButton(height: height, width: width),
                          ],
                        ),
                      ),
                    ),
                  ),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: Row(children: [
                    const Gap(10),
                    ShotsContainer(eventId: eventId),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                      decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(8)),
                      child: Icon(
                        Icons.upload_outlined,
                        size: height * 0.024,
                        color: Colors.grey[500],
                      ),
                    ),
                    const Gap(20),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                      decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(8)),
                      child: SvgPicture.asset(
                        AppImages.qr,
                        height: height * 0.024,
                        width: height * 0.024,
                        color: Colors.grey[500],
                      ),
                    ),
                  ]),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  BlocProvider<CameraCubit> captureImage(double height) {
    return BlocProvider(
      create: (context) => CameraCubit(),
      child: BlocConsumer<CameraCubit, CameraState>(
        listener: (context, state) {
          if (state is CameraCaptured) {
            context.read<CameraCubit>().uploadImage(
                  path: state.path,
                  eventId: eventId,
                );
            paths.add(state.path);
          }
        },
        builder: (context, state) {
          return Positioned.fill(
            bottom: height * 0.04,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () {
                  controller.value.isInitialized
                      ? context
                          .read<CameraCubit>()
                          .captureImage(controller: controller)
                      : context.read<CameraCubit>().initialize();
                },
                child: Container(
                  padding: const EdgeInsets.all(2.5),
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.fromBorderSide(
                          BorderSide(color: Colors.deepOrange, width: 4))),
                  child: Container(
                    height: height * 0.07,
                    width: height * 0.07,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  BlocProvider<BoolCubit> toggleCamera(double height, double width) {
    return BlocProvider(
      create: (context) => BoolCubit(),
      child: BlocConsumer<BoolCubit, BoolState>(
        listener: (context, state) {
          if (state is BoolChanged) {
            isCameraChanged = !state.value;
          }
        },
        builder: (context, state) {
          return Positioned(
            bottom: height * 0.05,
            right: width * 0.2,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () {
                  context.read<BoolCubit>().change(value: isCameraChanged);
                  context.read<CameraCubit>().toggleCamera(
                        controller: controller,
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
        },
      ),
    );
  }

  BlocProvider<BoolCubit> toogleFlash(double height, double width) {
    return BlocProvider(
      create: (context) => BoolCubit(),
      child: BlocConsumer<BoolCubit, BoolState>(
        listener: (context, state) {
          if (state is BoolChanged) {
            isFlashOn = !state.value;
          }
        },
        builder: (context, state) {
          return Positioned(
            top: height * 0.145,
            right: width * 0.05,
            child: GestureDetector(
              onTap: () {
                context.read<BoolCubit>().change(value: isFlashOn);
                context.read<CameraCubit>().toggleFlash(
                      controller: controller,
                      isFlashOn: isFlashOn,
                    );
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black.withOpacity(0.4),
                ),
                child: Icon(
                  isFlashOn ? Icons.flash_off : Icons.flash_on,
                  color: Colors.white,
                  size: 15,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
