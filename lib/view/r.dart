// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
// import 'package:quraan/bloc/bloc_local_Reciters/local_reciters_bloc.dart';
// import 'package:quraan/bloc/bloc_local_Reciters/local_reciters_event.dart';
// import 'package:quraan/bloc/bloc_local_Reciters/local_reciters_state.dart';
// import 'package:quraan/bloc/bloc_quran/quran_bloc.dart';
// import 'package:quraan/bloc/bloc_reciters/reciters_bloc.dart';
// import 'package:quraan/bloc/bloc_reciters/reciters_event.dart';
// import 'package:quraan/bloc/bloc_reciters/reciters_state.dart';
// import 'package:quraan/bloc/internet_bloc/internet_bloc.dart';
// import 'package:quraan/bloc/internet_bloc/internet_state.dart';
// import 'package:quraan/bloc/localization_bloc/localization_bloc.dart';
// import 'package:quraan/bloc/localization_bloc/localization_event.dart';
// import 'package:quraan/bloc/localization_bloc/localization_state.dart';
// import 'package:quraan/database_helper.dart';
// import 'package:quraan/model/reciters_model.dart';
// import 'package:quraan/repository/quran_repository_arb.dart';
// import 'package:quraan/repository/local_reciters_repository.dart';
// import 'package:quraan/view/quran_page.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:quraan/generated/l10n.dart';
// import 'language_selection_dialog.dart';

// class RecitersScreen extends StatefulWidget {
//   const RecitersScreen({super.key});
//   static String? server;
//   static String? recitersName;
//   static String? rewayatName;
//   static Moshaf? listMoshaf;
//   static String? ReiterId;
//   static String? moshafTypeRewaya;
//   static Directory? directory;
//   static String? surah_list;

//   @override
//   State<RecitersScreen> createState() => _RecitersScreenState();
// }

// class _RecitersScreenState extends State<RecitersScreen> {
//   List<Reciter> reciters = [];
//   List<String> riwayatNames = [];
//   String? searchArabicInput = "";
//   final TextEditingController _searchTextEditingController =
//       TextEditingController();
//   bool _isSearching = false;
//   String? _selectedRiwayat;
//   bool? lastConnectionState;
//   SnackBar? currentSnackbar;
//   bool languageSelected = false;

//   @override
//   void initState() {
//     super.initState();
//     _checkLanguageSelection();
//   }

//   Future<void> _checkLanguageSelection() async {
//     final savedLanguage = await DatabaseHelper.instance.getLanguage();
//     if (savedLanguage == null) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         showDialog(
//           context: context,
//           barrierDismissible: false,
//           builder: (context) => const LanguageSelectionDialog(),
//         ).then((_) {
//           setState(() {
//             languageSelected = true;
//             _loadReciters();
//           });
//         });
//       });
//     } else {
//       setState(() {
//         languageSelected = true;
//         _loadReciters();
//       });
//     }
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     _initializeSelectedRiwayat();
//   }

//   void _initializeSelectedRiwayat() {
//     _selectedRiwayat = S.of(context).rewayatDefault;
//     RecitersScreen.rewayatName = _selectedRiwayat;
//   }

//   void _loadReciters() {
//     final language =
//         context.read<LocalizationBloc>().state.locale!.languageCode;
//     context.read<RecitersBloc>().add(LoadRecitersEvent(language));
//     context.read<LocalRecitersBloc>().add(LoadLocalRecitersEvent(language));
//   }

//   Future<String> get _localPath async {
//     RecitersScreen.directory = await getApplicationDocumentsDirectory();
//     return RecitersScreen.directory!.path;
//   }

//   void _startSearch() {
//     setState(() {
//       _isSearching = true;
//     });
//     _navigateLocallyToShowTextField();
//   }

//   void _stopSearch() {
//     _clearSearch();
//     setState(() {
//       _isSearching = false;
//     });
//   }

//   void _clearSearch() {
//     _searchTextEditingController.clear();
//   }

