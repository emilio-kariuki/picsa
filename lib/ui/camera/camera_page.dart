// ignore_for_file: must_be_immutable

import 'package:picsa/domain/blocs/app/app_cubit.dart';
import 'package:picsa/utilities/packages.dart';

import '../../domain/blocs/app/camera_cubit.dart';
import '../../domain/blocs/minimal/bool/bool_cubit.dart';
import 'widgets/back_button.dart';

class CameraPage extends StatelessWidget {
  CameraPage({
    super.key,
    required this.eventId,
  });

  final String eventId;

  bool isCameraChanged = false;

  bool isFlashOn = false;

  bool isFrontCamera = false;

  List<String> paths = [];

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return BlocConsumer<CameraCubit, CameraState>(
      listenWhen: (previous, current) => current.status == CameraStatus.loaded,
      buildWhen: (previous, current) => current.status == CameraStatus.loaded,
      listener: (context, state) {
        if (state.status == CameraStatus.error) {
          context.read<CameraCubit>().initialize();
        }

        debugPrint(state.status.toString());
      },
      builder: (context, state) {
      
          return AnnotatedRegion<SystemUiOverlayStyle>(
              value: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarBrightness: Brightness.light,
              ),
              child: Scaffold(
                body: SizedBox(
                  height: height,
                  child: CameraPreview(
                    state.controller!,
                    child: Stack(
                      fit: StackFit.loose,
                      children: [
                        toggleCamera(height, width),
                        captureImage(height),
                        topMenu(height, width),
                        PopButton(height: height, width: width),
                      ],
                    ),
                  ),
                ),
              ),
            );
        
      },
    );
  }

  captureImage(double height) {
    return BlocConsumer<CameraCubit, CameraState>(
      listener: (context, state) {
        if (state.status == CameraStatus.captured) {
          debugPrint('captured');
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
                context.read<CameraCubit>().captureImage();
              },
              child: Container(
                padding: const EdgeInsets.all(2.5),
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.fromBorderSide(BorderSide(
                        color: Color(
                          0xff70B93E,
                        ),
                        width: 4))),
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
                        isCameraChanged: isCameraChanged,
                      );
                },
                child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.black.withOpacity(0.4),
                        border:
                            Border.all(width: 0.5, color: Colors.grey[500]!)),
                    child: SvgPicture.asset(
                      AppImages.toggle,
                      color: Colors.grey[400],
                      height: 2.5 * SizeConfig.heightMultiplier,
                      width: 2.5 * SizeConfig.heightMultiplier,
                    )),
              ),
            ),
          );
        },
      ),
    );
  }

  BlocProvider<BoolCubit> topMenu(double height, double width) {
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
            top: height * 0.08,
            right: 15,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    context.read<BoolCubit>().change(value: isFlashOn);
                    context.read<CameraCubit>().toggleFlash(
                          isFlashOn: isFlashOn,
                        );
                  },
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.black.withOpacity(0.4),
                          border:
                              Border.all(width: 0.5, color: Colors.grey[500]!)),
                      child: SvgPicture.asset(
                        isFlashOn ? AppImages.flashOn : AppImages.flashOff,
                        color: Colors.grey[300],
                        height: 2.5 * SizeConfig.heightMultiplier,
                        width: 2.5 * SizeConfig.heightMultiplier,
                      )),
                ),
                Gap(1 * SizeConfig.heightMultiplier),
                GestureDetector(
                  onTap: () => showModalBottomSheet(
                      clipBehavior: Clip.antiAlias,
                      isScrollControlled: true,
                      backgroundColor: const Color(0xff1E1E1E),
                      barrierColor: Colors.black.withOpacity(0.6),
                      elevation: 5,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15))),
                      context: context,
                      builder: (context) {
                        return CameraQr(
                          eventId: eventId,
                        );
                      }),
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.black.withOpacity(0.4),
                          border:
                              Border.all(width: 0.5, color: Colors.grey[500]!)),
                      child: SvgPicture.asset(
                        AppImages.qr,
                        color: Colors.grey[300],
                        height: 2.5 * SizeConfig.heightMultiplier,
                        width: 2.5 * SizeConfig.heightMultiplier,
                      )),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class CameraQr extends StatelessWidget {
  const CameraQr({super.key, required this.eventId});
  final String eventId;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff212121),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 2 * SizeConfig.widthMultiplier,
            vertical: 3 * SizeConfig.heightMultiplier),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                height: 5,
                width: 10 * SizeConfig.widthMultiplier,
                decoration: BoxDecoration(
                    color: Colors.grey[600],
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),
            Gap(2 * SizeConfig.heightMultiplier),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    context.pop();
                  },
                  child: SvgPicture.asset(
                    AppImages.back,
                    height: 3 * SizeConfig.heightMultiplier,
                    width: 3 * SizeConfig.heightMultiplier,
                    color: Colors.grey[600],
                  ),
                ),
                Gap(3 * SizeConfig.heightMultiplier),
                Text(
                  'Scan QR Code',
                  style: GoogleFonts.inter(
                    fontSize: 2.5 * SizeConfig.textMultiplier,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    context.pop();
                  },
                  child: SvgPicture.asset(
                    AppImages.uplaod,
                    height: 2.5 * SizeConfig.heightMultiplier,
                    width: 2.5 * SizeConfig.heightMultiplier,
                    color: Colors.grey[600],
                  ),
                ),
                Gap(2 * SizeConfig.heightMultiplier),
              ],
            ),
            Gap(5 * SizeConfig.heightMultiplier),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: QrImageView(
                data: "${AppConstants.APP_URL}/camera/$eventId",
                version: QrVersions.auto,
                size: 180.0,
              ),
            ),
            Gap(5 * SizeConfig.heightMultiplier),
            BlocProvider(
              create: (context) => AppCubit(),
              child: Builder(builder: (context) {
                return GestureDetector(
                  onTap: () => context.read<AppCubit>().copyToClipboard(
                        text: "${AppConstants.APP_URL}/camera/$eventId",
                      ),
                  child: Container(
                    height: 7 * SizeConfig.heightMultiplier,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: MediaQuery.sizeOf(context).width,
                    decoration: BoxDecoration(
                      color: const Color(0xff1C1C1C),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: BlocBuilder<AppCubit, AppState>(
                      builder: (context, state) {
                        return Center(
                          child: Text(
                            state.status == AppStatus.success
                                ? 'Copied'
                                : 'Copy Link',
                            style: GoogleFonts.inter(
                              fontSize: 2 * SizeConfig.textMultiplier,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[600],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}
