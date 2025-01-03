import 'package:flutter/material.dart';
import 'package:mysupercat/features/show/data/remote/cat_service.dart';
import 'package:mysupercat/features/show/presentation/pages/cat_details_page.dart';
import 'package:mysupercat/shared/data/local/favorites_db.dart';

class ShowPage extends StatefulWidget {
  @override
  _ShowPageState createState() => _ShowPageState();
}

class _ShowPageState extends State<ShowPage> {
  final CatService _catService = CatService();
  late Future<List<dynamic>> _catBreeds;

  // Lista de favoritos (por ID)
  Set<String> favoriteIds = {};

  @override
  void initState() {
    super.initState();
    _catBreeds = _catService.fetchCatBreeds();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final favorites = await FavoritesDatabase.instance.getFavorites();
    setState(() {
      favoriteIds = favorites.map((cat) => cat['reference_image_id'] as String).toSet();
    });
  }

  Future<void> _toggleFavorite(Map<String, dynamic> breed) async {
    final referenceId = breed['reference_image_id'];

    if (favoriteIds.contains(referenceId)) {
      // Si ya es favorito, eliminarlo
      final favorites = await FavoritesDatabase.instance.getFavorites();
      final catToRemove = favorites.firstWhere(
            (cat) => cat['reference_image_id'] == referenceId,
        orElse: () => {},
      );

      if (catToRemove.isNotEmpty) {
        await FavoritesDatabase.instance.deleteFavorite(catToRemove['id']);
        setState(() {
          favoriteIds.remove(referenceId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${breed['name']} removed from favorites!')),
        );
      }
    } else {
      // Si no es favorito, agregarlo
      final cat = {
        'name': breed['name'],
        'temperament': breed['temperament'] ?? 'Unknown',
        'intelligence': breed['intelligence'] ?? 0,
        'reference_image_id': referenceId,
      };

      await FavoritesDatabase.instance.addFavorite(cat);
      setState(() {
        favoriteIds.add(referenceId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${breed['name']} added to favorites!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cat Breeds')),
      body: FutureBuilder<List<dynamic>>(
        future: _catBreeds,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load cat breeds'));
          } else if (snapshot.hasData) {
            final breeds = snapshot.data!;
            return ListView.builder(
              itemCount: breeds.length,
              itemBuilder: (context, index) {
                final breed = breeds[index];
                final referenceId = breed['reference_image_id'] ?? '';

                return Card(
                  child: ListTile(
                    leading: breed['image'] != null
                        ? Image.network(
                      breed['image']['url'],
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    )
                        : Icon(Icons.pets),
                    title: Text(breed['name'] ?? 'Unknown'),
                    subtitle: Text(breed['origin'] ?? 'Unknown'),
                    trailing: IconButton(
                      icon: Icon(
                        favoriteIds.contains(referenceId)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: favoriteIds.contains(referenceId) ? Colors.red : null,
                      ),
                      onPressed: () => _toggleFavorite(breed),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CatDetailsPage(breed: breed),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
