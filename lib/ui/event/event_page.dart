import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:picsa/domain/blocs/app_functionality/event/event/event_cubit.dart';
import 'package:picsa/domain/models/events_model.dart';
import 'package:picsa/utilities/app_images.dart';
import 'package:picsa/utilities/common_widgets/image_container.dart';
import 'package:picsa/utilities/common_widgets/loading_circle.dart';
import 'package:intl/intl.dart';

class EventPage extends StatelessWidget {
  const EventPage({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<EventCubit>().getEvents();
          },
          child: ListView(
            
            children: [
              Text(
                'Events',
                style: GoogleFonts.inter(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[400],
                ),
              ),
              Gap(height * 0.03),
              Text(
                'Hosting',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[400],
                ),
              ),
              Gap(height * 0.02),
              
              BlocBuilder<EventCubit, EventState>(
                builder: (context, state) {
                  if (state is EventLoading) {
                    return const Center(
                      child: LoadingCircle(),
                    );
                  } else if (state is EventSuccess) {
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final data = state.events[index];
                        return SecondContainer(event: data);
                      },
                      separatorBuilder: (context, index) {
                        return Gap(height * 0.02);
                      },
                      itemCount: state.events.length,
                    );
                  } else {
                    return const Center(
                      child: Text('No Events'),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    ));
  }
}

class EventContainer extends StatelessWidget {
  EventContainer({
    super.key,
    required this.width,
    required this.height,
    required this.event,
  });

  final double width;
  final double height;
  final EventModel event;

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        DateFormat.yMMMd().format(DateTime.parse(event.createdAt));
    return Row(
      children: [
       
        ImageContainer(
          imageUrl: AppImages.defaultImage,
          borderRadius: BorderRadius.circular(15),
          height: height * 0.12,
          width: height * 0.085,
        ),
        Gap(width * 0.04),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                event.name,
                style: GoogleFonts.inter(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Gap(height * 0.003),
              Text(
                formattedDate,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[400],
                ),
              ),
              Gap(height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                    icon: Icons.edit_outlined,
                    function: () {},
                  ),
                  const Spacer(),
                  IconContainer(
                    icon: Icons.share_outlined,
                    function: () {},
                  ),
                  const Spacer(),
                  IconContainer(
                    icon: Icons.qr_code,
                    function: () {},
                  ),
                ],
              ),
            ],
          ),
        )
      ],
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
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.grey[800],
        ),
        child: Icon(icon, size: 18, color: Colors.grey[300]),
      ),
    );
  }
}

class SecondContainer extends StatelessWidget {
  const SecondContainer({super.key, required this.event});

  final EventModel event;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    String formattedDate =
        DateFormat.yMMMd().format(DateTime.parse(event.createdAt));
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.transparent,
          border: Border.all(
            color: Colors.grey[500]!,
            width: 0.3,
          )),
      child: Column(children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Colors.grey[800]),
              child: const Center(
                  child: Icon(
                Icons.favorite,
                size: 20,
                color: Colors.white,
              )),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 17),
              decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: [
                  SvgPicture.asset(
                    AppImages.pin,
                    height: height * 0.02,
                    width: height * 0.02,
                  ),
                  Gap(height * 0.01),
                  Text(
                    "Hosting",
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.more_vert,
              size: 25,
              color: Colors.white,
            )
          ],
        ),
        Gap(height * 0.025),
        Row(
          children: [
             const Gap(15),
            ImageContainer(
              imageUrl: AppImages.defaultImage,
              borderRadius: BorderRadius.circular(15),
              height: height * 0.09,
              width: height * 0.085,
            ),
            Gap(width * 0.04),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formattedDate,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Gap(height * 0.002),
                Text(
                  event.name,
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    color: Colors.grey[300],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
        Gap(height * 0.02),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SvgContainer(
              height: height,
              icon: AppImages.camera,
              function: () {},
            ),
            SvgContainer(
              height: height,
              icon: AppImages.edit,
              function: () {},
            ),
            SvgContainer(
              height: height,
              icon: AppImages.share,
              function: () {},
            ),
            SvgContainer(
              height: height,
              icon: AppImages.qr,
              function: () {},
            )
          ],
        )
      ]),
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
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.grey[800],
        ),
        child: SvgPicture.asset(
          icon,
          height: height * 0.03,
          width: height * 0.03,
        ),
      ),
    );
  }
}
