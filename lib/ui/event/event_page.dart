import 'dart:async';

import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:picsa/common_widgets/loading_circle.dart';
import 'package:picsa/domain/blocs/app/app_cubit.dart';
import 'package:picsa/domain/models/models.dart';
import 'package:picsa/utilities/packages.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  final controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );
  @override
  void initState() {
    super.initState();
    controller.stop();
  }

  @override
  void dispose() {
    controller.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: RefreshIndicator(
                onRefresh: () async {
                  context.read<EventCubit>()
                    ..getEvents()
                    ..getGuestEvents();
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Gap(MediaQuery.of(context).padding.top),
                    Text(
                      'Events',
                      style: GoogleFonts.inter(
                        fontSize: 2.9 * SizeConfig.textMultiplier,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[400],
                      ),
                    ),
                    Gap(1 * SizeConfig.heightMultiplier),
                    Text(
                      'Hosting',
                      style: GoogleFonts.inter(
                        fontSize: 2 * SizeConfig.textMultiplier,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[400],
                      ),
                    ),
                    Gap(2 * SizeConfig.heightMultiplier),
                    BlocBuilder<EventCubit, EventState>(
                      buildWhen: (current, previous) =>
                          current.events != previous.events,
                      builder: (context, state) {
                        switch (state.status) {
                          case EventStatus.loading:
                            return ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return const EventContainerShimmer();
                              },
                              separatorBuilder: (context, index) {
                                return Gap(1.5 * SizeConfig.heightMultiplier);
                              },
                              itemCount: 5,
                            );
                          case EventStatus.success:
                            return ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final data = state.events[index];
                                return EventContainer(event: data);
                              },
                              separatorBuilder: (context, index) {
                                return Gap(1.5 * SizeConfig.heightMultiplier);
                              },
                              itemCount: state.events.length,
                            );
                          default:
                            return const Center(
                              child: Text('No Events'),
                            );
                        }
                      },
                    ),
                    Gap(2 * SizeConfig.heightMultiplier),
                    Text(
                      'Guest Events',
                      style: GoogleFonts.inter(
                        fontSize: 2 * SizeConfig.textMultiplier,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[400],
                      ),
                    ),
                    Gap(2 * SizeConfig.heightMultiplier),
                    BlocBuilder<EventCubit, EventState>(
                      buildWhen: (current, previous) =>
                          current.guestEvents != previous.guestEvents,
                      builder: (context, state) {
                        switch (state.status) {
                          case EventStatus.loading:
                            return ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return const EventContainerShimmer();
                              },
                              separatorBuilder: (context, index) {
                                return Gap(1.5 * SizeConfig.heightMultiplier);
                              },
                              itemCount: 5,
                            );
                          case EventStatus.success:
                            return ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final data = state.guestEvents[index];
                                return EventContainer(event: data);
                              },
                              separatorBuilder: (context, index) {
                                return Gap(1.5 * SizeConfig.heightMultiplier);
                              },
                              itemCount: state.guestEvents.length,
                            );
                          default:
                            return const Center(
                              child: Text('No Guest Events'),
                            );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            Positioned.fill(
                top: MediaQuery.of(context).padding.top-20,
                right: 10,
                child: Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
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
                          return const ScanQr();
                        }),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 8),
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 28, 28, 28),
                          borderRadius: BorderRadius.circular(
                            20,
                          )),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.qr_code_scanner_outlined,
                            size: 15,
                            color: Colors.white,
                          ),
                          Gap(0.8 * SizeConfig.widthMultiplier),
                          Text(
                            "Join",
                            style: GoogleFonts.rubikBubbles(
                                fontSize: 2 * SizeConfig.textMultiplier,
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  ),
                ))
          ],
        ),
      ),
    ));
  }
}

class ScanQr extends StatefulWidget {
  const ScanQr({super.key});

  @override
  State<ScanQr> createState() => _ScanQrState();
}

