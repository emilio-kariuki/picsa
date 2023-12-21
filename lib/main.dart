import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:picsa/blocs/app_functionality/camera/camera_cubit.dart';
import 'package:picsa/utilities/router_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://pvotaaukwfeabaqtahfu.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InB2b3RhYXVrd2ZlYWJhcXRhaGZ1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDI5OTQwMDcsImV4cCI6MjAxODU3MDAwN30.Xv5gQJklMkH9NKq222NHYdGLlE722QemDe8__Bg2pl4',
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
    return BlocProvider(
      create: (context) => CameraCubit()..initialize(),
      child: MaterialApp.router(
        theme: ThemeData.dark(),
        routerConfig: appRouter,
        title: 'Picsa',
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