//   void addTypingLetters(String newSearchedValue) {
//     setState(() {
//       searchArabicInput = newSearchedValue;
//     });
//   }

//   Future<void> _navigateLocallyToShowTextField() async {
//     setState(() => _isSearching = true);
//     ModalRoute.of(context)
//         ?.addLocalHistoryEntry(LocalHistoryEntry(onRemove: () {
//       setState(() {
//         addTypingLetters('');
//         _isSearching = false;
//       });
//     }));
//   }

//   void _showCustomOverlay(
//       BuildContext context, ContentType type, String title, String message) {
//     final overlay = Overlay.of(context);
//     OverlayEntry? overlayEntry;

//     overlayEntry = OverlayEntry(
//       builder: (context) => Positioned(
//         bottom: 200, // الموقع الأوسط للشاشة
//         left: 10,
//         right: 10,
//         child: Material(
//           color: Colors.transparent,
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
//             child: Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(8.0),
//                 color: Colors.white,
//               ),
//               child: ListTile(
//                 leading: Icon(
//                   type == ContentType.success
//                       ? Icons.check_circle
//                       : Icons.warning,
//                   color: type == ContentType.success
//                       ? Colors.green
//                       : Colors.orange,
//                 ),
//                 title: Text(
//                   title,
//                   style: const TextStyle(
//                     fontSize: 16.0,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 subtitle: Text(
//                   message,
//                   style: const TextStyle(
//                     fontSize: 14.0,
//                   ),
//                 ),
//                 trailing: type == ContentType.success
//                     ? IconButton(
//                         icon: Icon(Icons.refresh, color: Colors.blue),
//                         onPressed: () {
//                           _refreshContent();
//                           overlayEntry?.remove();
//                         },
//                       )
//                     : null,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );

//     overlay?.insert(overlayEntry);

//     Future.delayed(
//       type == ContentType.warning
//           ? const Duration(days: 365)
//           : const Duration(seconds: 4),
//       () {
//         overlayEntry?.remove();
//       },
//     );
//   }

//   Future<void> _refreshContent() async {
//     _loadReciters();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: Localizations.localeOf(context).languageCode == 'ar'
//           ? TextDirection.rtl
//           : TextDirection.ltr,
//       child: Scaffold(
//         appBar: buildAppBar(),
//         bottomNavigationBar: buildBottomNavigationBar(),
//         body: languageSelected
//             ? buildBody()
//             : const Center(child: CircularProgressIndicator()),
//       ),
//     );
//   }

