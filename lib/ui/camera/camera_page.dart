// ignore_for_file: must_be_immutable, deprecated_member_use

import 'package:picsa/common_widgets/image_container.dart';
import 'package:picsa/common_widgets/subscription_sheet.dart';
import 'package:picsa/domain/blocs/app/app_cubit.dart';
import 'package:picsa/domain/blocs/app/user_cubit.dart';
import 'package:picsa/domain/blocs/minimal/page_cubit.dart';
import 'package:picsa/utilities/packages.dart';
import '../../domain/blocs/app/camera_cubit.dart';
import '../../domain/blocs/minimal/bool_cubit.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({
    super.key,
    required this.eventId,
  });

  final String eventId;

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  bool isCameraChanged = false;

  bool isFlashOn = false;

  bool isHd = false;

  bool isZoom = false;

  double zoom = 0;

  bool isFrontCamera = false;

  List<String> paths = [];

  @override
  void initState() {
    context
      ..read<EventCubit>().joinEvent(eventId: widget.eventId)
      ..read<EventCubit>().getEventImages(eventId: widget.eventId);
    supabase
        .channel('public:Images')
        .onPostgresChanges(
            event: PostgresChangeEvent.insert,
            schema: 'public',
            table: 'Images',
            filter: PostgresChangeFilter(
              type: PostgresChangeFilterType.eq,
              column: 'eventId',
              value: widget.eventId,
            ),
            callback: (payload) {
              debugPrint('Change received: ${payload.toString()}');
              context
                  .read<EventCubit>()
                  .getEventImages(eventId: widget.eventId);
            })
        .subscribe();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return BlocConsumer<CameraCubit, CameraState>(
      listenWhen: (previous, current) => current.status == CameraStatus.loaded,
      buildWhen: (previous, current) => current.status == CameraStatus.loaded,
      listener: (context, state) {
        if (state.status == CameraStatus.initial ||
            state.status == CameraStatus.error ||
            (state.status == CameraStatus.loaded && state.controller == null)) {
          context.read<CameraCubit>().initialize();
        }
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
                  onTap: () {
                    // show circle on clicked place
                    context.read<CameraCubit>().captureImage();
                  },
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
                        CaptureImage(widget: widget, isHd: isHd, paths: paths),
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
                                      ..getEventById(id: widget.eventId),
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
            bottom: height * 0.065,
            right: width * 0.25,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () async {
                  context.read<BoolCubit>().changeValue(value: isCameraChanged);
                  context.read<CameraCubit>().toggleCamera(
                        isCameraChanged: isCameraChanged,
                      );
                  await Posthog().capture(
                    eventName: 'Camera Switched',
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
                onTap: () async{
                  context.read<PageCubit>().changePage(page: zoom.toInt());
                  await Posthog().capture(
                    eventName: 'Camera Switched',
                  );
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
                  onTap: () async{
                    context.read<BoolCubit>().changeValue(value: isFlashOn);
                    context.read<CameraCubit>().toggleFlash(
                          isFlashOn: isFlashOn,
                        );
                        await Posthog().capture(
                    eventName: 'Camera Switched',
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
                          eventId: widget.eventId,
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
                            subject:
                                "${AppConstants.APP_URL}/camera/${widget.eventId}",
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
                        return BlocBuilder<UserCubit, UserState>(
                          builder: (context, state) {
                            return GestureDetector(
                              onTap: state.isPro
                                  ? () => context
                                      .read<BoolCubit>()
                                      .changeValue(value: isHd)
                                  : () => showModalBottomSheet(
                                      clipBehavior: Clip.antiAlias,
                                      backgroundColor: const Color(0xff1E1E1E),
                                      isScrollControlled: true,
                                      barrierColor:
                                          Colors.black.withOpacity(0.6),
                                      elevation: 5,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10))),
                                      context: context,
                                      builder: (context) {
                                        return const SubscriptionContainer();
                                      }),
                              child: Tooltip(
                                decoration: BoxDecoration(
                                    color: Colors.grey[100]!.withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(5)),
                                message: state.isPro
                                    ? "Change the image quality"
                                    : "Upgrade to pro to change image quality",
                                textStyle: GoogleFonts.quicksand(
                                    fontSize: 1.5 * SizeConfig.textMultiplier,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[700]),
                                child: Stack(
                                  fit: StackFit.loose,
                                  children: [
                                    Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 12),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: isHd
                                                ? white
                                                : Colors.black.withOpacity(0.4),
                                            border: Border.all(
                                                width: 0.3,
                                                color: Colors.grey[500]!)),
                                        child: Text(
                                          "HD",
                                          style: GoogleFonts.quicksand(
                                              fontWeight: FontWeight.bold,
                                              color: isHd
                                                  ? Colors.black
                                                  : Colors.grey[100],
                                              fontSize: 1.8 *
                                                  SizeConfig.textMultiplier),
                                        )),
                                    state.isPro
                                        ? const SizedBox.shrink()
                                        : Positioned.fill(
                                            child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: const Color.fromARGB(
                                                        255, 40, 39, 39)
                                                    .withOpacity(0.9),
                                                border: Border.all(
                                                    width: 0.3,
                                                    color: Colors.grey[500]!)),
                                            child: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: SvgPicture.asset(
                                                AppImages.lock,
                                                height: 1 *
                                                    SizeConfig.heightMultiplier,
                                                width: 1 *
                                                    SizeConfig.heightMultiplier,
                                                color: Colors.orange,
                                              ),
                                            ),
                                          )),
                                  ],
                                ),
                              ),
                            );
                          },
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

