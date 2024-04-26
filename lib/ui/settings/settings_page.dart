import 'package:picsa/common_widgets/image_container.dart';
import 'package:picsa/domain/blocs/app/auth_cubit.dart';
import 'package:picsa/domain/blocs/app/user_cubit.dart';
import 'package:picsa/utilities/packages.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: BlocProvider(
            create: (context) => AuthCubit(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<AuthCubit, AuthenticationState>(
                  builder: (context, state) {
                    if (state.status == AuthStatus.loading) {
                      return const LinearProgressIndicator(
                        color: Color(
                          0xff70B93E,
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ProfileContainer(),
                      Gap(3 * SizeConfig.heightMultiplier),
                      Text(
                        'Legal',
                        style: GoogleFonts.inter(
                          fontSize: 2.4 * SizeConfig.textMultiplier,
                          fontWeight: FontWeight.w700,
                          color: const Color.fromARGB(255, 77, 77, 77),
                        ),
                      ),
                      Gap(1 * SizeConfig.heightMultiplier),
                      SettingButton(
                        icon: AppImages.policy,
                        title: "Privacy Policy",
                        function: () {},
                      ),
                      SettingButton(
                        icon: AppImages.logout,
                        title: "Log Out",
                        function: () {},
                      ),
                      const SettingsDivider(),
                      Text(
                        'Help',
                        style: GoogleFonts.inter(
                          fontSize: 2.4 * SizeConfig.textMultiplier,
                          fontWeight: FontWeight.w700,
                          color: const Color.fromARGB(255, 77, 77, 77),
                        ),
                      ),
                      Gap(1 * SizeConfig.heightMultiplier),
                      SettingButton(
                        icon: AppImages.policy,
                        title: "Email Support",
                        function: () {},
                      ),
                      SettingButton(
                        icon: AppImages.logout,
                        title: "Phone Support",
                        function: () {},
                      ),
                      const SettingsDivider(),
                      Text(
                        'Follow us',
                        style: GoogleFonts.inter(
                          fontSize: 2.4 * SizeConfig.textMultiplier,
                          fontWeight: FontWeight.w700,
                          color: const Color.fromARGB(255, 77, 77, 77),
                        ),
                      ),
                      Gap(1 * SizeConfig.heightMultiplier),
                      SettingButton(
                        icon: AppImages.instagram,
                        title: "Instagram",
                        function: () {},
                      ),
                      SettingButton(
                        icon: AppImages.linkedin,
                        title: "Linkedin ",
                        function: () {},
                      ),
                      const SettingsDivider(),
                      Text(
                        'Account',
                        style: GoogleFonts.inter(
                          fontSize: 2.4 * SizeConfig.textMultiplier,
                          fontWeight: FontWeight.w700,
                          color: const Color.fromARGB(255, 77, 77, 77),
                        ),
                      ),
                      Gap(1 * SizeConfig.heightMultiplier),
                      SettingButton(
                        icon: AppImages.delete,
                        title: "Delete Account",
                        function: () {},
                      ),
                      BlocConsumer<AuthCubit, AuthenticationState>(
                        listener: (context, state) {
                          if (state.status == AuthStatus.error) {
                            context.showErrorSnackBar(
                              message: state.message,
                            );
                          }

                          if (state.status == AuthStatus.success) {
                            context.goNamed(Routes.welcome);
                          }
                        },
                        builder: (context, state) {
                          return Builder(builder: (context) {
                            return SettingButton(
                              icon: AppImages.logout,
                              title: "Log Out",
                              function: () =>
                                  context.read<AuthCubit>().signOut(),
                            );
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SettingsDivider extends StatelessWidget {
  const SettingsDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: const Color.fromARGB(255, 77, 77, 77),
      thickness: 0.2,
      height: 4 * SizeConfig.heightMultiplier,
    );
  }
}

class SettingButton extends StatelessWidget {
  const SettingButton({
    super.key,
    required this.icon,
    required this.title,
    required this.function,
  });

  final String icon;
  final String title;
  final Function() function;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon,
              color: const Color.fromARGB(255, 12, 12, 12),
              height: 3.5 * SizeConfig.heightMultiplier,
              width: 3.5 * SizeConfig.heightMultiplier,
            ),
            Gap(3 * SizeConfig.widthMultiplier),
            Text(
              title,
              style: GoogleFonts.inter(
                  fontSize: 2.2 * SizeConfig.textMultiplier,
                  fontWeight: FontWeight.w600,
                  color: Colors.white54),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class ProfileContainer extends StatelessWidget {
  const ProfileContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
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
                    imageUrl: state.user?.url ?? AppImages.defaultImage,
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
            return const UserShimmer();
        }
      },
    );
  }
}

class UserShimmer extends StatelessWidget {
  const UserShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xff1C1C1C),
      highlightColor: const Color(0xff1C1C1C),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: const Color(0xff1C1C1C),
            borderRadius: BorderRadius.circular(20)),
        child: Row(
          children: [
            Gap(2 * SizeConfig.widthMultiplier),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  baseColor: const Color.fromARGB(255, 50, 50, 50),
                  highlightColor: const Color.fromARGB(255, 50, 50, 50),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 10 * SizeConfig.heightMultiplier,
                    width: 10 * SizeConfig.heightMultiplier,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color.fromARGB(255, 50, 50, 50),
                    ),
                  ),
                ),
                Shimmer.fromColors(
                  baseColor: const Color(0xff1C1C1C),
                  highlightColor: const Color.fromARGB(255, 50, 50, 50),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 2 * SizeConfig.heightMultiplier,
                    width: 12 * SizeConfig.widthMultiplier,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 44, 44, 44),
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
                Gap(0.3 * SizeConfig.heightMultiplier),
                Shimmer.fromColors(
                  baseColor: const Color.fromARGB(255, 50, 50, 50),
                  highlightColor: const Color.fromARGB(255, 50, 50, 50),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 2 * SizeConfig.heightMultiplier,
                    width: 18 * SizeConfig.widthMultiplier,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 44, 44, 44),
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