class _ScanQrState extends State<ScanQr> {
  final controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
          width: MediaQuery.sizeOf(context).width,
          padding: const EdgeInsets.all(15),
          color: const Color(0xff212121),
          child: Column(
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
              SizedBox(
                height: 30 * SizeConfig.heightMultiplier,
                width: 40 * SizeConfig.heightMultiplier,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: MobileScanner(
                    controller: MobileScannerController(
                      detectionSpeed: DetectionSpeed.noDuplicates,
                    ),
                    errorBuilder: (context, error, child) {
                      return Text(error.toString());
                    },
                    onDetect: (barcodes) {
                      debugPrint(barcodes.barcodes[0].rawValue);
                      context
                          .read<EventCubit>()
                          .joinEvent(eventId: barcodes.raw.toString());
                    },
                  ),
                ),
              ),
              Gap(2 * SizeConfig.heightMultiplier),
              BlocConsumer<EventCubit, EventState>(
                listener: (context, state) {
                  if (state.status == EventStatus.success) {
                    context.pop();
                  }

                  if (state.status == EventStatus.error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  return state.status == EventStatus.loading
                      ? Center(
                          child: LoadingCircle(
                            color: green,
                          ),
                        )
                      : const SizedBox.shrink();
                },
              )
            ],
          )),
    );
  }
}

class EventContainerShimmer extends StatelessWidget {
  const EventContainerShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 28, 28, 28),
          borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Shimmer.fromColors(
            baseColor: const Color.fromARGB(255, 35, 35, 35),
            highlightColor: const Color.fromARGB(255, 49, 49, 49),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              height: 2 * SizeConfig.heightMultiplier,
              width: 30 * SizeConfig.widthMultiplier,
              decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(20)),
            ),
          ),
          Gap(1 * SizeConfig.heightMultiplier),
          Shimmer.fromColors(
            baseColor: const Color.fromARGB(255, 35, 35, 35),
            highlightColor: const Color.fromARGB(255, 49, 49, 49),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              height: 2 * SizeConfig.heightMultiplier,
              width: 15 * SizeConfig.widthMultiplier,
              decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(20)),
            ),
          ),
          Gap(1 * SizeConfig.heightMultiplier),
          Shimmer.fromColors(
            baseColor: const Color.fromARGB(255, 35, 35, 35),
            highlightColor: const Color.fromARGB(255, 49, 49, 49),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              height: 2 * SizeConfig.heightMultiplier,
              width: 20 * SizeConfig.widthMultiplier,
              decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(20)),
            ),
          ),
          Gap(2 * SizeConfig.heightMultiplier),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Shimmer.fromColors(
                baseColor: const Color.fromARGB(255, 35, 35, 35),
                highlightColor: const Color.fromARGB(255, 49, 49, 49),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: const Color.fromARGB(255, 35, 35, 35)),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: SizedBox.shrink(),
                  ),
                ),
              ),
              const Spacer(),
              Shimmer.fromColors(
                baseColor: const Color.fromARGB(255, 35, 35, 35),
                highlightColor: const Color.fromARGB(255, 49, 49, 49),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: const Color.fromARGB(255, 35, 35, 35)),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: SizedBox.shrink(),
                  ),
                ),
              ),
              const Spacer(),
              Shimmer.fromColors(
                baseColor: const Color.fromARGB(255, 35, 35, 35),
                highlightColor: const Color.fromARGB(255, 49, 49, 49),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: const Color.fromARGB(255, 35, 35, 35)),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: SizedBox.shrink(),
                  ),
                ),
              ),
              const Spacer(),
              Shimmer.fromColors(
                baseColor: const Color.fromARGB(255, 35, 35, 35),
                highlightColor: const Color.fromARGB(255, 49, 49, 49),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: const Color.fromARGB(255, 35, 35, 35)),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: SizedBox.shrink(),
                  ),
                ),
              ),
              const Spacer()
            ],
          )
        ],
      ),
    );
  }
}

class EventContainer extends StatelessWidget {
  const EventContainer({
    super.key,
    required this.event,
  });

  final Event event;

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        DateFormat.yMMMd().format(DateTime.parse(event.createdAt));

