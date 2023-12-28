import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:picsa/domain/blocs/app_functionality/auth/auth/auth_cubit.dart';
import 'package:picsa/ui/authentication/widgets/logo_container.dart';
import 'package:picsa/ui/authentication/widgets/terms_of_service.dart';
import 'package:picsa/utilities/app_constants.dart';
import 'package:picsa/utilities/app_images.dart';
import 'package:picsa/utilities/common_widgets/loading_circle.dart';
import 'package:picsa/utilities/extension.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BackGroundImage(
      child: SafeArea(child: Container()),
    );
  }
}

class BackGroundImage extends StatelessWidget {
  const BackGroundImage({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
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
            child: child,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  color: Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                      Gap(height * 0.03),
                      SizedBox(
                        width: width * 0.8,
                        child: Text(
                          AppConstants.APP_DESCRIPTION,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.rubikBubbles(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Gap(height * 0.03),
                      GoogleButton(height: height, width: width),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: TermsOfService(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GoogleButton extends StatelessWidget {
  const GoogleButton({
    super.key,
    required this.height,
    required this.width,
  });

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocProvider(
        create: (context) => AuthCubit(),
        child: Builder(builder: (context) {
          return BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthSuccess) {
                context
                  ..read<AuthCubit>().createUser(user: state.user)
                  ..go('/home');
              } else if (state is AuthFailure) {
                context.showErrorToast(
                    title: "Error",
                    message: "Authentication failed",
                    context: context);
              }
            },
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                child: SizedBox(
                  height: height * 0.07,
                  width: width,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.white,
                      surfaceTintColor: Colors.white,
                      
                      side: const BorderSide(
                        color: Colors.white,
                        width: 2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                    onPressed: () {
                      context.read<AuthCubit>().signInWithGoogle();
                    },
                    child: state is AuthLoading
                        ? const Center(
                            child: LoadingCircle(
                              color: Colors.deepOrange,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                AppImages.google,
                                height: height * 0.03,
                                width: height * 0.03,
                              ),
                              const Gap(15),
                              Text(
                                'Sign in with Google',
                                style: GoogleFonts.inter(
                                  color: Colors.black54,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}


