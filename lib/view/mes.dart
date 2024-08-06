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
//   int _selectedIndex = 0; // For bottom navigation bar
//   List<Map<String, String>> favoriteReciterIds = [];
//   int? _selectedRiwayatId;
//   OverlayEntry? _currentOverlayEntry;

//   @override
//   void initState() {
//     super.initState();
//     _checkLanguageSelection();
//   }

//   void _checkLanguageSelection() async {
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
//             _loadInitialData();
//           });
//         });
//       });
//     } else {
//       setState(() {
//         languageSelected = true;
//         _loadInitialData();
//       });
//     }
//   }

//   void _loadInitialData() {
//     _loadReciters();
//     _loadFavorites();
//   }

//   void _loadReciters() async {
//     final language = context.read<LocalizationBloc>().state.locale.languageCode;
//     print("language  $language");

//     context.read<LocalRecitersBloc>().add(LoadLocalRecitersEvent(language));
//   }

//   Future<void> _loadFavorites() async {
//     List<Map<String, String>> favoritesData =
//         await DatabaseHelper.instance.getFavorites();
//     print("Favorites data: $favoritesData"); // تحقق من البيانات المحملة

//     setState(() {
//       print("hhhhhhhhhhhhhhhhhhhhhhh");
//       favoriteReciterIds = favoritesData
//           .map((data) => {
//                 'reciterId': data['reciterId']!,
//                 'moshafId': data['moshafId']!,
//               })
//           .toList();
//       print("Loaded favorites: $favoriteReciterIds");
//     });
//   }

//   //////

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     _initializeSelectedRiwayat();
//   }

//   void _initializeSelectedRiwayat() {
//     _selectedRiwayat = S.of(context).rewayatDefault;
//     RecitersScreen.rewayatName = _selectedRiwayat;
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
//     // Dismiss the current overlay if it exists
//     _dismissCurrentOverlay();

//     // Only show the overlay for warning messages (no internet connection)
//     if (type == ContentType.warning) {
//       // Create and show new overlay
//       _currentOverlayEntry = _createOverlayEntry(context, type, title, message);
//       Overlay.of(context)?.insert(_currentOverlayEntry!);
//     }
//   }

//   void _dismissCurrentOverlay() {
//     if (_currentOverlayEntry != null) {
//       _currentOverlayEntry!.remove();
//       _currentOverlayEntry = null;
//     }
//   }