//   Widget buildBody() {
//     return Column(
//       children: [
//         BlocListener<InternetBloc, InternetState>(
//           listener: (context, state) {
//             bool isConnected = state is InternetConnected;
//             if (lastConnectionState != null &&
//                 isConnected != lastConnectionState) {
//               if (isConnected) {
//                 _showCustomOverlay(context, ContentType.success,
//                     S.of(context).connected, S.of(context).youConnected);
//               } else if (state is InternetDisconnected) {
//                 _showCustomOverlay(context, ContentType.warning,
//                     S.of(context).noConnection, S.of(context).younotConnected);
//               } else if (state is InternetNoConnection) {
//                 _showCustomOverlay(
//                     context,
//                     ContentType.warning,
//                     S.of(context).noInternet,
//                     S.of(context).connectedNoInternet);
//               }
//             }
//             lastConnectionState = isConnected;
//           },
//           child: Container(),
//         ),
//         BlocListener<LocalizationBloc, LocalizationState>(
//           listener: (context, state) {
//             setState(() {
//               _selectedRiwayat = S.of(context).rewayatDefault;
//             });
//             _loadReciters();
//           },
//           child: Container(),
//         ),
//         Expanded(
//           child: BlocBuilder<RecitersBloc, RecitersState>(
//             builder: (context, state) {
//               if (state is LoadingReciters) {
//                 return const Center(child: CircularProgressIndicator());
//               } else if (state is LoadedReciters) {
//                 reciters = state.reciters;
//                 riwayatNames = _getUniqueRiwayatNames(reciters);
//                 return _buildContent();
//               } else if (state is ErrorInLoadReciters) {
//                 return BlocBuilder<LocalRecitersBloc, LocalRecitersState>(
//                   builder: (context, localState) {
//                     if (localState is LoadingLocalReciters) {
//                       return const Center(child: CircularProgressIndicator());
//                     } else if (localState is LoadedLocalReciters) {
//                       reciters = localState.localreciters;
//                       riwayatNames = _getUniqueRiwayatNames(reciters);
//                       WidgetsBinding.instance.addPostFrameCallback((_) {
//                         _showCustomOverlay(
//                             context,
//                             ContentType.warning,
//                             S.of(context).offlineMode,
//                             S.of(context).viewingLocalContent);
//                       });
//                       return _buildContent();
//                     } else if (localState is ErrorInLoadLocalReciters) {
//                       return Center(child: Text(localState.errorMsg));
//                     } else {
//                       return const Center(child: Text('Unknown state'));
//                     }
//                   },
//                 );
//               } else {
//                 return const Center(child: Text('Unknown state'));
//               }
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   List<String> _getUniqueRiwayatNames(List<Reciter> reciters) {
//     Set<String> uniqueRiwayatNames = {};
//     for (var reciter in reciters) {
//       for (var moshaf in reciter.moshaf) {
//         if (moshaf.name != null && moshaf.name!.isNotEmpty) {
//           uniqueRiwayatNames.add(moshaf.name!);
//         }
//       }
//     }
//     return uniqueRiwayatNames.toList();
//   }

//   Widget _buildContent() {
//     List<Reciter> filteredReciters = reciters;
//     if (_selectedRiwayat != null && _selectedRiwayat!.isNotEmpty) {
//       filteredReciters = reciters.where((reciter) {
//         return reciter.moshaf.any((moshaf) {
//           return moshaf.name!.contains(_selectedRiwayat!);
//         });
//       }).toList();
//     }

//     return RefreshIndicator(
//       onRefresh: _refreshContent,
//       child: Container(
//         padding: const EdgeInsets.all(8),
//         child: Column(
//           children: [
//             Expanded(
//               child: ListView.builder(
//                 itemCount: filteredReciters.length,
//                 itemBuilder: (context, index) {
//                   final reciter = filteredReciters[index];
//                   return ReciterListItem(
//                     reciter: reciter,
//                     onReciterTap: _onReciterTap,
//                     isArabic:
//                         Localizations.localeOf(context).languageCode == 'ar',
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _onReciterTap(Reciter reciter, Moshaf moshaf) async {
//     RecitersScreen.recitersName = reciter.name.toString();
//     RecitersScreen.server = moshaf.server.toString();
//     RecitersScreen.rewayatName = moshaf.name.toString();
//     RecitersScreen.ReiterId = reciter.id.toString();
//     RecitersScreen.moshafTypeRewaya = moshaf.moshafType.toString();
//     RecitersScreen.directory = Directory(await _localPath);
//     String languageCode = Localizations.localeOf(context).languageCode;

//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) {
//           return RepositoryProvider<AudioQuranRepository>(
//             create: (context) => AudioQuranRepository(),
//             child: BlocProvider<AudioQuranBloc>(
//               create: (context) => AudioQuranBloc(
//                 context.read<AudioQuranRepository>(),
//               )..add(LoadAudioQuranEvent(languageCode: languageCode)),
//               child: QuranPage(),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   AppBar buildAppBar() {
//     return AppBar(
//       elevation: 10,
//       shadowColor: Colors.black.withOpacity(0.5),
//       backgroundColor: const Color(0xFF0277BD),
//       toolbarHeight: 120,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(
//           bottom: Radius.circular(5),
//         ),
//       ),
//       title: buildAppBarTitle(),
//       bottom: PreferredSize(
//         preferredSize: const Size.fromHeight(60.0),
//         child: Column(
//           children: [
//             buildSearchRow(),
//             buildLanguageButtons(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildSearchRow() {
//     return Directionality(
//       textDirection: Localizations.localeOf(context).languageCode == 'ar'
//           ? TextDirection.rtl
//           : TextDirection.ltr,
//       child: Row(
//         children: <Widget>[
//           if (_isSearching)
//             SizedBox(
//               width: 50,
//               child: IconButton(
//                 onPressed: () {
//                   setState(() {
//                     _clearSearch();
//                   });
//                   Navigator.of(context).pop();
//                 },
//                 icon: const Icon(Icons.clear, color: Colors.white),
//               ),
//             ),
//           _isSearching
//               ? Expanded(child: _buildTextFieldSearch())
//               : const SizedBox.shrink(),
//           const SizedBox(width: 20),
//         ],
//       ),
//     );
//   }

//   Center buildAppBarTitle() {
//     return Center(
//       child: SizedBox(
//         child: Row(
//           children: [
//             Column(
//               children: [
//                 const SizedBox(height: 15),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     !_isSearching
//                         ? Shimmer.fromColors(
//                             baseColor: Colors.black87,
//                             highlightColor: const Color(0xFFFFD700),
//                             child: Image.asset(
//                               "assets/ayah.png",
//                               color: Colors.black,
//                               height: 130,
//                               width: 130,
//                             ),
//                           )
//                         : const SizedBox.shrink(),
//                     Text(
//                       S.of(context).recitersList,
//                       style: GoogleFonts.tajawal(
//                         textStyle: const TextStyle(
//                           fontSize: 27,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       width: 55,
//                       height: 50,
//                       child: Row(
//                         children: [
//                           if (!_isSearching)
//                             IconButton(
//                               onPressed: _startSearch,
//                               icon:
//                                   const Icon(Icons.search, color: Colors.white),
//                             )
//                           else
//                             const SizedBox.square(),
//                           const SizedBox(width: 5),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTextFieldSearch() {
//     return SizedBox(
//       height: 40,
//       width: 200,
//       child: Directionality(
//         textDirection: Localizations.localeOf(context).languageCode == 'ar'
//             ? TextDirection.rtl
//             : TextDirection.ltr,
//         child: TextField(
//           cursorWidth: 1.0,
//           textDirection: TextDirection.rtl,
//           cursorColor: Colors.black,
//           autofocus: true,
//           controller: _searchTextEditingController,
//           decoration: InputDecoration(
//             contentPadding: const EdgeInsets.only(bottom: 5, right: 15),
//             hintText: S.of(context).search,
//             hintStyle:
//                 const TextStyle(fontSize: 16, overflow: TextOverflow.ellipsis),
//             filled: true,
//             fillColor: const Color.fromARGB(255, 202, 200, 200),
//             border: OutlineInputBorder(
//               borderSide: BorderSide.none,
//               borderRadius: BorderRadius.circular(50),
//             ),
//           ),
//           onChanged: (searchedValue) {
//             setState(() {});
//             addTypingLetters(searchedValue);
//           },
//         ),
//       ),
//     );
//   }

//   Widget buildLanguageButtons() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           PopupMenuButton(
//             icon: Icon(Icons.language, color: Colors.white, size: 18),
//             onSelected: (value) async {
//               if (value == 'eng') {
//                 // Update the locale
//                 context
//                     .read<LocalizationBloc>()
//                     .add(ChangeLocale(const Locale('eng')));
//                 setState(() {
//                   _selectedRiwayat = S.of(context).rewayatDefault;
//                 });
//                 // Save the selected language in the database
//                 await DatabaseHelper.instance.saveLanguage('eng');
//               } else if (value == 'ar') {
//                 // Update the locale
//                 context
//                     .read<LocalizationBloc>()
//                     .add(ChangeLocale(const Locale('ar')));
//                 setState(() {
//                   _selectedRiwayat = S.of(context).rewayatDefault;
//                 });
//                 // Save the selected language in the database
//                 await DatabaseHelper.instance.saveLanguage('ar');
//               }
//             },
//             itemBuilder: (BuildContext context) => <PopupMenuEntry>[
//               PopupMenuItem(
//                 value: 'eng',
//                 child: Row(
//                   children: [
//                     Text('English', style: GoogleFonts.tajawal()),
//                   ],
//                 ),
//               ),
//               PopupMenuItem(
//                 value: 'ar',
//                 child: Row(
//                   children: [
//                     Text('العربية', style: GoogleFonts.tajawal()),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildBottomNavigationBar() {
//     return Container(
//       decoration: const BoxDecoration(
//         color: Color(0xFF0277BD),
//         borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
//       ),
//       height: 60.0,
//       child: Padding(
//         padding: const EdgeInsets.only(right: 8),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               S.of(context).recitersList,
//               style: GoogleFonts.tajawal(
//                 textStyle: const TextStyle(
//                     fontSize: 20,
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold),
//               ),
//             ),
//             SizedBox(width: 250, child: buildRiwayatFilter()),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildRiwayatFilter() {
//     return PopupMenuButton<String>(
//       onSelected: (String newValue) {
//         setState(() {
//           RecitersScreen.rewayatName = newValue;
//           _selectedRiwayat = newValue;
//         });
//       },
//       itemBuilder: (BuildContext context) {
//         return riwayatNames.map<PopupMenuItem<String>>((String value) {
//           return PopupMenuItem<String>(
//             value: value,
//             child: Row(
//               children: [
//                 Flexible(
//                   child: Directionality(
//                     textDirection:
//                         Localizations.localeOf(context).languageCode == 'ar'
//                             ? TextDirection.rtl
//                             : TextDirection.ltr,
//                     child: Text(
//                       value,
//                       style: GoogleFonts.tajawal(
//                           color: Colors.black, fontWeight: FontWeight.bold),
//                       softWrap: true,
//                       overflow: TextOverflow.visible,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }).toList();
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//         decoration: BoxDecoration(
//           border: Border.all(color: const Color(0xFF0277BD)),
//           borderRadius: BorderRadius.circular(5),
//         ),
//         child: Row(
//           children: [
//             Flexible(
//               child: Text(
//                 _selectedRiwayat ?? S.of(context).recitersList,
//                 style: GoogleFonts.tajawal(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 10),
//                 softWrap: true,
//                 overflow: TextOverflow.visible,
//               ),
//             ),
//             const Icon(Icons.arrow_drop_down, color: Colors.white, size: 22),
//           ],
//         ),
//       ),
//       color: const Color(0xFF0277BD),
//     );
//   }
// }

// class ReciterListItem extends StatelessWidget {
//   final Reciter reciter;
//   final Function(Reciter, Moshaf) onReciterTap;
//   final bool isArabic;

//   const ReciterListItem({
//     Key? key,
//     required this.reciter,
//     required this.onReciterTap,
//     required this.isArabic,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//         children: reciter.moshaf
//             .where((moshaf) =>
//                 RecitersScreen.rewayatName == null ||
//                 RecitersScreen.rewayatName!.isEmpty ||
//                 moshaf.name!.contains(RecitersScreen.rewayatName!))
//             .map((moshaf) {
//       return Directionality(
//         textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
//         child: ListTile(
//           title: Text(
//             reciter.name ?? '',
//             style:
//                 GoogleFonts.tajawal(fontSize: 16, fontWeight: FontWeight.bold),
//           ),
//           subtitle: Text(
//             moshaf.name ?? '',
//             style: GoogleFonts.tajawal(fontSize: 14),
//           ),
//           onTap: () => onReciterTap(reciter, moshaf),
//         ),
//       );
//     }).toList());
//   }
// }
