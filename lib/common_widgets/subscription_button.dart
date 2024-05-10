
import 'package:picsa/domain/blocs/app/user_cubit.dart';
import 'package:picsa/utilities/packages.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

class NewSubscriptionButton extends StatelessWidget {
  const NewSubscriptionButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        return state.isPro
            ? const SizedBox.shrink()
            : GestureDetector(
                onTap: () async {
                  await RevenueCatUI.presentPaywall(displayCloseButton: true);
                },
                child: Container(
                  // margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.symmetric(
                      vertical: 15, horizontal: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xff000000).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.diamond_outlined,
                                size: 2.4 *
                                    SizeConfig
                                        .heightMultiplier,
                                color: Colors.orange,
                              ),
                              Gap(0.8 *
                                  SizeConfig
                                      .widthMultiplier),
                              Text(
                                "Subscribe to Picsa Pro",
                                style: GoogleFonts.inter(
                                    fontSize: 2.2 *
                                        SizeConfig
                                            .textMultiplier,
                                    fontWeight:
                                        FontWeight.w600,
                                    color: Colors.white54),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
      },
    );
  }
}
