import 'package:picsa/domain/blocs/app/subscription_cubit.dart';
import 'package:picsa/domain/blocs/app/user_cubit.dart';
import 'package:picsa/utilities/packages.dart';

class SubscriptionContainer extends StatelessWidget {
  const SubscriptionContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xff1E1E1E),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
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
                      index: index,
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
    required this.index,
  });

  final String title;
  final String price;
  final String description;
  final Function() function;
  final int index;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            decoration: BoxDecoration(
                color: const Color(0xff000000).withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
                border: index == 0
                    ? Border.all(
                        width: 2,
                        color: Colors.orange,
                      )
                    : Border.all(
                        color: const Color(0xff000000).withOpacity(0.3),
                      )),
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
          index == 0
              ? Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                    decoration: const BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(3)
                        )),
                    child: Center(
                      child: Text(
                        "Best Value",
                        style: GoogleFonts.inter(
                          fontSize: 1.4 * SizeConfig.textMultiplier,
                          fontWeight: FontWeight.w600,
                          color: Colors.black
                        ),
                      ),
                    ),
                  ))
              : const SizedBox.shrink()
        ],
      ),
    );
  }
}
