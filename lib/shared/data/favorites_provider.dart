import 'package:flutter/material.dart';

class FavoritesProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _favorites = [];

  List<Map<String, dynamic>> get favorites => _favorites;

  void addFavorite(Map<String, dynamic> cat) {
    if (!_favorites.contains(cat)) {
      _favorites.add(cat);
      notifyListeners();
    }
  }

  void removeFavorite(Map<String, dynamic> cat) {
    _favorites.remove(cat);
    notifyListeners();
  }

  bool isFavorite(Map<String, dynamic> cat) {
    return _favorites.contains(cat);
  }
}
