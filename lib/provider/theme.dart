import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = true; // Initial state is dark mode

  // Initial colors and icon for dark mode
  Color _chngcolor = Color(0xff202124);
  Color _listcolor = Colors.black;
  Color _fontclr = Colors.white; // Changed to white for dark mode
  Color _altfontclr = Colors.purple;
  Icon _themeicon = const Icon(
    Icons.dark_mode_sharp,
    color: Colors.purple,
  );

  // Getters
  bool get isDarkMode => _isDarkMode;
  Color get chngcolor => _chngcolor;
  Color get listcolor => _listcolor;
  Color get fontclr => _fontclr;
  Color get altfontclt => _altfontclr;
  Icon get themeicon => _themeicon;

  // Toggle the theme and update colors
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    if (_isDarkMode) {
      _chngcolor = Color(0xff202124);
      _listcolor = Colors.black;
      _fontclr = Colors.white;
      _themeicon = const Icon(
        Icons.dark_mode_sharp,
        color: Colors.purple,
      );
    } else {
      _chngcolor = const Color.fromARGB(255, 255, 255, 255);
      _listcolor = const Color.fromARGB(255, 234, 234, 234);
      _fontclr = const Color.fromARGB(255, 115, 11, 134);
      _themeicon = const Icon(Icons.light_mode_sharp, color: Colors.purple);
    }
    notifyListeners(); // Notify listeners to rebuild with updated values
  }
}
