import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:picsa/ui/authentication/welcome_page.dart';
import 'package:picsa/ui/home.dart';
import 'package:picsa/utilities/app_themes.dart';
import 'package:picsa/utilities/router_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'domain/blocs/app_functionality/auth/authentication/authentication_cubit.dart';
import 'domain/blocs/app_functionality/camera/camera_cubit.dart';
import 'utilities/common_widgets/loading_circle.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://pvotaaukwfeabaqtahfu.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InB2b3RhYXVrd2ZlYWJhcXRhaGZ1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDI5OTQwMDcsImV4cCI6MjAxODU3MDAwN30.Xv5gQJklMkH9NKq222NHYdGLlE722QemDe8__Bg2pl4',
    authOptions: const FlutterAuthClientOptions(
      autoRefreshToken: false,
    ),
    debug: false  ,
    storageOptions: const StorageClientOptions(
      retryAttempts: 3,
    )
  );
  final directory = await getApplicationDocumentsDirectory();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: directory,
  );
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthenticationCubit()..appStarted(),
          lazy: false,
        ),
        BlocProvider(
          create: (context) => CameraCubit()..initialize(),
          lazy: false,
        ),
      ],
      child: MaterialApp.router(
        darkTheme: darkTheme,
        
        themeMode: ThemeMode.dark,
        routerConfig: appRouter,
        title: 'Picsa',
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class Checker extends StatelessWidget {
  const Checker({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationCubit, AuthenticationState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return const Home();
        } else if (state is UnAuthenticated) {
          return const WelcomePage();
        } else {
          return const Scaffold(
            body: Center(child: LoadingCircle()),
          );
        }
      },
    );
  }
}
