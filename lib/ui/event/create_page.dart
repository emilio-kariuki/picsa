// ignore_for_file: must_be_immutable

import 'package:picsa/domain/blocs/minimal/bool_cubit.dart';
import 'package:picsa/common_widgets/input_field.dart';
import 'package:picsa/common_widgets/loading_circle.dart';
import 'package:picsa/domain/blocs/minimal/navigation_cubit.dart';
import 'package:picsa/utilities/packages.dart';

final focusNode = FocusNode();

class CreatePage extends StatelessWidget {
  CreatePage({super.key});

  final _eventController = TextEditingController();
  final globalKey = GlobalKey<FormState>();

  bool isEmpty = true;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    var keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        height: screenHeight - keyboardHeight,
        width: width,
        padding: const EdgeInsets.all(15),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.welcome),
            fit: BoxFit.cover,
            // opacity: 0.4,
          ),
        ),
        child: BlocProvider(
          create: (context) => BoolCubit(),
          child: BlocConsumer<BoolCubit, BoolState>(
            listener: (context, state) {
              if (state.status == BoolStatus.changed) {
                isEmpty = state.value;
              }
            },
            builder: (context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        AppConstants.APP_LOGO,
                        height: height * 0.07,
                        width: height * 0.07,
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
                    focusNode: focusNode,
                    textInputType: TextInputType.text,
                    fillColor: const Color(0xff000000).withOpacity(0.3),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: SvgPicture.asset(
                        AppImages.edit,
                        color: Colors.grey[300],
                        height: 1 * SizeConfig.heightMultiplier,
                        width: 1 * SizeConfig.heightMultiplier,
                      ),
                    ),
                    borderRadius: 15,
                    onChanged: (value) {
                      if (value!.isEmpty) {
                        context.read<BoolCubit>().changeValue(value: true);
                      } else {
                        context.read<BoolCubit>().changeValue(value: false);
                      }
                      return null;
                    },
                    validator: (value) {
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
                              borderRadius: BorderRadius.circular(15),
                              color: const Color(0xff000000).withOpacity(0.3)),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                          eventController: _eventController,
                        ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class CreateButton extends StatelessWidget {
  const CreateButton({
    super.key,
    required this.eventController,
  });

  final TextEditingController eventController;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;

    return BlocProvider(
      create: (context) => EventCubit(),
      child: BlocConsumer<EventCubit, EventState>(
        listener: (context, state) {
          if (state.status == EventStatus.created) {
            context.read<NavigationCubit>().changePage(page: 1);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                content: Text(
                  'Event created successfully',
                  style: GoogleFonts.inter(
                    fontSize: 2 * SizeConfig.textMultiplier,
                    color: white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                elevation: 0,
                backgroundColor: green,
                duration: const Duration(seconds: 4),
              ),
            );
          }
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
                  ? Center(
                      child: LoadingCircle(color: white),
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
