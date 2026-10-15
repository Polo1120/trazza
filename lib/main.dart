import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trazza/core/constants/env_constants.dart';
import 'package:trazza/core/router/app_router.dart';
import 'package:trazza/core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es_CO');
  await dotenv.load(fileName: '.env');

  await Supabase.initialize(
    url: EnvConstants.supabaseUrl,
    anonKey: EnvConstants.supabaseAnonKey,
  );

  runApp(
    const ProviderScope(
      child: TrazzaApp(),
    ),
  );
}

class TrazzaApp extends ConsumerWidget {
  const TrazzaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Trazza',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: ref.watch(appRouterProvider),
    );
  }
}
