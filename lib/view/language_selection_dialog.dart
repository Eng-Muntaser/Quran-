import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:quraan/bloc/localization_bloc/localization_bloc.dart';
import 'package:quraan/bloc/localization_bloc/localization_event.dart';
import 'package:quraan/database_helper.dart';

class LanguageSelectionDialog extends StatelessWidget {
  const LanguageSelectionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Shimmer.fromColors(
          baseColor: Colors.black87,
          highlightColor: const Color(0xFFFFD700),
          child: Image.asset(
            "assets/ayah.png",
            color: Colors.black,
            height: 130,
            width: 130,
          ),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Center(
              child: Text(
                'العربية',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 19,
                ),
              ),
            ),
            onTap: () async {
              context
                  .read<LocalizationBloc>()
                  .add(const ChangeLocale(Locale('ar')));
              await DatabaseHelper.instance.saveLanguage('ar');
              Navigator.of(context).pop();
            },
          ),
          const Divider(color: Colors.white),
          ListTile(
            title: const Center(
              child: Text(
                'English',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            onTap: () async {
              context
                  .read<LocalizationBloc>()
                  .add(const ChangeLocale(Locale('eng')));
              await DatabaseHelper.instance.saveLanguage('eng');
              Navigator.of(context).pop();
            },
          ),
          const Divider(color: Colors.white),
          ListTile(
            title: const Center(
              child: Text(
                'Français',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            onTap: () async {
              context
                  .read<LocalizationBloc>()
                  .add(const ChangeLocale(Locale('fr')));
              await DatabaseHelper.instance.saveLanguage('fr');
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      backgroundColor: const Color(0xFF0277BD),
      contentPadding: const EdgeInsets.all(20),
    );
  }
}
