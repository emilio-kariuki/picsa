import 'package:picsa/ui/event/event_create_page.dart';
import 'package:picsa/ui/event/image_preview.dart';
import 'package:picsa/ui/event/images_page.dart';
import 'package:picsa/utilities/packages.dart';

import '../ui/camera/camera_page.dart';

final appRouter = GoRouter(
  initialLocation: '/welcome',
  routes: [
    GoRoute(
        path: '/camera/:id',
        name: Routes.camera,
        pageBuilder: (context, state) {
          final id = state.pathParameters['id'];
          return CustomTransitionPage<void>(
            key: state.pageKey,
            child: CameraPage(eventId: id!),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    FadeTransition(opacity: animation, child: child),
          );
        }),
    GoRoute(
      path: '/home',
      name: Routes.home,
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: const Home(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    ),
    GoRoute(
      path: '/welcome',
      name: Routes.welcome,
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: WelcomePage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    ),
    GoRoute(
        path: '/event-create-page',
        builder: (context, state) {
          final data = state.extra;
          return EventCreatePage(
            name: (data as Map)['name'],
          );
        }),
    GoRoute(
        path: '/images/:id',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id'];
          return CustomTransitionPage<void>(
            arguments: id,
            key: state.pageKey,
            child: ImagesPage(
              eventId: id!,
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    FadeTransition(opacity: animation, child: child),
          );
        }),
    GoRoute(
      path: '/preview',
      builder: (context, state) {
        final data = state.extra;
        return ImagePreview(
          url: (data as Map)['url']
        );
      },
    )
  ],
  redirect: (BuildContext context, GoRouterState state) async {
    // get route state
    final bool loggedIn = supabase.auth.currentUser != null;
    final bool loggingIn = state.matchedLocation == Routes.welcome;
    if (!loggedIn) return Routes.welcome;
    if (loggingIn) {
      return Routes.home;
    }
    return null;
    // no need to redirect at all
  },
);

class Routes {
  static const String welcome = '/welcome';
  static const String home = '/home';
  static const String camera = '/camera';
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream stream) {
    stream.listen(
      (value) {
        notifyListeners();
      },
    );
  }
}
