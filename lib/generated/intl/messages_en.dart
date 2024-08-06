// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "Favorites": MessageLookupByLibrary.simpleMessage("Favorites"),
        "Nofavorites": MessageLookupByLibrary.simpleMessage("No favorites"),
        "alert": MessageLookupByLibrary.simpleMessage("Alert"),
        "connected": MessageLookupByLibrary.simpleMessage("Connected"),
        "connectedNoInternet": MessageLookupByLibrary.simpleMessage(
            "Connected but no internet access"),
        "error": MessageLookupByLibrary.simpleMessage("Error"),
        "internetConnectionRecommended": MessageLookupByLibrary.simpleMessage(
            "Please check your internet connection"),
        "internetConnectionState": MessageLookupByLibrary.simpleMessage(
            "Internet connection is currently unavailable"),
        "noConnection": MessageLookupByLibrary.simpleMessage("No Connection"),
        "noInternet": MessageLookupByLibrary.simpleMessage("No Internet"),
        "reciterVoice":
            MessageLookupByLibrary.simpleMessage("Reciter\'s Voice"),
        "recitersList": MessageLookupByLibrary.simpleMessage("Reciters List"),
        "recitersListBottom":
            MessageLookupByLibrary.simpleMessage("Reciters List:"),
        "rewayatDefault": MessageLookupByLibrary.simpleMessage(
            "Rewayat Hafs A\'n Assem - Murattal"),
        "search": MessageLookupByLibrary.simpleMessage("Search"),
        "success": MessageLookupByLibrary.simpleMessage("Success"),
        "youConnected": MessageLookupByLibrary.simpleMessage(
            "You are connected to the internet"),
        "younotConnected": MessageLookupByLibrary.simpleMessage(
            "You are not connected to the internet")
      };
}
