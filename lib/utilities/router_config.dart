import 'package:go_router/go_router.dart';
import 'package:picsa/main.dart';
import 'package:picsa/ui/event/event_create_page.dart';
import 'package:picsa/ui/home.dart';

import '../ui/camera/camera_page.dart';

final appRouter = GoRouter(initialLocation: '/checker', routes: [
  GoRoute(
      path: '/camera-page',
      builder: (context, state) {
        final data = state.extra;
        return CameraPage(
          eventId: (data as Map)['eventId'],
        );
      }),
  GoRoute(
      path: '/home',
      builder: (context, state) {
        return const Home();
      }),
  GoRoute(
      path: '/checker',
      builder: (context, state) {
        return const Checker();
      }),
  GoRoute(
      path: '/event-create-page',
      builder: (context, state) {
        final data = state.extra;
        return EventCreatePage(
          name: (data as Map)['name'],
        );
      })
]);
