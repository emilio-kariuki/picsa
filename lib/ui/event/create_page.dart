
import 'package:picsa/domain/blocs/minimal/bool/bool_cubit.dart';
import 'package:picsa/common_widgets/input_field.dart';
import 'package:picsa/common_widgets/loading_circle.dart';
import 'package:picsa/utilities/packages.dart';

class CreatePage extends StatelessWidget {
  CreatePage({super.key});

  final _eventController = TextEditingController();
  final globalKey = GlobalKey<FormState>();

  bool isEmpty = true;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Form(
      key: globalKey,
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              height: height,
              width: width,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AppImages.welcome),
                  fit: BoxFit.cover,
                  // opacity: 0.4,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ClipRect(
                child: Container(
                  width: width,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  color: Colors.transparent,
                  child: BlocProvider(
                    create: (context) => BoolCubit(),
                    child: BlocConsumer<BoolCubit, BoolState>(
                      listener: (context, state) {
                        if (state is BoolChanged) {
                          isEmpty = state.value;
                        }
                      },
                      builder: (context, state) {
                        return IntrinsicHeight(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SvgPicture.asset(
                                    AppConstants.APP_LOGO,
                                    height: height * 0.08,
                                    width: height * 0.08,
                                  ),
                                  Gap(width * 0.05),
                                  Text(
                                    AppConstants.APP_NAME,
                                    style: GoogleFonts.rubikBubbles(
                                      color: Colors.white,
                                      fontSize: 50,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Gap(height * 0.02),
                              InputField(
                                controller: _eventController,
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: SvgPicture.asset(
                                    AppImages.edit,
                                    color: Colors.grey[300],
                                    height: 1 * SizeConfig.heightMultiplier,
                                    width: 1 * SizeConfig.heightMultiplier,
                                  ),
                                ),
                                borderRadius: 15,
                                onChanged: (value) {
                                  globalKey.currentState!.validate();
                                  return null;
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    context
                                        .read<BoolCubit>()
                                        .change(value: true);
                                  } else {
                                    context
                                        .read<BoolCubit>()
                                        .change(value: false);
                                  }
                                  return null;
                                },
                                hintText: "What's the occassion?",
                              ),
                              Gap(height * 0.015),
                              isEmpty
                                  ? Container(
                                      height: height * 0.075,
                                      width: width,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: const Color(0xff1E1E1E)),
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Add a Name to Get Started",
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.inter(
                                                color: Colors.grey[500],
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const Gap(10),
                                            Icon(
                                              Icons.arrow_forward,
                                              color: Colors.grey[500],
                                              size: 20,
                                            )
                                          ],
                                        ),
                                      ))
                                  : CreateButton(
                                      height: height,
                                      width: width,
                                      eventController: _eventController,
                                    ),
                              Gap(height * 0.015),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CreateButton extends StatelessWidget {
  const CreateButton({
    super.key,
    required this.height,
    required this.width,
    required this.eventController,
  });

  final double height;
  final double width;
  final TextEditingController eventController;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EventCubit(),
      child: BlocConsumer<EventCubit, EventState>(
        listener: (context, state) {
          if (state.status == EventStatus.error) {
            context.showErrorToast(
                title: "Error",
                message: "Error creating an event",
                context: context);
          }
        },
        builder: (context, state) {
          return Center(
              child: SizedBox(
            height: height * 0.075,
            width: width,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color(
                  0xff70B93E,
                ),
                side: BorderSide.none,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
              onPressed: () {
                context.read<EventCubit>().createEvent(
                      name: eventController.text,
                    );
              },
              child: state.status == EventStatus.loading
                  ? const Center(
                      child: LoadingCircle(
                        color: Color(
                          0xff70B93E,
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Continue',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Gap(10),
                        const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 20,
                        ),
                      ],
                    ),
            ),
          ));
        },
      ),
    );
  }
}