//   OverlayEntry _createOverlayEntry(
//       BuildContext context, ContentType type, String title, String message) {
//     return OverlayEntry(
//       builder: (context) => Stack(
//         children: [
//           Positioned(
//             top: MediaQuery.of(context).size.height / 2 +
//                 100, // 100 pixels below the center
//             left: MediaQuery.of(context).size.width * 0.1,
//             width: MediaQuery.of(context).size.width * 0.8,
//             child: Material(
//               color: Colors.transparent,
//               child: Container(
//                 padding:
//                     const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(8.0),
//                   boxShadow: const [
//                     BoxShadow(
//                       color: Colors.black26,
//                       blurRadius: 10.0,
//                       offset: Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       Icons.warning,
//                       color: Color(0xFF0277BD),
//                       size: 30.0,
//                     ),
//                     const SizedBox(width: 10.0),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Text(
//                             title,
//                             style: TextStyle(
//                               color: Color(0xFF0277BD),
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16.0,
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                           const SizedBox(height: 5.0),
//                           Text(
//                             message,
//                             style: TextStyle(
//                               color: Color(0xFF0277BD),
//                               fontSize: 14.0,
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _refreshContent() async {
//     _loadReciters();
//     _loadFavorites();
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

//   Widget buildRecitersList() {
//     return Column(
//       children: [
//         BlocListener<InternetBloc, InternetState>(
//           listener: (context, state) {
//             if (state is InternetDisconnected ||
//                 state is InternetNoConnection) {
//               // إلغاء الرسالة السابقة إذا كانت موجودة
//               _dismissCurrentOverlay();

//               // عرض الرسالة عند عدم وجود اتصال
//               _showCustomOverlay(
//                   context,
//                   ContentType.warning,
//                   S.of(context).alert, // العنوان للرسالة
//                   S
//                       .of(context)
//                       .internetConnectionState // الرسالة لحالة عدم الاتصال
//                   );
//             } else if (state is InternetConnected) {
//               // إلغاء الرسالة إذا كان الاتصال قد عاد
//               _dismissCurrentOverlay();
//             }

//             // تحديث حالة الاتصال السابقة
//             lastConnectionState = state is InternetConnected;
//           },
//           child: Container(),
//         ),
//         Expanded(
//           child: BlocBuilder<LocalRecitersBloc, LocalRecitersState>(
//             builder: (context, localState) {
//               if (localState is LoadingLocalReciters) {
//                 return const Center(child: CircularProgressIndicator());
//               } else if (localState is LoadedLocalReciters) {
//                 reciters = localState.localreciters;
//                 riwayatNames = _getUniqueRiwayatNames(reciters);

//                 return _buildRecitersList();
//               } else if (localState is ErrorInLoadLocalReciters) {
//                 return Center(child: Text(localState.errorMsg));
//               } else {
//                 return const Center(child: Text('Unknown state'));
//               }
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget buildBody() {
//     return _selectedIndex == 0
//         ? buildRecitersList()
//         : buildFavoriteRecitersList();
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

//   List<String> _getallFavNames(List<Reciter> reciters) {
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

//   Widget _buildRecitersList() {
//     // Sort the reciters list alphabetically by reciter's name
//     reciters.sort((a, b) => a.name!.compareTo(b.name!));

//     // Filter the reciters list based on the selected riwayat and search input
//     List<Reciter> filteredReciters = reciters.where((reciter) {
//       return reciter.moshaf.any((moshaf) {
//         return moshaf.name == _selectedRiwayat &&
//             reciter.name!
//                 .toLowerCase()
//                 .startsWith(searchArabicInput!.toLowerCase());
//       });
//     }).toList();

//     return RefreshIndicator(
//       onRefresh: _refreshContent,
//       child: Container(
//         padding: const EdgeInsets.all(8),
//         child: ListView.builder(
//           itemCount: filteredReciters.length,
//           itemBuilder: (context, index) {
//             final reciter = filteredReciters[index];
//             return Column(
//               children: reciter.moshaf.map((moshaf) {
//                 // Check if the current moshaf matches the selected riwayat
//                 if (moshaf.name != _selectedRiwayat) {
//                   return SizedBox
//                       .shrink(); // Skip other moshaf not matching the selected riwayat
//                 }
//                 final isFavorite = favoriteReciterIds.any((favorite) =>
//                     favorite['reciterId'] == reciter.id.toString() &&
//                     favorite['moshafId'] == moshaf.id.toString());

//                 return ReciterListItem(
//                   reciter: reciter,
//                   moshaf: moshaf,
//                   onReciterTap: _onReciterTap,
//                   isArabic:
//                       Localizations.localeOf(context).languageCode == 'ar',
//                   isFavorite: isFavorite,
//                   onFavoriteToggle: _toggleFavorite,
//                 );
//               }).toList(),
//             );
//           },
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
//       toolbarHeight: 140,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(
//           bottom: Radius.circular(5),
//         ),
//       ),
//       title: buildAppBarTitle(),
//       bottom: PreferredSize(
//         preferredSize: const Size.fromHeight(70.0),
//         child: Column(
//           children: [
//             buildSearchRow(),
//             buildLanguageButtons(),
//             if (_selectedIndex != 1) // إخفاء الفلتر في المفضلة
//               Container(
//                 decoration: const BoxDecoration(
//                   color: Color(0xFF0277BD),
//                   borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
//                 ),
//                 height: 10.0,
//               ),
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
//                     SizedBox(
//                       width: 150,
//                       child: Column(
//                         children: [
//                           SizedBox(
//                             height: 20,
//                           ),
//                           Text(
//                             S.of(context).recitersList,
//                             style: GoogleFonts.tajawal(
//                               textStyle: const TextStyle(
//                                 fontSize: 27,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                           SizedBox(width: 200, child: buildRiwayatFilter()),
//                         ],
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
//               } else if (value == 'fr') {
//                 // Update the locale
//                 context
//                     .read<LocalizationBloc>()
//                     .add(ChangeLocale(const Locale('fr')));
//                 setState(() {
//                   _selectedRiwayat = S.of(context).rewayatDefault;
//                 });
//                 // Save the selected language in the database
//                 await DatabaseHelper.instance.saveLanguage('fr');
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
//               PopupMenuItem(
//                 value: 'fr',
//                 child: Row(
//                   children: [
//                     Text('Français', style: GoogleFonts.tajawal()),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
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

//   Widget buildBottomNavigationBar() {
//     return BottomNavigationBar(
//       items: [
//         BottomNavigationBarItem(
//           icon: Icon(Icons.list),
//           label: S
//               .of(context)
//               .recitersList, // يمكنك استخدام S.of(context).recitersList إذا كنت تفضل ذلك
//         ),
//         BottomNavigationBarItem(
//             icon: Icon(Icons.favorite), label: S.of(context).Favorites),
//       ],
//       currentIndex: _selectedIndex,
//       onTap: (index) {
//         setState(() {
//           _selectedIndex = index;
//           _loadReciters();
//           _loadFavorites();
//         });
//       },
//       selectedItemColor: Colors.white,
//       backgroundColor: const Color(0xFF0277BD),
//       unselectedItemColor: Colors.white54,
//       selectedLabelStyle: GoogleFonts.tajawal(
//         fontSize: 14,
//         fontWeight: FontWeight.bold,
//       ),
//       unselectedLabelStyle: GoogleFonts.tajawal(
//         fontSize: 12,
//         fontWeight: FontWeight.normal,
//       ),
//     );
//   }

//   Widget buildFavoriteRecitersList() {
//     return Column(
//       children: [
//         Expanded(
//           child: BlocBuilder<LocalRecitersBloc, LocalRecitersState>(
//             builder: (context, localState) {
//               if (localState is LoadingLocalReciters) {
//                 return const Center(child: CircularProgressIndicator());
//               } else if (localState is LoadedLocalReciters) {
//                 reciters = localState.localreciters;

//                 // تصفية المقرئين والمصاحف لعرض المفضلين فقط
//                 List<Map<String, dynamic>> favoriteRecitersAndMoshaf = [];
//                 for (var reciter in reciters) {
//                   for (var moshaf in reciter.moshaf) {
//                     // تحقق مما إذا كان المقرئ والمصحف موجودين في قائمة المفضلات
//                     if (favoriteReciterIds.any((favorite) =>
//                         favorite['reciterId'] == reciter.id.toString() &&
//                         favorite['moshafId'] == moshaf.id.toString())) {
//                       favoriteRecitersAndMoshaf.add({
//                         'reciter': reciter,
//                         'moshaf': moshaf,
//                       });
//                     }
//                   }
//                 }

//                 return _buildFavoriteRecitersList(favoriteRecitersAndMoshaf);
//               } else if (localState is ErrorInLoadLocalReciters) {
//                 return Center(child: Text(localState.errorMsg));
//               } else {
//                 return const Center(child: Text('Unknown state'));
//               }
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildFavoriteRecitersList(
//       List<Map<String, dynamic>> favoriteRecitersAndMoshaf) {
//     if (favoriteRecitersAndMoshaf.isEmpty) {
//       return Center(
//         child: Text(
//           S.of(context).NoFavorites,
//           style: GoogleFonts.tajawal(
//             textStyle: const TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       );
//     }

//     return RefreshIndicator(
//       onRefresh: _refreshContent,
//       child: ListView.builder(
//         itemCount: favoriteRecitersAndMoshaf.length,
//         itemBuilder: (context, index) {
//           final reciter =
//               favoriteRecitersAndMoshaf[index]['reciter'] as Reciter;
//           final moshaf = favoriteRecitersAndMoshaf[index]['moshaf'] as Moshaf;

//           return FavoriteReciterListItem(
//             reciter: reciter,
//             moshaf: moshaf,
//             onReciterTap: _onReciterTap,
//             isArabic: Localizations.localeOf(context).languageCode == 'ar',
//             isFavorite: true,
//             onFavoriteToggle: (reciter, moshaf) =>
//                 _toggleFavorite(reciter, moshaf),
//           );
//         },
//       ),
//     );
//   }

//   ///////

//   void _toggleFavorite(Reciter reciter, Moshaf moshaf) async {
//     String reciterId = reciter.id.toString();
//     String moshafId = moshaf.id.toString();

//     // تحقق مما إذا كانت المفضلة موجودة في القائمة
//     var favorite = favoriteReciterIds.firstWhere(
//       (fav) => fav['reciterId'] == reciterId && fav['moshafId'] == moshafId,
//       orElse: () => {},
//     );

//     if (favorite.isNotEmpty) {
//       // إزالة المفضلة من قاعدة البيانات
//       await DatabaseHelper.instance.removeFavorite(reciterId, moshafId);
//       // إزالة المفضلة من القائمة المحلية
//       favoriteReciterIds.remove(favorite);
//       print("Removed from favorites: ${reciter.name} (Moshaf: ${moshaf.name})");
//     } else {
//       // إضافة المفضلة إلى قاعدة البيانات
//       await DatabaseHelper.instance.addFavorite(reciterId, moshafId);
//       // إضافة المفضلة إلى القائمة المحلية
//       favoriteReciterIds.add({'reciterId': reciterId, 'moshafId': moshafId});
//       print("Added to favorites: ${reciter.name} (Moshaf: ${moshaf.name})");
//     }

//     // تحديث واجهة المستخدم
//     setState(() {
//       print("Current favorites: $favoriteReciterIds");
//     });
//   }
// }

// class ReciterListItem extends StatelessWidget {
//   final Reciter reciter;
//   final Moshaf moshaf; // الموشاف الممرر
//   final Function(Reciter, Moshaf) onReciterTap;
//   final bool isArabic;
//   final bool isFavorite;
//   final Function(Reciter, Moshaf) onFavoriteToggle;

//   const ReciterListItem({
//     Key? key,
//     required this.reciter,
//     required this.moshaf,
//     required this.onReciterTap,
//     required this.isArabic,
//     required this.isFavorite,
//     required this.onFavoriteToggle,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
//       child: ListTile(
//         key: ValueKey('${reciter.id}-${moshaf.id}'), // مفتاح فريد لكل عنصر
//         title: Text(
//           reciter.name ?? '',
//           style: GoogleFonts.tajawal(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         subtitle: Text(
//           moshaf.name ?? '',
//           style: GoogleFonts.tajawal(fontSize: 12),
//         ),
//         onTap: () => onReciterTap(reciter, moshaf),
//         trailing: IconButton(
//           icon: Icon(
//             isFavorite ? Icons.favorite : Icons.favorite_border,
//             color: isFavorite ? Colors.red : const Color(0xFF0277BD),
//             size: 16,
//           ),
//           onPressed: () => onFavoriteToggle(reciter, moshaf),
//         ),
//       ),
//     );
//   }
// }

// class FavoriteReciterListItem extends StatelessWidget {
//   final Reciter reciter;
//   final Moshaf moshaf; // الموشاف الممرر
//   final Function(Reciter, Moshaf) onReciterTap;
//   final bool isArabic;
//   final bool isFavorite;
//   final Function(Reciter, Moshaf) onFavoriteToggle;

//   const FavoriteReciterListItem({
//     Key? key,
//     required this.reciter,
//     required this.moshaf,
//     required this.onReciterTap,
//     required this.isArabic,
//     required this.isFavorite,
//     required this.onFavoriteToggle,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
//       child: ListTile(
//         key: ValueKey('${reciter.id}-${moshaf.id}'), // مفتاح فريد لكل عنصر
//         title: Text(
//           reciter.name ?? '',
//           style: GoogleFonts.tajawal(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         subtitle: Text(
//           moshaf.name ?? '',
//           style: GoogleFonts.tajawal(fontSize: 14),
//         ),
//         onTap: () => onReciterTap(reciter, moshaf),
//         trailing: IconButton(
//           icon: Icon(
//             isFavorite ? Icons.favorite : Icons.favorite_border,
//             color: isFavorite ? Colors.red : const Color(0xFF0277BD),
//             size: 16,
//           ),
//           onPressed: () => onFavoriteToggle(reciter, moshaf),
//         ),
//       ),
//     );
//   }
// }