class CaptureImage extends StatelessWidget {
  const CaptureImage({
    super.key,
    required this.widget,
    required this.isHd,
    required this.paths,
  });

  final CameraPage widget;
  final bool isHd;
  final List<String> paths;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    return BlocConsumer<CameraCubit, CameraState>(
      listener: (context, state) {
        if (state.status == CameraStatus.captured) {
          context.read<CameraCubit>().uploadImage(
              path: state.path, eventId: widget.eventId, isHd: isHd);
          paths.add(state.path);
        }
      },
      builder: (context, state) {
        return Positioned.fill(
          bottom: height * 0.04,
          child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(left: 2 * SizeConfig.widthMultiplier),
                    child: BlocBuilder<EventCubit, EventState>(
                      buildWhen: (previous, current) =>
                          previous.images != current.images,
                      builder: (context, state) {
                        return SizedBox(
                          height: 6.5 * SizeConfig.heightMultiplier,
                          child: ListView.separated(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () => context.push('/preview',
                                      extra: {"url": state.images[index].url}),
                                  child: Stack(
                                    fit: StackFit.loose,
                                    children: [
                                      ImageContainer(
                                        imageUrl: state.images[index].url,
                                        borderRadius: BorderRadius.circular(0),
                                        fit: BoxFit.cover,
                                        height:
                                            6.5 * SizeConfig.heightMultiplier,
                                        width:
                                            6.5 * SizeConfig.heightMultiplier,
                                      ),
                                      state.images[index].hd
                                          ? Positioned.fill(
                                              bottom: 0.4 *
                                                  SizeConfig.heightMultiplier,
                                              right: 0.4 *
                                                  SizeConfig.heightMultiplier,
                                              child: Align(
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                            vertical: 3,
                                                            horizontal: 5),
                                                    decoration: BoxDecoration(
                                                        color: Colors.black
                                                            .withOpacity(0.6),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                5),
                                                        border: Border.all(
                                                            width: 0.3,
                                                            color: Colors
                                                                .grey[500]!)),
                                                    child: Text("HD",
                                                        style: GoogleFonts.robotoCondensed(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 9,
                                                            color:
                                                                Colors.white))),
                                              ))
                                          : const SizedBox.shrink()
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  Gap(0.7 * SizeConfig.widthMultiplier),
                              itemCount: state.images.length),
                        );
                      },
                    ),
                  ),
                  Gap(2 * SizeConfig.heightMultiplier),
                  GestureDetector(
                    onTap: () {
                      context.read<CameraCubit>().captureImage();
                    },
                    child: BlocBuilder<UserCubit, UserState>(
                      builder: (context, state) {
                        return Container(
                          padding: const EdgeInsets.all(2.5),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.fromBorderSide(BorderSide(
                                  color: state.isPro
                                      ? Colors.deepOrange
                                      : const Color(
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
                        );
                      },
                    ),
                  ),
                ],
              )),
        );
      },
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
                data: eventId,
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
