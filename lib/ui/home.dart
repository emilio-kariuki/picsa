import 'package:picsa/domain/blocs/minimal/navigation_cubit.dart';
import 'package:picsa/utilities/packages.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class Home extends StatefulWidget {
  final Widget child;
  const Home({super.key, required this.child});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static const List<Map<String, dynamic>> _footerItems = [
    {'icon': Icons.calendar_month_outlined, 'name': "Create"},
    {'icon': Icons.camera_alt_outlined, 'name': "Events"},
    {'icon': Icons.settings, 'name': "Settings"},
  ];

  static const List<String> _routes = [
    '/home',
    '/events',
    '/settings',
  ];

  @override
  void initState() {
    super.initState();
    Purchases.addCustomerInfoUpdateListener((customerInfo) {
      if (customerInfo.activeSubscriptions.isNotEmpty) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NavigationCubit(),
      child: Scaffold(
        body: widget.child,
        bottomNavigationBar: _getFooter(context),
      ),
    );
  }

  Widget _getFooter(BuildContext context) {
    return BlocConsumer<NavigationCubit, NavigationState>(
      listener: (context, state) {
        appRouter.go(_routes[state.page]);
      },
      builder: (context, state) {
        return AnimatedBottomNavigationBar.builder(
          elevation: 0,
          backgroundColor: Colors.transparent,
          notchSmoothness: NotchSmoothness.softEdge,
          itemCount: _footerItems.length,
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
            return _buildTabItem(_footerItems[index], isActive);
          },
        );
      },
    );
  }

  Widget _buildTabItem(Map<String, dynamic> item, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
          decoration: BoxDecoration(
            color: isActive
                ? const Color.fromARGB(255, 19, 194, 25).withOpacity(0.2)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            item['icon'] as IconData,
            size: 17,
            color: Colors.grey[400],
          ),
        ),
        const Gap(3),
        Text(
          item['name'] as String,
          style: GoogleFonts.inter(
            color: Colors.grey[400],
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
