
import 'package:picsa/domain/blocs/minimal/navigation/navigation_cubit.dart';
import 'package:picsa/ui/event/create_page.dart';
import 'package:picsa/ui/event/event_page.dart';
import 'package:picsa/ui/settings/settings_page.dart';
import 'package:picsa/utilities/packages.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  Widget getBody() {
    final pages = <Widget>[
      CreatePage(),
      // CameraPage(eventId: "47c2adb1-1390-4899-8a0d-f95cbbaaf7ca",),
      EventPage(),
      SettingsPage()
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
      {'icon': Icons.camera_alt_outlined, 'name': "Events"},
      {'icon': Icons.settings, 'name': "Settings"},
    ];
    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, state) {
        return SizedBox(
          height: height * 0.09,
          child: AnimatedBottomNavigationBar.builder(
            elevation: 0,
            backgroundColor: Colors.transparent,
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
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                    decoration: BoxDecoration(
                        color: isActive
                            ? const Color.fromARGB(255, 19, 194, 25)
                                .withOpacity(0.2)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20)),
                    child: Icon(
                      itemz['icon'] as IconData,
                      size: 22,
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
