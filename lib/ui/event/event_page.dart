import 'package:picsa/common_widgets/image_container.dart';
import 'package:picsa/common_widgets/loading_circle.dart';
import 'package:picsa/domain/models/models.dart';
import 'package:picsa/utilities/packages.dart';

class EventPage extends StatelessWidget {
  const EventPage({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: RefreshIndicator(
            onRefresh: () async {
              context.read<EventCubit>().getEvents();
            },
            child: ListView(
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
                BlocProvider(
                  create: (context) => EventCubit()..getEvents(),
                  child: Builder(builder: (context) {
                    return BlocBuilder<EventCubit, EventState>(
                      builder: (context, state) {
                        switch (state.status) {
                          case EventStatus.loading:
                            return const Center(
                              child: LoadingCircle(),
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
                    );
                  }),
                )
              ],
            ),
          ),
        ),
        Positioned.fill(
          top: MediaQuery.of(context).padding.top,
          right: 10,
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 8),
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
            ))
      ],
    ));
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
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 28, 28, 28),
          borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            event.name,
            textAlign: TextAlign.center,
            style: GoogleFonts.notoSans(
                fontSize: 3 * SizeConfig.textMultiplier,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                height: 1.2),
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
                  context.push('/camera-page', extra: {
                    'eventId': event.id,
                  });
                },
              ),
              const Spacer(),
              IconContainer(
                icon: Icons.cloud_upload_outlined,
                function: () {},
              ),
              const Spacer(),
              IconContainer(
                icon: Icons.ios_share_rounded,
                function: () {},
              ),
              const Spacer(),
              IconContainer(
                icon: Icons.qr_code,
                function: () {},
              ),
              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}

class IconContainer extends StatelessWidget {
  const IconContainer({
    super.key,
    required this.icon,
    required this.function,
  });

  final IconData icon;
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
        child: Icon(icon,
            size: 20, color: const Color.fromARGB(255, 103, 103, 103)),
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
        padding: EdgeInsets.all(height * 0.015),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey[800],
        ),
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
    return Container(
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
