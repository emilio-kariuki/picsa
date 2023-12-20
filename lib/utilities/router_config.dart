import 'package:camera/camera.dart';
import 'package:go_router/go_router.dart';
import 'package:picsa/main.dart';

import '../ui/camera_page.dart';

final appRouter = GoRouter(initialLocation: '/camera-page', initialExtra: {
  'camera': camera,
}, routes: [
  GoRoute(
      path: '/camera-page',
      builder: (context, state) {
        return CameraPage(
          camera: (state.extra as Map)['camera'] as CameraDescription,
        );
      })
]);
