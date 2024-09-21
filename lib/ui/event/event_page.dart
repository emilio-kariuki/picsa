import 'dart:async';

import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:picsa/domain/blocs/minimal/navigation_cubit.dart';
import 'package:picsa/domain/blocs/minimal/page_cubit.dart';
import 'package:picsa/ui/event/create_page.dart';
import 'package:picsa/ui/event/widgets/event_container_shimmer.dart';
import 'package:picsa/ui/event/widgets/qr_scanner.dart';
import 'package:picsa/utilities/packages.dart';

import 'widgets/event_container.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> with WidgetsBindingObserver {
  final controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );
  int page = 0;
  final _pageController = PageController(initialPage: 0);
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
    return BlocProvider(
      create: (context) => PageCubit(),
      child: Scaffold(
          body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _pageTitle(),
                  Gap(2 * SizeConfig.heightMultiplier),
                  _tabBar(context),
                  Divider(
                    height: 1,
                    thickness: 0.1,
                    color: Colors.grey[400],
                  ),
                  Gap(2 * SizeConfig.heightMultiplier),
                  BlocConsumer<PageCubit, PageState>(
                    listener: (context, state) {
                      if (state.status == PageStatus.changed) {
                        _pageController.animateToPage(state.page,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn);
                        page = state.page;
                      }
                    },
                    builder: (context, state) {
                      return SizedBox(
                        height: MediaQuery.sizeOf(context).height,
                        child: PageView.builder(
                          controller: _pageController,
                          pageSnapping: true,
                          onPageChanged: (index) {
                            context.read<PageCubit>().changePage(page: index);
                          },
                          itemCount: 2,
                          itemBuilder: (context, index) {
                            return index == 0
                                ? _hostedEvents()
                                : _guestEvents();
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
              
            ],
          ),
        ),
      )),
    );
  }

  Widget _pageTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Events',
            style: GoogleFonts.inter(
              fontSize: 3 * SizeConfig.textMultiplier,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          _joinContainer(),
        ],
      ),
    );
  }

  Widget _tabBar(BuildContext context) {
    return BlocBuilder<PageCubit, PageState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _tabContainer(title: 'Hosted', index: 0, context: context),
              _tabContainer(title: 'Guest', index: 1, context: context),
            ],
          ),
        );
      },
    );
  }

  Widget _hostedEvents() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: BlocBuilder<EventCubit, EventState>(
        buildWhen: (current, previous) => current.events != previous.events,
        builder: (context, state) {
          switch (state.status) {
            case EventStatus.loading:
              return ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return const EventContainerShimmer();
                },
                separatorBuilder: (context, index) {
                  return Gap(1 * SizeConfig.heightMultiplier);
                },
                itemCount: 3,
              );
            case EventStatus.success:
              return state.events.isEmpty
                  ? SizedBox(
                      height: state.guestEvents.isEmpty
                          ? MediaQuery.sizeOf(context).height * 0.3
                          : MediaQuery.sizeOf(context).height * 0.3,
                      child: _emptyEvent(context),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final data = state.events[index];
                        return EventContainer(event: data);
                      },
                      separatorBuilder: (context, index) {
                        return Gap(1 * SizeConfig.heightMultiplier);
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
    );
  }

  Widget _tabContainer(
      {required String title,
      required int index,
      required BuildContext context}) {
    return GestureDetector(
      onTap: () {
        _pageController.animateToPage(index,
            duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
        context.read<PageCubit>().changePage(page: index);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 2 * SizeConfig.textMultiplier,
                fontWeight: FontWeight.w600,
                color: index == page ? green : Colors.grey[400],
              ),
            ),
            Gap(1 * SizeConfig.heightMultiplier),
            Container(
              height: 0.5 * SizeConfig.heightMultiplier,
              width: MediaQuery.sizeOf(context).width * 0.3,
              decoration: BoxDecoration(
                color: index == page ? green : Colors.grey[400],
                borderRadius: BorderRadius.circular(10),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _guestEvents() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: BlocBuilder<EventCubit, EventState>(
        buildWhen: (current, previous) =>
            current.guestEvents != previous.guestEvents,
        builder: (context, state) {
          switch (state.status) {
            case EventStatus.loading:
              return ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return const EventContainerShimmer();
                },
                separatorBuilder: (context, index) {
                  return Gap(1 * SizeConfig.heightMultiplier);
                },
                itemCount: 3,
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
                  return Gap(1 * SizeConfig.heightMultiplier);
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
    );
  }

  Widget _emptyEvent(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          context.read<NavigationCubit>().changePage(page: 0);
          focusNode.requestFocus();
        },
        child: Container(
          height: 25 * SizeConfig.heightMultiplier,
          width: MediaQuery.sizeOf(context).width,
          padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 25),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      AppImages.add,
                      height: 2.5 * SizeConfig.heightMultiplier,
                      width: 2.5 * SizeConfig.heightMultiplier,
                      color: Colors.grey[400],
                    ),
                    Gap(0.2 * SizeConfig.widthMultiplier),
                    Text(
                      'Add Event',
                      style: GoogleFonts.notoSans(
                        fontSize: 2.2 * SizeConfig.textMultiplier,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
                Gap(1 * SizeConfig.heightMultiplier),
                Text(
                  'You have not created any events yet. Create an event to get started.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.notoSans(
                    fontSize: 2 * SizeConfig.textMultiplier,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _joinContainer() {
    return GestureDetector(
      onTap: () => showModalBottomSheet(
          clipBehavior: Clip.antiAlias,
          isScrollControlled: true,
          backgroundColor: const Color(0xff1E1E1E),
          barrierColor: Colors.black.withOpacity(0.6),
          elevation: 5,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15))),
          context: context,
          builder: (context) {
            return const ScanQr();
          }),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
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
