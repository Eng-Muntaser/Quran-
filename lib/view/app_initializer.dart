// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:quraan/view/language_selection_dialog.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:shared_preferences/shared_preferences.dart'; // Add this import
// import 'package:quraan/bloc/internet_bloc/internet_bloc.dart';
// import 'package:quraan/bloc/internet_bloc/internet_event.dart';
// import 'package:quraan/bloc/localization_bloc/localization_bloc.dart';
// import 'package:quraan/bloc/localization_bloc/localization_event.dart';
// import 'package:quraan/bloc/localization_bloc/localization_state.dart';
// import 'package:quraan/view/reciters_screen.dart';
// import 'package:quraan/bloc/bloc_local_Reciters/local_reciters_bloc.dart';
// import 'package:quraan/bloc/bloc_quran/quran_bloc.dart';
// import 'package:quraan/bloc/bloc_reciters/reciters_bloc.dart';
// import 'package:quraan/repository/local_reciters_repository.dart';
// import 'package:quraan/repository/quran_repository_arb.dart';
// import 'package:quraan/repository/reciters_repository.dart';
// import 'package:quraan/generated/l10n.dart'; // Import the generated localization files// Add this import

// import 'package:flutter/material.dart';

// import 'package:flutter_bloc/flutter_bloc.dart';

// import 'package:flutter/material.dart';

// import 'package:flutter_bloc/flutter_bloc.dart';

// class AppInitializer extends StatelessشWidget {
//   final Widget child;

//   const AppInitializer({Key? key, required this.child}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<Locale?>(
//       future: LocalizationBloc.loadInitialLocale(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         } else {
//           final initialLocale = snapshot.data;
//           if (initialLocale != null) {
//             return BlocProvider(
//               create: (context) => LocalizationBloc(initialLocale),
//               child: child,
//             );
//           } else {
//             return MaterialApp(
//               debugShowCheckedModeBanner: false,
//               supportedLocales: S.delegate.supportedLocales,
//               localizationsDelegates: const [
//                 S.delegate,
//                 GlobalMaterialLocalizations.delegate,
//                 GlobalWidgetsLocalizations.delegate,
//                 GlobalCupertinoLocalizations.delegate,
//               ],
//               home: const LanguageSelectionScreen(),
//             );
//           }
//         }
//       },
//     );
//   }
// }
