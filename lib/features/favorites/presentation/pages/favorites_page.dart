import 'package:flutter/material.dart';
import 'package:mysupercat/shared/data/local/favorites_db.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Map<String, dynamic>> favorites = [];

  Future<void> _loadFavorites() async {
    final data = await FavoritesDatabase.instance.getFavorites();
    setState(() {
      favorites = data;
    });
  }

  Future<void> _deleteFavorite(int id) async {
    await FavoritesDatabase.instance.deleteFavorite(id);
    _loadFavorites();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Favorite removed!')),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favorites')),
      body: favorites.isEmpty
          ? Center(child: Text('No favorites yet'))
          : ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final cat = favorites[index];
          return ListTile(
            title: Text(cat['name'] ?? 'Unknown'),
            subtitle: Text('Temperament: ${cat['temperament']}\n'
                'Intelligence: ${cat['intelligence']}'),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteFavorite(cat['id']),
            ),
          );
        },
      ),
    );
  }
}
