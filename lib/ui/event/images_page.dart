import 'package:picsa/common_widgets/image_container.dart';
import 'package:picsa/common_widgets/loading_circle.dart';
import 'package:picsa/utilities/packages.dart';

class ImagesPage extends StatelessWidget {
  const ImagesPage({super.key, required this.eventId});

  final String eventId;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.grey[500],
          ),
        ),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(15)),
            child: Row(
              children: [
                Icon(
                  Icons.upload_outlined,
                  size: height * 0.024,
                  color: Colors.grey[400],
                ),
                const Gap(5),
                Text(
                  "Export",
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    color: Colors.grey[400],
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          ),
          Gap(width * 0.04),
        ],
      ),
      body: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: BlocProvider(
              create: (context) =>
                  EventCubit()..getEventImages(eventId: eventId),
              child: BlocBuilder<EventCubit, EventState>(
                builder: (context, state) {
                  switch (state.status) {
                    case EventStatus.loading:
                      return const Center(
                        child: LoadingCircle(),
                      );
                    case EventStatus.success:
                      return RefreshIndicator(
                        onRefresh: () {
                          context
                              .read<EventCubit>()
                              .getEventImages(eventId: eventId);
                          return Future.value();
                        },
                        child: GridView.builder(
                            itemCount: state.images.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10),
                            itemBuilder: (context, index) {
                              return ImageContainer(
                                  imageUrl: state.images[index].url,
                                  borderRadius: BorderRadius.circular(10),
                                  height: height,
                                  width: width);
                            }),
                      );
                    default:
                      return const Center(
                        child: LoadingCircle(),
                      );
                  }
                },
              ),
            ),
          )),
    );
  }
}
