import 'package:go_router/go_router.dart';
import 'package:picsa/ui/home.dart';

import '../ui/camera_page.dart';

final appRouter = GoRouter(initialLocation: '/home', routes: [
  GoRoute(
      path: '/camera-page',
      builder: (context, state) {
        return const CameraPage(
          
        );
      }),
  GoRoute(
      path: '/home',
      builder: (context, state) {
        return const Home();
      })
]);
