import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:picsa/domain/blocs/app_functionality/auth/auth/auth_cubit.dart';
import 'package:picsa/domain/blocs/minimal_functionality/bool/bool_cubit.dart';
import 'package:picsa/ui/authentication/welcome_page.dart';
import 'package:picsa/utilities/app_images.dart';
import 'package:picsa/utilities/color_constants.dart';
import 'package:picsa/utilities/common_widgets/input_field.dart';

import '../../utilities/app_constants.dart';
import '../authentication/widgets/logo_container.dart';

class CreatePage extends StatelessWidget {
  const CreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BackgroundCreate();
  }
}

class BackgroundCreate extends StatelessWidget {
  BackgroundCreate({super.key});

  final eventController = TextEditingController();
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
                  image: AssetImage(AppImages.create),
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
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                      sigmaX: 4.0, sigmaY: 4.0, tileMode: TileMode.decal),
                  child: Container(
                    // height: MediaQuery.of(context).size.height * 0.31,
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
                                    SvgPicture.asset(AppConstants.APP_LOGO,
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
                                  controller: eventController,
                                  prefixIcon:  Icon(
                                    Icons.edit_outlined,
                                    color: Colors.grey[500]!,
                                    size: 20,
                                  ),
                                  borderRadius: 15,
                                  onChanged: (value) {
                                    globalKey.currentState!.validate();
                                    return null;
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                     context.read<BoolCubit>().change(value: true);
                                    } else {
                                      context.read<BoolCubit>().change(value: false);
                                    }
                                    return null;
                                  },
                                  hintText: "What's the occassion?",
                                ),
                                Gap(height * 0.015),
                                isEmpty
                                    ? Container(
                                        height: height * 0.085,
                                        width: width,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: primaryColor),
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
                                    : CreateButton(height: height, width: width),
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
  });

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: height * 0.085,
        width: width,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 216, 50, 0),
            side:  BorderSide.none,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13),
            ),
          ),
          onPressed: () {
            context.read<AuthCubit>().signInWithGoogle();
          },
          child:  Row(
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
      )
    );
  }
}