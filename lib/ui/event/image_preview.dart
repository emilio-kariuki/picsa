import 'package:picsa/common_widgets/image_container.dart';
import 'package:picsa/domain/blocs/app/app_cubit.dart';
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
                            return IconContainer(
                              icon: Icons.ios_share_rounded,
                              function: () =>
                                  context.read<AppCubit>().shareImage(
                                        url: url,
                                      ),
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
