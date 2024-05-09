
import 'package:picsa/domain/blocs/app/app_cubit.dart';
import 'package:picsa/utilities/packages.dart';

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