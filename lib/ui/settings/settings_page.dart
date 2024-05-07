import 'package:picsa/common_widgets/image_container.dart';
import 'package:picsa/common_widgets/subscription_button.dart';
import 'package:picsa/domain/blocs/app/app_cubit.dart';
import 'package:picsa/domain/blocs/app/auth_cubit.dart';
import 'package:picsa/domain/blocs/app/subscription_cubit.dart';
import 'package:picsa/domain/blocs/app/user_cubit.dart';
import 'package:picsa/utilities/packages.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<UserCubit>().getUser();
            return Future.value();
          },
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
                        Gap(1 * SizeConfig.heightMultiplier),
                        const NewSubscriptionButton(),
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
                        BlocProvider(
                          create: (context) => AppCubit(),
                          child: Builder(builder: (context) {
                            return BlocConsumer<AppCubit, AppState>(
                              listener: (context, state) {
                                if (state.status == AppStatus.error) {
                                  context.showErrorToast(
                                      title: "Error",
                                      message: state.message,
                                      context: context);
                                }
                              },
                              builder: (context, state) {
                                return SettingButton(
                                  icon: AppImages.policy,
                                  title: "Privacy Policy",
                                  function: () => context
                                      .read<AppCubit>()
                                      .launchBrowser(
                                          url: AppConstants.APP_PRIVACY),
                                );
                              },
                            );
                          }),
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
                          function: () async {},
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
    return BlocConsumer<UserCubit, UserState>(
      listener: (context, state) {
        if (state.user == null) {
          context.read<UserCubit>().getUser();
        }
      },
      builder: (context, state) {
        switch (state.status) {
          case UserStatus.success:
            return Container(
              width: MediaQuery.sizeOf(context).width,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: const Color(0xff000000),
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
                  SizedBox(
                    width: 28 * SizeConfig.widthMultiplier,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          state.user?.name ?? "",
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.notoSans(
                            fontSize: 2.2 * SizeConfig.textMultiplier,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Gap(0.3 * SizeConfig.heightMultiplier),
                        Text(
                          state.user?.email ?? "",
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.notoSans(
                            fontSize: 2 * SizeConfig.textMultiplier,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Gap(0.3 * SizeConfig.heightMultiplier),
                        BlocBuilder<UserCubit, UserState>(
                          builder: (context, state) {
                            return GestureDetector(
                              onTap: state.isPro
                                  ? () {}
                                  : () => showModalBottomSheet(
                                      clipBehavior: Clip.antiAlias,
                                      backgroundColor: const Color(0xff1E1E1E),
                                      isScrollControlled: true,
                                      barrierColor:
                                          Colors.black.withOpacity(0.6),
                                      elevation: 5,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(30),
                                              topRight: Radius.circular(30))),
                                      context: context,
                                      builder: (context) {
                                        return const SubscriptionContainer();
                                      }),
                              child: Row(
                                children: [
                                  state.isPro
                                      ? Icon(Icons.diamond_outlined,
                                          size: 2 * SizeConfig.heightMultiplier,
                                          color: Colors.orange)
                                      : const SizedBox.shrink(),
                                  Gap(0.5 * SizeConfig.widthMultiplier),
                                  Text(
                                    state.isPro ? "Premium Plan" : "Free Plan",
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.notoSans(
                                        fontSize: 2 * SizeConfig.textMultiplier,
                                        fontWeight: FontWeight.w600,
                                        color: state.isPro
                                            ? Colors.orange
                                            : const Color(0xff70B93E)),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: const Color(0xff1C1C1C),
          borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
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
                color: Color.fromARGB(255, 50, 50, 50),
              ),
            ),
          ),
          Gap(2 * SizeConfig.widthMultiplier),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey[800]!,
                highlightColor: Colors.grey[700]!,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  height: 2 * SizeConfig.heightMultiplier,
                  width: 16 * SizeConfig.widthMultiplier,
                  decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              Gap(0.5 * SizeConfig.heightMultiplier),
              Shimmer.fromColors(
                baseColor: Colors.grey[800]!,
                highlightColor: Colors.grey[700]!,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  height: 2 * SizeConfig.heightMultiplier,
                  width: 30 * SizeConfig.widthMultiplier,
                  decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class SubscriptionContainer extends StatelessWidget {
  const SubscriptionContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xff1E1E1E),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.diamond_outlined,
                size: 2.4 * SizeConfig.heightMultiplier,
                color: Colors.orange,
              ),
              Gap(0.8 * SizeConfig.widthMultiplier),
              Text(
                "Subscription",
                style: GoogleFonts.inter(
                  fontSize: 2.4 * SizeConfig.textMultiplier,
                  fontWeight: FontWeight.w700,
                  color: const Color.fromARGB(255, 77, 77, 77),
                ),
              ),
            ],
          ),
          Gap(1 * SizeConfig.heightMultiplier),
          Text(
            "Get unlimited access to all features",
            style: GoogleFonts.inter(
              fontSize: 2 * SizeConfig.textMultiplier,
              fontWeight: FontWeight.w600,
              color: const Color.fromARGB(255, 77, 77, 77),
            ),
          ),
          Gap(1 * SizeConfig.heightMultiplier),
          BlocConsumer<SubscriptionCubit, SubscriptionState>(
            listener: (context, state) {
              if (state.status == SubscriptionStatus.error) {
                context.showErrorSnackBar(
                  message: state.message,
                );
              }
              if (state.status == SubscriptionStatus.subscribed) {
                context.read<UserCubit>().getUser();
              }
            },
            builder: (context, state) {
              return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return SubscriptionButton(
                      title: state.packages[index].storeProduct.title,
                      price: state.packages[index].storeProduct.priceString,
                      description:
                          state.packages[index].storeProduct.description,
                      function: () => context
                        ..pop()
                        ..read<SubscriptionCubit>()
                            .purchasePackage(package: state.packages[index]),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      Gap(1 * SizeConfig.heightMultiplier),
                  itemCount: state.packages.length);
            },
          )
        ],
      ),
    );
  }
}

class SubscriptionButton extends StatelessWidget {
  const SubscriptionButton({
    super.key,
    required this.title,
    required this.price,
    required this.description,
    required this.function,
  });

  final String title;
  final String price;
  final String description;
  final Function() function;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        decoration: BoxDecoration(
          color: const Color(0xff000000),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                      fontSize: 2.2 * SizeConfig.textMultiplier,
                      fontWeight: FontWeight.w600,
                      color: Colors.white54),
                ),
                Gap(3 * SizeConfig.widthMultiplier),
                Text(
                  price,
                  style: GoogleFonts.inter(
                      fontSize: 2.2 * SizeConfig.textMultiplier,
                      fontWeight: FontWeight.w600,
                      color: Colors.white54),
                ),
                const Spacer(),
              ],
            ),
            Gap(1 * SizeConfig.heightMultiplier),
            const Divider(
              color: Color.fromARGB(255, 77, 77, 77),
              thickness: 0.2,
              height: 10,
            ),
            Text(
              description,
              textAlign: TextAlign.start,
              style: GoogleFonts.inter(
                  fontSize: 1.8 * SizeConfig.textMultiplier,
                  fontWeight: FontWeight.w500,
                  color: Colors.white38),
            ),
          ],
        ),
      ),
    );
  }
}
