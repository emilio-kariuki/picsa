import 'package:picsa/domain/blocs/app/user_cubit.dart';
import 'package:picsa/domain/blocs/minimal/navigation_cubit.dart';
import 'package:picsa/ui/event/create_page.dart';
import 'package:picsa/ui/event/event_page.dart';
import 'package:picsa/ui/settings/settings_page.dart';
import 'package:picsa/utilities/packages.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    Purchases.addCustomerInfoUpdateListener((customerInfo) {
      debugPrint("The Customer Info: $customerInfo");
      if (customerInfo.activeSubscriptions.isNotEmpty) {
        // context.read<UserCubit>().getUser();
      }
    });
    supabase
      ..channel('public:User')
          .onPostgresChanges(
              event: PostgresChangeEvent.update,
              schema: 'public',
              table: 'User',
              filter: PostgresChangeFilter(
                type: PostgresChangeFilterType.eq,
                column: 'id',
                value: supabase.auth.currentUser!.id,
              ),
              callback: (payload) {
                debugPrint('Change received: ${payload.toString()}');
                context.read<UserCubit>().getUser();
              })
          .subscribe()
      ..channel('public:Events')
          .onPostgresChanges(
              event: PostgresChangeEvent.all,
              schema: 'public',
              table: 'Events',
              // filter: PostgresChangeFilter(
              //   type: PostgresChangeFilterType.eq,
              //   column: 'userId',
              //   value: supabase.auth.currentUser!.id,
              // ),
              callback: (payload) {
                debugPrint('Change received: ${payload.toString()}');
                context.read<EventCubit>().getEvents();
              })
          .subscribe()
      ..channel('public:GuestEvents')
          .onPostgresChanges(
              event: PostgresChangeEvent.all,
              schema: 'public',
              table: 'GuestEvents',
              filter: PostgresChangeFilter(
                type: PostgresChangeFilterType.eq,
                column: 'userId',
                value: supabase.auth.currentUser!.id,
              ),
              callback: (payload) {
                debugPrint('Change received: ${payload.toString()}');
                context.read<EventCubit>().getGuestEvents();
              })
          .subscribe();
  }

  Widget getBody() {
    final pages = <Widget>[
      CreatePage(),
      // CameraPage(eventId: "47c2adb1-1390-4899-8a0d-f95cbbaaf7ca",),
       EventPage(),
      const SettingsPage()
    ];
    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, state) {
        return IndexedStack(
          index: state.page,
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
            activeIndex: state.page,
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
