import 'package:picsa/ui/event/create_page.dart';
import 'package:picsa/ui/event/event_page.dart';
import 'package:picsa/ui/event/notifications_page.dart';
import 'package:picsa/ui/image/image_editor.dart';
import 'package:picsa/ui/image/image_preview.dart';
import 'package:picsa/ui/image/images_page.dart';
import 'package:picsa/ui/settings/settings_page.dart';
import 'package:picsa/utilities/packages.dart';

import '../ui/camera/camera_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: rootNavigator,
  initialLocation: '/home',
  observers: [
    PosthogObserver(),
  ],
  routes: [
    GoRoute(
      path: '/camera/:id',
      name: Routes.camera,
      pageBuilder: (context, state) {
        final id = state.pathParameters['id'];
        return CustomTransitionPage<void>(
          key: state.pageKey,
          child: CameraPage(eventId: id!),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
        );
      },
      redirect: (context, state) {
        final user = supabase.auth.currentUser;
        if (user == null) {
          return Routes.welcome;
        }
        return null;
      },
    ),
    GoRoute(
      path: '/welcome',
      name: Routes.welcome,
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: const WelcomePage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
      redirect: (context, state) {
        final user = supabase.auth.currentUser;
        if (user == null) {
          return Routes.welcome;
        }
        return null;
      },
    ),
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
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
        );
      },
      redirect: (context, state) {
        final user = supabase.auth.currentUser;
        if (user == null) {
          return Routes.welcome;
        }
        return null;
      },
    ),
    GoRoute(
      path: '/preview',
      builder: (context, state) {
        final data = state.extra;
        return ImagePreview(url: (data as Map)['url']);
      },
      redirect: (context, state) {
        final user = supabase.auth.currentUser;
        if (user == null) {
          return Routes.welcome;
        }
        return null;
      },
    ),
    GoRoute(
      path: '/editor',
      builder: (context, state) {
        final data = state.extra;
        return ImageEditor(url: (data as Map)['url']);
      },
      redirect: (context, state) {
        final user = supabase.auth.currentUser;
        if (user == null) {
          return Routes.welcome;
        }
        return null;
      },
    ),

    ShellRoute(
      navigatorKey: _rootNavigatorKey,
      builder: (context, state, child) => Home(child: child),
      routes: [
        GoRoute(
          path: '/home',
          name: Routes.home,
          pageBuilder: (context, state) => MaterialPage(child: CreatePage()),
          routes: [
            GoRoute(
                path: 'notifications',
                name: Routes.notifications,
                builder: (context, state) {
                  return const NotificationPage();
                }),
          ],
          redirect: (context, state) async {
            final user = supabase.auth.currentUser;
            if (user == null) {
              return '/welcome';
            }
            return null;
          },
        ),
        GoRoute(
            path: '/events',
            name: Routes.events,
            redirect: (context, state) {
              final user = supabase.auth.currentUser;
              if (user == null) {
                return '/welcome';
              }
              return null;
            },
            pageBuilder: (context, state) =>
                const MaterialPage(child: EventPage()),
            routes: [
              GoRoute(
                  path: 'images/:id',
                  name: Routes.images,
                  redirect: (context, state) {
                    final user = supabase.auth.currentUser;
                    if (user == null) {
                      return '/welcome';
                    }
                    return null;
                  },
                  builder: (context, state) {
                    final id = state.pathParameters['id'];
                    return ImagesPage(
                      eventId: id!,
                    );
                  })
            ]),
        GoRoute(
            path: '/settings',
            name: Routes.settings,
            redirect: (context, state) {
              final user = supabase.auth.currentUser;
              if (user == null) {
                return '/welcome';
              }
              return null;
            },
            pageBuilder: (context, state) =>
                const MaterialPage(child: SettingsPage()),
            routes: []),
      ],
    ),
  ],

);

class Routes {
  static const String welcome = '/welcome';
  static const String home = '/home';
  static const String notifications = '/home/notifications';
  static const String events = '/events';
  static const String camera = '/camera';
  static const String images = '/images';
  static const String preview = '/preview';
  static const String settings = '/settings';
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

final GlobalKey<NavigatorState> rootNavigator = GlobalKey(debugLabel: 'root');
