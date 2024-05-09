// ignore_for_file: must_be_immutable

import 'package:picsa/domain/blocs/app/app_cubit.dart';
import 'package:picsa/domain/blocs/minimal/page_cubit.dart';
import 'package:picsa/utilities/packages.dart';
import '../../domain/blocs/app/camera_cubit.dart';
import '../../domain/blocs/minimal/bool_cubit.dart';

class CameraPage extends StatelessWidget {
  CameraPage({
    super.key,
    required this.eventId,
  });

  final String eventId;

  bool isCameraChanged = false;

  bool isFlashOn = false;

  bool isHd = false;

  bool isZoom = false;

  double zoom = 0;

  List<double> zooms = [0, 0.5, 1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5];

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

        if (state.controller == null) {
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
            body: RefreshIndicator(
              onRefresh: () async {
                context.read<CameraCubit>().initialize();
              },
              child: SizedBox(
                height: height,
                child: GestureDetector(
                  onDoubleTap: () {
                    context
                        .read<CameraCubit>()
                        .toggleZoom(zoom: isZoom ? 3 : 1);
                    isZoom = !isZoom;
                  },

                  // onScaleUpdate: (details) {
                  //   final scale = details.scale;
                  //   if (scale > 4) {
                  //     context.read<CameraCubit>().toggleZoom(zoom: 4);
                  //   }
                  //   if (scale > 3) {
                  //     context.read<CameraCubit>().toggleZoom(zoom: 3);
                  //   }
                  //   if (scale > 1.5) {
                  //     context.read<CameraCubit>().toggleZoom(zoom: 2);
                  //   } else if (scale < 1.5 && scale > 1) {
                  //     context.read<CameraCubit>().toggleZoom(zoom: 1);
                  //   } else if (scale < 1 && scale > 0.5) {
                  //     context.read<CameraCubit>().toggleZoom(zoom: 0.5);
                  //   } else {
                  //     context.read<CameraCubit>().toggleZoom(zoom: 0);
                  //   }
                  // },
                  // onScaleEnd: (details) {
                  //   final scale = details.pointerCount;
                  //   if (scale > 4) {
                  //     context.read<CameraCubit>().toggleZoom(zoom: 4);
                  //   }
                  //   if (scale > 3) {
                  //     context.read<CameraCubit>().toggleZoom(zoom: 3);
                  //   }
                  //   if (scale > 1.5) {
                  //     context.read<CameraCubit>().toggleZoom(zoom: 2);
                  //   } else if (scale < 1.5 && scale > 1) {
                  //     context.read<CameraCubit>().toggleZoom(zoom: 1);
                  //   } else if (scale < 1 && scale > 0.5) {
                  //     context.read<CameraCubit>().toggleZoom(zoom: 0.5);
                  //   } else {
                  //     context.read<CameraCubit>().toggleZoom(zoom: 0);
                  //   }
                  // },
                  onScaleStart: (details) {},
                  child: CameraPreview(
                    state.controller!,
                    child: Stack(
                      fit: StackFit.loose,
                      children: [
                        toggleCamera(height, width),
                        captureImage(height),
                        topMenu(height, width),
                        // toggleZoom(height, width),
                        // PopButton(height: height, width: width),
                        Positioned.fill(
                            top: height * 0.08,
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Column(
                                children: [
                                  BlocBuilder<EventCubit, EventState>(
                                    bloc: context.read<EventCubit>()
                                      ..getEventById(id: eventId),
                                    builder: (context, state) {
                                      return SizedBox(
                                          width: 0.5 * width,
                                          child: Text(
                                            state.event?.name ?? "",
                                            textAlign: TextAlign.center,
                                          ));
                                    },
                                  )
                                ],
                              ),
                            )),
                        Positioned.fill(
                            top: height * 0.08,
                            left: height * 0.01,
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: GestureDetector(
                                  onTap: () => context.pop(),
                                  child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Colors.black.withOpacity(0.4),
                                          border: Border.all(
                                              width: 0.3,
                                              color: Colors.grey[500]!)),
                                      child: SvgPicture.asset(
                                        AppImages.back,
                                        color: Colors.grey[300],
                                        height:
                                            2.5 * SizeConfig.heightMultiplier,
                                        width:
                                            2.5 * SizeConfig.heightMultiplier,
                                      )),
                                )))
                      ],
                    ),
                  ),
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
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[200],
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
          if (state.status == BoolStatus.changed) {
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
                  context.read<BoolCubit>().changeValue(value: isCameraChanged);
                  context.read<CameraCubit>().toggleCamera(
                        isCameraChanged: isCameraChanged,
                      );
                },
                child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.black.withOpacity(0.4),
                        border:
                            Border.all(width: 0.3, color: Colors.grey[500]!)),
                    child: SvgPicture.asset(
                      AppImages.toggle,
                      color: Colors.grey[400],
                      height: 2.2 * SizeConfig.heightMultiplier,
                      width: 2.2 * SizeConfig.heightMultiplier,
                    )),
              ),
            ),
          );
        },
      ),
    );
  }

  toggleZoom(double height, double width) {
    return BlocProvider(
      create: (context) => PageCubit(),
      child: BlocConsumer<PageCubit, PageState>(
        listener: (context, state) {
          if (state.status == PageStatus.changed) {
            zoom = state.page.toDouble() + 1;
            context.read<CameraCubit>().toggleZoom(zoom: zoom);
          }
        },
        builder: (context, state) {
          return Positioned(
            bottom: height * 0.05,
            left: width * 0.2,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () {
                  context.read<PageCubit>().changePage(page: zoom.toInt());
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.black.withOpacity(0.4),
                      border: Border.all(width: 0.3, color: Colors.grey[500]!)),
                  child: SvgPicture.asset(
                    AppImages.add,
                    color: Colors.grey[400],
                    height: 2.2 * SizeConfig.heightMultiplier,
                    width: 2.2 * SizeConfig.heightMultiplier,
                  ),
                ),
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
          if (state.status == BoolStatus.changed) {
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
                    context.read<BoolCubit>().changeValue(value: isFlashOn);
                    context.read<CameraCubit>().toggleFlash(
                          isFlashOn: isFlashOn,
                        );
                  },
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 12),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.black.withOpacity(0.4),
                          border:
                              Border.all(width: 0.3, color: Colors.grey[500]!)),
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
                          horizontal: 10, vertical: 12),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.black.withOpacity(0.4),
                          border:
                              Border.all(width: 0.3, color: Colors.grey[500]!)),
                      child: SvgPicture.asset(
                        AppImages.qr,
                        color: Colors.grey[300],
                        height: 2.5 * SizeConfig.heightMultiplier,
                        width: 2.5 * SizeConfig.heightMultiplier,
                      )),
                ),
                Gap(1 * SizeConfig.heightMultiplier),
                BlocProvider(
                  create: (context) => AppCubit(),
                  child: Builder(builder: (context) {
                    return GestureDetector(
                      onTap: () => context.read<AppCubit>().shareContent(
                            text: "Share this camera image with other peops",
                            subject: "${AppConstants.APP_URL}/camera/$eventId",
                          ),
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 12),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.black.withOpacity(0.4),
                              border: Border.all(
                                  width: 0.3, color: Colors.grey[500]!)),
                          child: SvgPicture.asset(
                            AppImages.share,
                            color: Colors.grey[300],
                            height: 2.5 * SizeConfig.heightMultiplier,
                            width: 2.5 * SizeConfig.heightMultiplier,
                          )),
                    );
                  }),
                ),
                Gap(1 * SizeConfig.heightMultiplier),
                BlocProvider(
                  create: (context) => BoolCubit(),
                  child: Builder(builder: (context) {
                    return BlocConsumer<BoolCubit, BoolState>(
                      listener: (context, state) {
                        if (state.status == BoolStatus.changed) {
                          isHd = !state.value;
                        }
                      },
                      builder: (context, state) {
                        return GestureDetector(
                          onTap: () => context
                              .read<BoolCubit>()
                              .changeValue(value: isHd),
                          child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 12),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: isHd
                                      ? white
                                      : Colors.black.withOpacity(0.4),
                                  border: Border.all(
                                      width: 0.3, color: Colors.grey[500]!)),
                              child: Text(
                                "HD",
                                style: GoogleFonts.quicksand(
                                  fontWeight: FontWeight.bold,
                                  color: isHd ? Colors.black : Colors.grey[200],
                                  fontSize: 1.8 * SizeConfig.textMultiplier,
                                ),
                              )),
                        );
                      },
                    );
                  }),
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
      color: const Color(0xff212121),
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
