import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = true; // Initial state is dark mode

  // Initial colors and icon for dark mode
  Color _chngcolor = const Color.fromARGB(255, 21, 21, 21);
  Color _listcolor = Colors.black;
  Color _fontclr = Colors.white; // Changed to white for dark mode
  Brightness _statusbariconcolor = Brightness.dark; // Light icons for dark mode
  Icon _themeicon = const Icon(
    Icons.dark_mode_sharp,
    color: Colors.white,
  );

  // Getters
  bool get isDarkMode => _isDarkMode;
  Color get chngcolor => _chngcolor;
  Color get listcolor => _listcolor;
  Color get fontclr => _fontclr;
  Brightness get statusbariconcolor => _statusbariconcolor;
  Icon get themeicon => _themeicon;

  // Toggle the theme and update colors
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    if (_isDarkMode) {
      _chngcolor = const Color.fromARGB(255, 21, 21, 21);
      _listcolor = Colors.black;
      _fontclr = Colors.white;
      _statusbariconcolor = Brightness.light; // Light icons for dark mode
      _themeicon = const Icon(Icons.dark_mode_sharp);
    } else {
      _chngcolor = const Color.fromARGB(255, 255, 255, 255);
      _listcolor = const Color.fromARGB(255, 219, 219, 219);
      _fontclr = Colors.black;
      _statusbariconcolor = Brightness.dark; // Dark icons for light mode
      _themeicon = const Icon(Icons.light_mode_sharp, color: Colors.black);
    }
    notifyListeners(); // Notify listeners to rebuild with updated values
  }
}
