import 'package:flutter/material.dart';
import 'package:mysupercat/shared/data/local/favorites_db.dart';

class CatDetailsPage extends StatefulWidget {
  final Map<String, dynamic> breed;

  const CatDetailsPage({Key? key, required this.breed}) : super(key: key);

  @override
  _CatDetailsPageState createState() => _CatDetailsPageState();
}

class _CatDetailsPageState extends State<CatDetailsPage> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    final favorites = await FavoritesDatabase.instance.getFavorites();
    final isFav = favorites.any(
          (cat) => cat['reference_image_id'] == widget.breed['reference_image_id'],
    );

    setState(() {
      isFavorite = isFav;
    });
  }

  Future<void> _toggleFavorite(BuildContext context) async {
    final referenceId = widget.breed['reference_image_id'];

    if (isFavorite) {
      // Eliminar de favoritos
      final favorites = await FavoritesDatabase.instance.getFavorites();
      final catToRemove = favorites.firstWhere(
            (cat) => cat['reference_image_id'] == referenceId,
        orElse: () => {},
      );

      if (catToRemove.isNotEmpty) {
        await FavoritesDatabase.instance.deleteFavorite(catToRemove['id']);
        setState(() {
          isFavorite = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${widget.breed['name']} removed from favorites!')),
        );
      }
    } else {
      // Agregar a favoritos
      final cat = {
        'name': widget.breed['name'],
        'temperament': widget.breed['temperament'] ?? 'Unknown',
        'intelligence': widget.breed['intelligence'] ?? 0,
        'reference_image_id': referenceId,
      };

      await FavoritesDatabase.instance.addFavorite(cat);
      setState(() {
        isFavorite = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${widget.breed['name']} added to favorites!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.breed['name'] ?? 'Cat Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.breed['image'] != null
                ? Image.network(
              widget.breed['image']['url'],
              height: 200,
              fit: BoxFit.cover,
            )
                : Icon(Icons.pets, size: 200),
            SizedBox(height: 20),
            Text(
              'Name: ${widget.breed['name'] ?? 'Unknown'}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Origin: ${widget.breed['origin'] ?? 'Unknown'}'),
            SizedBox(height: 10),
            Text('Description: ${widget.breed['description'] ?? 'No description available'}'),
            SizedBox(height: 10),
            Text('Energy Level:'),
            Slider(
              value: (widget.breed['energy_level'] ?? 0).toDouble(),
              min: 1,
              max: 5,
              divisions: 4,
              onChanged: null,
            ),
            SizedBox(height: 20),
            Center(
              child: IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  size: 36,
                  color: Colors.red,
                ),
                onPressed: () => _toggleFavorite(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
