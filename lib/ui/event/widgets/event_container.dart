
import 'package:picsa/domain/blocs/app/app_cubit.dart';
import 'package:picsa/domain/models/models.dart';
import 'package:picsa/ui/event/widgets/event_qr_code.dart';
import 'package:picsa/ui/event/widgets/icon_container.dart';
import 'package:picsa/utilities/packages.dart';

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
        '/events/images/${event.id}',
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        decoration: BoxDecoration(
            color: const Color(0xff000000).withOpacity(0.3),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Text(
                event.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: GoogleFonts.inter(
                    fontSize: 2.5 * SizeConfig.textMultiplier,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[400],
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
            Gap(1.5 * SizeConfig.heightMultiplier),
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
