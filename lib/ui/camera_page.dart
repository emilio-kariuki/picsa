import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picsa/blocs/app_functionality/camera/camera_cubit.dart';
import 'package:picsa/blocs/minimal_functionality/bool/bool_cubit.dart';

import 'widgets/toggle_flash.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({
    super.key,
  });

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController controller;
  bool isCameraChanged = false;
  bool isFlashOn = false;
  bool isFrontCamera = false;

  List<String> paths = [];

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return BlocConsumer<CameraCubit, CameraState>(
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
            bottomNavigationBar: SizedBox(
              height: height * 0.1,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Take Picture'),
                  ),
                ),
              ),
            ),
            body: Stack(
              children: [
                if (state is CameraChanged &&
                    state.controller.value.isInitialized)
                  Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        )),
                        height: MediaQuery.of(context).size.height * 0.88,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          ),
                          child: CameraPreview(state.controller),
                        ),
                      ),
                    ],
                  ),
                BlocProvider(
                  create: (context) => BoolCubit(),
                  child: BlocConsumer<BoolCubit, BoolState>(
                    listener: (context, state) {
                      if (state is BoolChanged) {
                        isCameraChanged = !state.value;
                      }
                    },
                    builder: (context, state) {
                      return Positioned(
                        bottom: height * 0.08,
                        right: width * 0.2,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: GestureDetector(
                            onTap: () {
                              context
                                  .read<BoolCubit>()
                                  .change(value: isCameraChanged);
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
                ),
                BlocProvider(
                  create: (context) => CameraCubit(),
                  child: BlocConsumer<CameraCubit, CameraState>(
                    listener: (context, state) {
                      if (state is CameraCaptured) {
                        paths.add(state.path);
                        debugPrint(paths.toString());
                      }
                    },
                    builder: (context, state) {
                      return Positioned.fill(
                        bottom: height * 0.065,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: GestureDetector(
                            onTap: () {
                              context
                                  .read<CameraCubit>()
                                  .captureImage(controller: controller);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(2.5),
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.fromBorderSide(BorderSide(
                                      color: Colors.deepOrange, width: 2))),
                              child: Container(
                                height: height * 0.08,
                                width: height * 0.08,
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
                ),
                ToggleFlash(height: height, width: width),
                BlocProvider(
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
                ),
                Positioned.fill(
                  top: height * 0.08,
                  left: width * 0.04,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withOpacity(0.4),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
