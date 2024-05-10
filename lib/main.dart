import 'package:firebase_core/firebase_core.dart';
import 'package:picsa/domain/blocs/app/subscription_cubit.dart';
import 'package:picsa/domain/blocs/app/user_cubit.dart';
import 'package:picsa/domain/service/repository/notification_repository.dart';
import 'package:picsa/domain/service/service_locator.dart';
import 'package:picsa/firebase_options.dart';
import 'package:picsa/utilities/packages.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'domain/blocs/app/auth_cubit.dart';
import 'domain/blocs/app/camera_cubit.dart';

final _configuration = PurchasesConfiguration(
  "goog_uZSqPAlvIUywJYBFwnOxQRzBZMl",
);

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
      ));
  // if (Platform.isAndroid) {
  await Purchases.configure(_configuration);
  await Purchases.setLogLevel(LogLevel.debug);
  // }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await NotificationRepository().initializeFirebaseMessaging();
  await NotificationRepository().getNotificationToken();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    await NotificationRepository().showLowNotification(
      message: message.notification!.body!,
      title: message.notification!.title!,
    );
  });
  runApp(const MainApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UserCubit()..getUser(),
          lazy: false,
        ),
        BlocProvider(
          create: (context) => SubscriptionCubit()
            ..isSubscribed()
            ..getPackages(),
          lazy: false,
        ),
        BlocProvider(
          create: (context) => CameraCubit()..initialize(),
          lazy: false,
        ),
        BlocProvider(
          create: (context) => EventCubit()
            ..getEvents()
            ..getGuestEvents(),
          lazy: false,
        ),
        BlocProvider(
          create: (context) => AuthCubit()..isSignedIn(),
          lazy: false,
        ),
      ],
      child: LayoutBuilder(builder: (context, constraints) {
        SizeConfig().init(constraints);
        return MaterialApp.router(
          darkTheme: darkTheme,
          themeMode: ThemeMode.dark,
          routerConfig: appRouter,
          title: 'Picsa',
          debugShowCheckedModeBanner: false,
        );
      }),
    );
  }
}
