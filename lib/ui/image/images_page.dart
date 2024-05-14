import 'package:picsa/common_widgets/image_container.dart';
import 'package:picsa/domain/blocs/app/app_cubit.dart';
import 'package:picsa/domain/blocs/minimal/page_cubit.dart';
import 'package:picsa/utilities/packages.dart';

class ImagesPage extends StatefulWidget {
  const ImagesPage({super.key, required this.eventId});

  final String eventId;

  @override
  State<ImagesPage> createState() => _ImagesPageState();
}

class _ImagesPageState extends State<ImagesPage> {
  @override
  void initState() {
    super.initState();
    context.read<EventCubit>()
      ..getEventImages(eventId: widget.eventId)
      ..getEventById(id: widget.eventId)
      ..getUsersJoined(eventId: widget.eventId)
      ..getImagesTaken(eventId: widget.eventId);
  }

  List<String> categories = ["All", "Yours"];

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: const Color(0xff0A0C0F),
      extendBody: true,
      body: SafeArea(
          bottom: false,
          // top: false,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  // height: height * 0.25,
                  width: width,
                  padding: EdgeInsets.all(2 * SizeConfig.heightMultiplier),
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(AppImages.imagesPage),
                      fit: BoxFit.cover,
                      opacity: 0.7,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              context.pop();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black.withOpacity(0.4),
                              ),
                              child: GestureDetector(
                                  onTap: () {
                                    context.pop();
                                  },
                                  child: SvgPicture.asset(
                                    AppImages.back,
                                    height: 2.5 * SizeConfig.heightMultiplier,
                                    width: 2.5 * SizeConfig.heightMultiplier,
                                    color: Colors.grey[400],
                                  )),
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () => context.push(
                              '/camera/${widget.eventId}',
                            ),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 3 * SizeConfig.widthMultiplier,
                                  vertical: 10),
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      width: 0.3,
                                      color: const Color.fromARGB(
                                          255, 103, 103, 103))),
                              child: Center(
                                  child: SvgPicture.asset(
                                AppImages.camera,
                                height: 17,
                                width: 17,
                                color: const Color.fromARGB(255, 103, 103, 103),
                              )),
                            ),
                          ),
                          Gap(2 * SizeConfig.widthMultiplier),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 3 * SizeConfig.widthMultiplier,
                                  vertical: 10),
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      width: 0.3,
                                      color: const Color.fromARGB(
                                          255, 103, 103, 103))),
                              child: Center(
                                  child: SvgPicture.asset(
                                AppImages.uplaod,
                                height: 17,
                                width: 17,
                                color: const Color.fromARGB(255, 103, 103, 103),
                              )),
                            ),
                          ),
                          Gap(2 * SizeConfig.widthMultiplier),
                          BlocProvider(
                            create: (context) => AppCubit(),
                            child: Builder(builder: (context) {
                              return GestureDetector(
                                onTap: () =>
                                    context.read<AppCubit>().shareContent(
                                          subject:
                                              "Share this event with friends and family",
                                          text:
                                              "${AppConstants.APP_URL}/event/${widget.eventId}",
                                        ),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          3 * SizeConfig.widthMultiplier,
                                      vertical: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.6),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          width: 0.3,
                                          color: const Color.fromARGB(
                                              255, 103, 103, 103))),
                                  child: const Center(
                                    child: Icon(Icons.share,
                                        size: 17,
                                        color:
                                            Color.fromARGB(255, 103, 103, 103)),
                                  ),
                                ),
                              );
                            }),
                          )
                        ],
                      ),
                      Gap(2 * SizeConfig.heightMultiplier),
                      BlocConsumer<EventCubit, EventState>(
                        buildWhen: (previous, current) =>
                            current.event != previous.event,
                        listener: (context, state) {},
                        builder: (context, state) {
                          switch (state.status) {
                            case EventStatus.success:
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 35 * SizeConfig.widthMultiplier,
                                    child: Text(
                                      state.event!.name,
                                      style: GoogleFonts.rubikBubbles(
                                          fontSize:
                                              3 * SizeConfig.textMultiplier,
                                          color: const Color.fromARGB(
                                              255, 159, 159, 159),
                                          fontWeight: FontWeight.w600,
                                          height: 1.2),
                                    ),
                                  ),
                                  Gap(1 * SizeConfig.heightMultiplier),
                                  Text(
                                    DateFormat.yMMMd().format(
                                        DateTime.parse(state.event!.createdAt)),
                                    style: GoogleFonts.notoSans(
                                      fontSize: 2 * SizeConfig.textMultiplier,
                                      color: const Color.fromARGB(
                                          255, 159, 159, 159),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              );
                            default:
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Shimmer.fromColors(
                                      baseColor:
                                          const Color.fromARGB(255, 35, 35, 35),
                                      highlightColor:
                                          const Color.fromARGB(255, 49, 49, 49),
                                      child: AnimatedContainer(
                                        duration: Durations.medium1,
                                        height: 3 * SizeConfig.heightMultiplier,
                                        width: 35 * SizeConfig.widthMultiplier,
                                        decoration: BoxDecoration(
                                            color: Colors.grey[700],
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      )),
                                  Gap(2 * SizeConfig.heightMultiplier),
                                  Shimmer.fromColors(
                                      baseColor:
                                          const Color.fromARGB(255, 35, 35, 35),
                                      highlightColor:
                                          const Color.fromARGB(255, 49, 49, 49),
                                      child: AnimatedContainer(
                                        duration: Durations.medium1,
                                        height: 3 * SizeConfig.heightMultiplier,
                                        width: 25 * SizeConfig.widthMultiplier,
                                        decoration: BoxDecoration(
                                            color: Colors.grey[700],
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      )),
                                ],
                              );
                          }
                        },
                      ),
                      Gap(2 * SizeConfig.heightMultiplier),
                      Row(
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                AppImages.camera,
                                height: 20,
                                width: 20,
                                color: const Color(
                                  0xff70B93E,
                                ),
                              ),
                              Gap(0.4 * SizeConfig.widthMultiplier),
                              BlocBuilder<EventCubit, EventState>(
                                buildWhen: (previous, current) =>
                                    previous.imagesTaken != current.imagesTaken,
                                builder: (context, state) {
                                  return Text(
                                    state.imagesTaken.toString(),
                                    style: GoogleFonts.notoSans(
                                      fontSize: 2 * SizeConfig.textMultiplier,
                                      color: const Color(
                                        0xff70B93E,
                                      ),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          Gap(2 * SizeConfig.widthMultiplier),
                          Row(
                            children: [
                              SvgPicture.asset(
                                AppImages.user,
                                height: 20,
                                width: 20,
                                color: const Color(
                                  0xff70B93E,
                                ),
                              ),
                              Gap(0.4 * SizeConfig.widthMultiplier),
                              BlocBuilder<EventCubit, EventState>(
                                buildWhen: (previous, current) =>
                                    previous.usersJoined != current.usersJoined,
                                builder: (context, state) {
                                  return Text(
                                    state.usersJoined.toString(),
                                    style: GoogleFonts.notoSans(
                                      fontSize: 2 * SizeConfig.textMultiplier,
                                      color: const Color(
                                        0xff70B93E,
                                      ),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          const Spacer(),
                        ],
                      ),
                      Gap(2 * SizeConfig.heightMultiplier),
                      BlocProvider(
                        create: (context) => PageCubit(),
                        child: Builder(builder: (context) {
                          return SizedBox(
                            height: 3.7 * SizeConfig.heightMultiplier,
                            child: BlocConsumer<PageCubit, PageState>(
                              listener: (context, state) {
                                if (state.page == 0) {
                                  context
                                      .read<EventCubit>()
                                      .getEventImages(eventId: widget.eventId);
                                } else if (state.page == 1) {
                                  context
                                      .read<EventCubit>()
                                      .getUserImages(eventId: widget.eventId);
                                }
                              },
                              builder: (context, state) {
                                return ListView.separated(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () => context
                                            .read<PageCubit>()
                                            .changePage(page: index),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 15,
                                          ),
                                          decoration: BoxDecoration(
                                              color: Colors.grey[800],
                                              border: Border.all(
                                                width: state.page == index
                                                    ? 2
                                                    : 0.3,
                                                color: state.page == index
                                                    ? Colors.grey[300]!
                                                    : Colors.transparent,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Center(
                                            child: Text(
                                              categories[index],
                                              style: GoogleFonts.notoSans(
                                                  fontSize: 1.8 *
                                                      SizeConfig
                                                          .heightMultiplier,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.grey[200]),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    separatorBuilder: (context, index) =>
                                        Gap(1.5 * SizeConfig.widthMultiplier),
                                    itemCount: categories.length);
                              },
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(1.5 * SizeConfig.heightMultiplier),
                  child: BlocBuilder<EventCubit, EventState>(
                    buildWhen: (previous, current) =>
                        previous.images != current.images,
                    builder: (context, state) {
                      switch (state.status) {
                        case EventStatus.loading:
                          return ImagesShimmer(height: height, width: width);
                        case EventStatus.success:
                          return state.images.isEmpty
                              ? GestureDetector(
                                  onTap: () => context.push(
                                    '/camera/${widget.eventId}',
                                  ),
                                  child: Container(
                                    height: 25 * SizeConfig.heightMultiplier,
                                    width: MediaQuery.sizeOf(context).width,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 35, horizontal: 25),
                                    decoration: BoxDecoration(
                                      color:
                                          const Color.fromARGB(255, 27, 27, 27)
                                              .withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Center(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                AppImages.add,
                                                height: 2.5 *
                                                    SizeConfig.heightMultiplier,
                                                width: 2.5 *
                                                    SizeConfig.heightMultiplier,
                                                color: Colors.grey[400],
                                              ),
                                              Gap(0.2 *
                                                  SizeConfig.widthMultiplier),
                                              Text(
                                                'Add Image',
                                                style: GoogleFonts.notoSans(
                                                  fontSize: 2.2 *
                                                      SizeConfig.textMultiplier,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.grey[400],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Gap(1 * SizeConfig.heightMultiplier),
                                          Text(
                                            'The event has no images yet. Click to add images now. ',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.notoSans(
                                              fontSize:
                                                  2 * SizeConfig.textMultiplier,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey[400],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : RefreshIndicator(
                                  onRefresh: () {
                                    context.read<EventCubit>().getEventImages(
                                        eventId: widget.eventId);
                                    return Future.value();
                                  },
                                  child: GridView.builder(
                                      itemCount: state.images.length,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        mainAxisSpacing:
                                            1 * SizeConfig.heightMultiplier,
                                        crossAxisSpacing:
                                            1 * SizeConfig.heightMultiplier,
                                        childAspectRatio: 0.9,
                                      ),
                                      itemBuilder: (context, index) {
                                        return Stack(
                                          children: [
                                            GestureDetector(
                                              onTap: () => context
                                                  .push('/preview', extra: {
                                                "url": state.images[index].url
                                              }),
                                              child: ImageContainer(
                                                  imageUrl:
                                                      state.images[index].url,
                                                  borderRadius:
                                                      BorderRadius.zero,
                                                  height: height,
                                                  width: width,
                                                  fit: BoxFit.cover),
                                            ),
                                            Positioned.fill(
                                                bottom: 1 *
                                                    SizeConfig.heightMultiplier,
                                                left: 1 *
                                                    SizeConfig.heightMultiplier,
                                                child: Align(
                                                  alignment:
                                                      Alignment.bottomLeft,
                                                  child: Text(
                                                    state
                                                        .images[index].user.name
                                                        .toString()
                                                        .split(" ")[0],
                                                    style: GoogleFonts.notoSans(
                                                      fontSize: 1.8 *
                                                          SizeConfig
                                                              .textMultiplier,
                                                      color: Colors.grey[100],
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                )),
                                            // Positioned.fill(
                                            //     top: 1 *
                                            //         SizeConfig.heightMultiplier,
                                            //     right: 1 *
                                            //         SizeConfig.heightMultiplier,
                                            //     child: Align(
                                            //       alignment: Alignment.topRight,
                                            //       child: Container(
                                            //         padding: const EdgeInsets
                                            //             .symmetric(
                                            //             vertical: 7,
                                            //             horizontal: 4),
                                            //         decoration: BoxDecoration(
                                            //             color: Colors.black
                                            //                 .withOpacity(0.6),
                                            //             borderRadius:
                                            //                 BorderRadius
                                            //                     .circular(5),
                                            //             border: Border.all(
                                            //                 width: 0.3,
                                            //                 color: Colors
                                            //                     .grey[500]!)),
                                            //         child: const Icon(
                                            //           Icons.more_vert,
                                            //           size: 20,
                                            //           color: Colors.white,
                                            //         ),
                                            //       ),
                                            //     )),
                                            state.images[index].hd
                                                ? Positioned.fill(
                                                    bottom: 1 *
                                                        SizeConfig
                                                            .heightMultiplier,
                                                    right: 1 *
                                                        SizeConfig
                                                            .heightMultiplier,
                                                    child: Align(
                                                      alignment:
                                                          Alignment.bottomRight,
                                                      child: Container(
                                                          padding: const EdgeInsets.symmetric(
                                                              vertical: 3,
                                                              horizontal: 5),
                                                          decoration: BoxDecoration(
                                                              color: Colors.black
                                                                  .withOpacity(
                                                                      0.6),
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                      5),
                                                              border: Border.all(
                                                                  width: 0.3,
                                                                  color:
                                                                      Colors.grey[
                                                                          500]!)),
                                                          child: Text("HD",
                                                              style: GoogleFonts.robotoCondensed(
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: 12,
                                                                  color: Colors.white))),
                                                    ))
                                                : const SizedBox.shrink()
                                          ],
                                        );
                                      }),
                                );
                        default:
                          return ImagesShimmer(height: height, width: width);
                      }
                    },
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

class ImagesShimmer extends StatelessWidget {
  const ImagesShimmer({
    super.key,
    required this.height,
    required this.width,
  });

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: 20,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 1 * SizeConfig.heightMultiplier,
          crossAxisSpacing: 1 * SizeConfig.heightMultiplier,
          childAspectRatio: 0.9,
        ),
        itemBuilder: (context, index) {
          return Stack(
            children: [
              Shimmer.fromColors(
                baseColor: const Color.fromARGB(255, 35, 35, 35),
                highlightColor: const Color.fromARGB(255, 38, 38, 38),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  height: height,
                  width: width,
                  decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(0)),
                ),
              ),
              Positioned.fill(
                  bottom: 1 * SizeConfig.heightMultiplier,
                  left: 1 * SizeConfig.heightMultiplier,
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Shimmer.fromColors(
                      baseColor: const Color.fromARGB(255, 42, 42, 42),
                      highlightColor: const Color.fromARGB(255, 55, 55, 55),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        height: 2 * SizeConfig.heightMultiplier,
                        width: 9 * SizeConfig.widthMultiplier,
                        decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  )),
              // Positioned.fill(
              //     top: 1 * SizeConfig.heightMultiplier,
              //     right: 1 * SizeConfig.heightMultiplier,
              //     child: Align(
              //       alignment: Alignment.topRight,
              //       child: Shimmer.fromColors(
              //         baseColor: const Color.fromARGB(255, 42, 42, 42),
              //         highlightColor: const Color.fromARGB(255, 55, 55, 55),
              //         child: AnimatedContainer(
              //           duration: const Duration(milliseconds: 400),
              //           height: 5 * SizeConfig.heightMultiplier,
              //           width: 4 * SizeConfig.widthMultiplier,
              //           decoration: BoxDecoration(
              //               color: Colors.grey[800],
              //               borderRadius: BorderRadius.circular(8)),
              //         ),
              //       ),
              //     ))
            ],
          );
        });
  }
}
