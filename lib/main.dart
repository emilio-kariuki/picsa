import 'package:firebase_core/firebase_core.dart';
import 'package:logger/logger.dart';
import 'package:picsa/domain/blocs/app/subscription_cubit.dart';
import 'package:picsa/domain/blocs/app/user_cubit.dart';
import 'package:picsa/domain/service/repository/notification_repository.dart';
import 'package:picsa/domain/service/service_locator.dart';
import 'package:picsa/firebase_options.dart';
import 'package:picsa/utilities/packages.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:upgrader/upgrader.dart';
import 'domain/blocs/app/auth_cubit.dart';
import 'domain/blocs/app/camera_cubit.dart';


final _configuration = PurchasesConfiguration(
  "goog_uZSqPAlvIUywJYBFwnOxQRzBZMl",
);

final logger = Logger();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  initLocator();
  await Supabase.initialize(
      url: 'https://pvotaaukwfeabaqtahfu.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InB2b3RhYXVrd2ZlYWJhcXRhaGZ1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDI5OTQwMDcsImV4cCI6MjAxODU3MDAwN30.Xv5gQJklMkH9NKq222NHYdGLlE722QemDe8__Bg2pl4',
      authOptions: const FlutterAuthClientOptions(
        autoRefreshToken: true,
      ),
      debug: false,
      storageOptions: const StorageClientOptions(
        retryAttempts: 3,
      ),
      postgrestOptions: const PostgrestClientOptions(
        schema: 'public',
      ));
  await Purchases.configure(_configuration);
  await Purchases.setLogLevel(LogLevel.info);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await NotificationRepository().initializeNotifications();
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await SentryFlutter.init((options) {
    options.dsn =
        'https://c9cda213331825e069a1535b08dd02ca@o4507333268275200.ingest.de.sentry.io/4507333270175824';
    options.tracesSampleRate = 1.0;
    options.profilesSampleRate = 1.0;
  }, appRunner: () => runApp(const MainApp()));
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  static const appcastURL = 'https://picsa.pro/upgrader/appcast.xml';

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final upgrader = Upgrader(
    storeController: UpgraderStoreController(
      onAndroid: () => UpgraderAppcastStore(appcastURL: MainApp.appcastURL),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit()..isSignedIn(),
          lazy: false,
        ),
        BlocProvider(
          create: (context) => UserCubit()
            ..getUser()
            ..getNotifications()
            ..showNotificationBadge(),
          lazy: false,
        ),
        BlocProvider(
          create: (context) => CameraCubit()..initialize(),
          lazy: false,
        ),
        BlocProvider(
          create: (context) => SubscriptionCubit()..getPackages(),
          lazy: false,
        ),
        BlocProvider(
          create: (context) => EventCubit()
            ..getEvents()
            ..getGuestEvents(),
          lazy: false,
        ),
      ],
      child: LayoutBuilder(builder: (context, constraints) {
        SizeConfig().init(constraints);
        return MaterialApp.router(
          darkTheme: darkTheme,
          themeMode: ThemeMode.dark,
          routerDelegate: appRouter.routerDelegate,
          routeInformationParser: appRouter.routeInformationParser,
          routeInformationProvider: appRouter.routeInformationProvider,
          title: 'Picsa',
          debugShowCheckedModeBanner: false,
          builder: (context, child) {
            return UpgradeAlert(
              upgrader: upgrader,
              navigatorKey: appRouter.routerDelegate.navigatorKey,
              child: child ?? const Text('child'),
            );
          },
        );
      }),
    );
  }
}
