import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quraan/bloc/internet_bloc/internet_bloc.dart';
import 'package:quraan/bloc/internet_bloc/internet_event.dart';
import 'package:quraan/bloc/localization_bloc/localization_bloc.dart';
import 'package:quraan/bloc/localization_bloc/localization_event.dart';
import 'package:quraan/bloc/localization_bloc/localization_state.dart';
import 'package:quraan/view/reciters_screen.dart';
import 'package:quraan/bloc/bloc_local_Reciters/local_reciters_bloc.dart';
import 'package:quraan/repository/local_reciters_repository.dart';
import 'package:quraan/repository/quran_repository_arb.dart';
import 'package:quraan/generated/l10n.dart';
import 'package:quraan/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = DatabaseHelper.instance;
  final savedLanguage = await db.getLanguage();

  runApp(MyApp(savedLanguage: savedLanguage));
}

class MyApp extends StatelessWidget {
  final String? savedLanguage;

  const MyApp({super.key, this.savedLanguage});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AudioQuranRepository>(
          create: (context) => AudioQuranRepository(),
        ),
        RepositoryProvider<LocalRecitersRepository>(
          create: (context) => LocalRecitersRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<InternetBloc>(
            create: (context) {
              return InternetBloc()..add(CheckInternet());
            },
          ),
          BlocProvider<LocalRecitersBloc>(
            create: (context) {
              return LocalRecitersBloc(context.read<LocalRecitersRepository>());
            },
          ),
          BlocProvider<LocalizationBloc>(
            create: (context) => LocalizationBloc()
              ..add(ChangeLocale(
                savedLanguage != null
                    ? Locale(savedLanguage!)
                    : const Locale('ar'),
              )),
          ),
        ],
        child: BlocBuilder<LocalizationBloc, LocalizationState>(
          builder: (context, state) {
            final locale = state.locale;
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              locale: locale,
              supportedLocales: S.delegate.supportedLocales,
              localizationsDelegates: const [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              home: const RecitersScreen(),
            );
          },
        ),
      ),
    );
  }
}