    return GestureDetector(
      onTap: () => context.push(
        '/images/${event.id}',
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 15),
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 28, 28, 28),
            borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                event.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: GoogleFonts.inter(
                    fontSize: 2.5 * SizeConfig.textMultiplier,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    height: 1.2),
              ),
            ),
            Gap(1 * SizeConfig.heightMultiplier),
            Text(
              formattedDate,
              textAlign: TextAlign.center,
              style: GoogleFonts.notoSans(
                  fontSize: 1.8 * SizeConfig.textMultiplier,
                  fontWeight: FontWeight.w600,
                  color: const Color.fromARGB(255, 108, 108, 108),
                  height: 1.2),
            ),
            Gap(2 * SizeConfig.heightMultiplier),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                IconContainer(
                  icon: Icons.camera_alt_outlined,
                  function: () {
                    context.push(
                      '/camera/${event.id}',
                    );
                  },
                ),
                const Spacer(),
                IconContainer(
                  icon: Icons.cloud_upload_outlined,
                  function: () {},
                ),
                const Spacer(),
                BlocProvider(
                  create: (context) => AppCubit(),
                  child: Builder(builder: (context) {
                    return BlocBuilder<AppCubit, AppState>(
                      builder: (context, state) {
                        return IconContainer(
                          icon: Icons.ios_share_rounded,
                          function: () {
                            context.read<AppCubit>().shareContent(
                                  subject:
                                      "Share this event with friends and family",
                                  text:
                                      "${AppConstants.APP_URL}/event/${event.id}",
                                );
                          },
                        );
                      },
                    );
                  }),
                ),
                const Spacer(),
                IconContainer(
                  icon: Icons.qr_code,
                  function: () => showModalBottomSheet(
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
                        return EventQr(
                          eventId: event.id,
                        );
                      }),
                ),
                const Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class IconContainer extends StatelessWidget {
  const IconContainer(
      {super.key,
      required this.icon,
      required this.function,
      this.isLoading = false});

  final IconData icon;
  final Function() function;
  final bool? isLoading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color.fromARGB(255, 35, 35, 35)),
        child: isLoading ?? false
            ? LoadingCircle(
                color: Colors.grey[500],
                size: 20,
              )
            : Icon(icon,
                size: 16, color: const Color.fromARGB(255, 103, 103, 103)),
      ),
    );
  }
}

class SvgContainer extends StatelessWidget {
  const SvgContainer({
    super.key,
    required this.height,
    required this.icon,
    required this.function,
  });

  final double height;
  final String icon;
  final Function() function;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 22),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: const Color.fromARGB(255, 35, 35, 35)),
        child: SvgPicture.asset(
          icon,
          height: height * 0.02,
          width: height * 0.02,
        ),
      ),
    );
  }
}

class CustomAvatars extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.centerRight,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.red,
                child: Image.asset(
                  AppImages.welcome,
                  fit: BoxFit.cover,
                ), // Provide your custom image
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.red,
                child: Image.asset(
                  AppImages.welcome,
                  fit: BoxFit.cover,
                ), // Provide your custom image
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.red,
                child: Image.asset(
                  AppImages.welcome,
                  fit: BoxFit.cover,
                ), // Provide your custom image
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EventQr extends StatelessWidget {
  const EventQr({super.key, required this.eventId});
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
                        text: "${AppConstants.APP_URL}/event/$eventId",
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

class ScannerErrorWidget extends StatelessWidget {
  const ScannerErrorWidget({super.key, required this.error});

  final MobileScannerException error;

  @override
  Widget build(BuildContext context) {
    String errorMessage;

    switch (error.errorCode) {
      case MobileScannerErrorCode.controllerUninitialized:
        errorMessage = 'Controller not ready.';
      case MobileScannerErrorCode.permissionDenied:
        errorMessage = 'Permission denied';
      case MobileScannerErrorCode.unsupported:
        errorMessage = 'Scanning is unsupported on this device';
      default:
        errorMessage = 'Generic Error';
        break;
    }

    return ColoredBox(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Icon(Icons.error, color: Colors.white),
            ),
            Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              error.errorDetails?.message ?? '',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class ScannedBarcodeLabel extends StatelessWidget {
  const ScannedBarcodeLabel({
    super.key,
    required this.barcodes,
  });

  final Stream<BarcodeCapture> barcodes;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: barcodes,
      builder: (context, snapshot) {
        final scannedBarcodes = snapshot.data?.barcodes ?? [];

        if (scannedBarcodes.isEmpty) {
          return const Text(
            'Scan something!',
            overflow: TextOverflow.fade,
            style: TextStyle(color: Colors.white),
          );
        }

        return Text(
          scannedBarcodes.first.displayValue ?? 'No display value.',
          overflow: TextOverflow.fade,
          style: const TextStyle(color: Colors.white),
        );
      },
    );
  }
}
