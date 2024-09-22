import 'package:picsa/common_widgets/image_container.dart';
import 'package:picsa/common_widgets/subscription_sheet.dart';
import 'package:picsa/domain/blocs/app/app_cubit.dart';
import 'package:picsa/domain/blocs/app/user_cubit.dart';
import 'package:picsa/ui/event/widgets/icon_container.dart';
import 'package:picsa/utilities/packages.dart';

class ImagePreview extends StatelessWidget {
  const ImagePreview({super.key, required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            child: ImageContainer(
              imageUrl: url,
              borderRadius: BorderRadius.zero,
              height: MediaQuery.sizeOf(context).height,
              width: MediaQuery.sizeOf(context).width,
            ),
          ),
          Positioned.fill(
              bottom: 3 * SizeConfig.heightMultiplier,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: BlocProvider(
                  create: (context) => AppCubit(),
                  child: Builder(builder: (context) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
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
                                return IconContainer(
                                  isLoading: state.status == AppStatus.loading,
                                  icon: Icons.file_download_outlined,
                                  function: () => context
                                      .read<AppCubit>()
                                      .downloadImage(
                                          context: context, url: url),
                                );
                              },
                            );
                          }),
                        ),
                        BlocBuilder<AppCubit, AppState>(
                          builder: (context, state) {
                            return IconContainer(
                              icon: Icons.share,
                              function: () => context.read<AppCubit>().shareContent(
                                  text:
                                      "Share the image url with family and friends",
                                  subject: url),
                            );
                          },
                        ),
                        BlocBuilder<AppCubit, AppState>(
                          builder: (context, state) {
                            return BlocBuilder<UserCubit, UserState>(
                              builder: (context, state) {
                                return GestureDetector(
                                  // onTap: state.isPro?() => context.push('/editor',
                                  //           extra: {"url": url}):() => showModalBottomSheet(
                                  //     clipBehavior: Clip.antiAlias,
                                  //     backgroundColor: const Color(0xff1E1E1E),
                                  //     isScrollControlled: true,
                                  //     barrierColor:
                                  //         Colors.black.withOpacity(0.6),
                                  //     elevation: 5,
                                  //     shape: const RoundedRectangleBorder(
                                  //         borderRadius: BorderRadius.only(
                                  //             topLeft: Radius.circular(10),
                                  //             topRight: Radius.circular(10))),
                                  //     context: context,
                                  //     builder: (context) {
                                  //       return const SubscriptionContainer();
                                  //     }) ,
                                  onTap: ()=> context.push('/editor',
                                            extra: {"url": url}),
                                  child: Tooltip(
                                     decoration: BoxDecoration(
                                    color: Colors.grey[100]!.withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(5)),
                                message: state.isPro
                                    ? "Edit the image"
                                    : "Upgrade to pro to edit the image",
                                textStyle: GoogleFonts.quicksand(
                                    fontSize: 1.5 * SizeConfig.textMultiplier,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[700]),
                                    child: Stack(
                                      fit: StackFit.loose,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16, horizontal: 16),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: const Color.fromARGB(
                                                  255, 35, 35, 35)),
                                          child: SvgPicture.asset(
                                            AppImages.edit,
                                            color: Color.fromARGB(255, 163, 163, 163),
                                            height:
                                                2 * SizeConfig.heightMultiplier,
                                            width:
                                                2 * SizeConfig.heightMultiplier,
                                          ),
                                        ),
                                        // state.isPro
                                        //     ? const SizedBox.shrink()
                                        //     : Positioned.fill(
                                        //         child: Container(
                                        //         decoration: BoxDecoration(
                                        //             borderRadius:
                                        //                 BorderRadius.circular(8),
                                        //             color:  Colors.black
                                        //                 .withOpacity(0.2),
                                        //             ),
                                        //         child: Padding(
                                        //           padding: const EdgeInsets.all(13),
                                        //           child: SvgPicture.asset(
                                        //             AppImages.lock,
                                        //             height: 1 *
                                        //                 SizeConfig.heightMultiplier,
                                        //             width: 1 *
                                        //                 SizeConfig.heightMultiplier,
                                        //             color: Colors.orange,
                                        //           ),
                                        //         ),
                                        //       )),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        IconContainer(
                          icon: Icons.close,
                          function: () => context.pop(),
                        ),
                      ],
                    );
                  }),
                ),
              ))
        ],
      ),
    );
  }
}
