import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:picsa/blocs/minimal_functionality/navigation/navigation_cubit.dart';
import 'package:picsa/ui/camera_page.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  Widget getBody() {
    final pages = <Widget>[
      Container(),
     CameraPage(),
      Container(),
    ];
    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, state) {
        return IndexedStack(
          index: state is NavigationChanged ? state.page : 0,
          children: pages,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NavigationCubit(),
      child: Scaffold(
        backgroundColor: const Color(0xffF6F6F6),
        // extendBody: true,
        body: getBody(),
        bottomNavigationBar: getFooter(context),
      ),
    );
  }

  Widget getFooter(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final items = <Map<String, dynamic>>[
      {'icon': Icons.calendar_month_outlined, 'name': "Create"},
      {'icon': Icons.camera_alt_outlined, 'name': "Cameras"},
      {'icon': Icons.settings, 'name': "Settings"},
    ];
    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, state) {
        return SizedBox(
          height: height * 0.09,
          child: AnimatedBottomNavigationBar.builder(
            elevation: 0,
            backgroundColor: Colors.black54,
            notchSmoothness: NotchSmoothness.softEdge,
            itemCount: items.length,
            safeAreaValues: const SafeAreaValues(
              bottom: false,
            ),
            activeIndex: state is NavigationChanged ? state.page : 0,
            gapWidth: 10,
            splashRadius: 0,
            scaleFactor: 0,
            onTap: (index) {
              BlocProvider.of<NavigationCubit>(context).changePage(page: index);
              SystemChannels.textInput.invokeMethod('TextInput.hide');
            },
            tabBuilder: (int index, bool isActive) {
              final itemz = items[index];

              return Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                    decoration: BoxDecoration(
                        color: isActive
                            ? const Color.fromARGB(255, 19, 194, 25)
                                .withOpacity(0.2)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20)),
                    child: Icon(
                      itemz['icon'] as IconData,
                      size: 24,
                      color: Colors.grey[300],
                    ),
                  ),
                  const Gap(3),
                  Text(
                    itemz['name'] as String,
                    style: GoogleFonts.inter(
                      color: Colors.grey[300],
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  )
                ],
              );
            },
          ),
        );
      },
    );
  }
}
