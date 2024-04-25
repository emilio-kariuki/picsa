import 'package:picsa/common_widgets/image_container.dart';
import 'package:picsa/domain/blocs/app/user_cubit.dart';
import 'package:picsa/utilities/packages.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SafeArea(
          child: Column(
            children: [
              BlocBuilder<UserCubit, UserState>(
                builder: (context, state) {
                  switch (state.status) {
                    case UserStatus.success:
                      return Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: const Color(0xff1C1C1C),
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ImageContainer(
                              imageUrl:
                                  state.user?.url ?? AppImages.defaultImage,
                              isCirlce: true,
                              height: 10 * SizeConfig.heightMultiplier,
                              width: 10 * SizeConfig.heightMultiplier,
                              borderRadius: BorderRadius.zero,
                            ),
                            Gap(2 * SizeConfig.widthMultiplier),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  state.user?.name ?? "",
                                  style: GoogleFonts.notoSans(
                                    fontSize: 2.2 * SizeConfig.textMultiplier,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Gap(0.3 * SizeConfig.heightMultiplier),
                                Text(
                                  state.user?.email ?? "",
                                  style: GoogleFonts.notoSans(
                                    fontSize: 2 * SizeConfig.textMultiplier,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    default:
                      return Container(
                        child: Text("no user"),
                      );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
