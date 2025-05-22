import 'package:flutter/material.dart';
import 'package:gausampada/backend/models/breed_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gausampada/screens/breed/breed_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BreedInfoCardScreen extends StatefulWidget {
  const BreedInfoCardScreen({super.key});

  @override
  State<BreedInfoCardScreen> createState() => _BreedInfoCardScreenState();
}

class _BreedInfoCardScreenState extends State<BreedInfoCardScreen> {
  // Set to store liked breed IDs
  Set<String> likedBreeds = {};

  @override
  void initState() {
    super.initState();
    _loadLikedBreeds();
  }

  // Load liked breeds from SharedPreferences
  Future<void> _loadLikedBreeds() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        likedBreeds =
            Set<String>.from(prefs.getStringList('likedBreeds') ?? []);
      });
    } catch (e) {
      debugPrint('Error loading liked breeds: $e');
    }
  }

  // Save liked breeds to SharedPreferences
  Future<void> _saveLikedBreeds() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('likedBreeds', likedBreeds.toList());
    } catch (e) {
      debugPrint('Error saving liked breeds: $e');
    }
  }

  // Toggle like status for a breed
  void _toggleLike(String breedId) {
    setState(() {
      if (likedBreeds.contains(breedId)) {
        likedBreeds.remove(breedId);
      } else {
        likedBreeds.add(breedId);
      }
    });
    _saveLikedBreeds();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: getBreeds(context).map((breed) {
                final bool isLiked = likedBreeds.contains(breed.breedName);

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to breed detail screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BreedDetailScreen(breed: breed),
                        ),
                      );
                    },
                    child: Container(
                      width: 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Stack(
                          children: [
                            // Image with gradient overlay
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SizedBox(
                                  height: 162,
                                  child: Hero(
                                    tag: 'breed-image-${breed.breedName}',
                                    child: Image.network(
                                      breed.imageURl,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          height: 220,
                                          color: Colors.grey.shade200,
                                          child: const Center(
                                            child: Icon(
                                              Icons.pets_rounded,
                                              size: 60,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // Gradient overlay
                            Positioned.fill(
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.7),
                                    ],
                                    stops: const [0.6, 1.0],
                                  ),
                                ),
                              ),
                            ),
                            // Text at bottom
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Hero(
                                      tag: 'breed-name-${breed.breedName}',
                                      child: Material(
                                        color: Colors.transparent,
                                        child: Text(
                                          breed.breedName,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    // Optional: Add additional breed information
                                    Text(
                                      breed.origin,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white.withOpacity(0.8),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Favorite button with functional like
                            Positioned(
                              top: 12,
                              right: 12,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.3),
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    isLiked
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: isLiked ? Colors.red : Colors.white,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    _toggleLike(breed.breedName);
                                    // Show feedback to user
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          isLiked
                                              ? '${breed.breedName} ${AppLocalizations.of(context)!.removed_from_favorites}'
                                              : '${breed.breedName} ${AppLocalizations.of(context)!.added_to_favorites}',
                                        ),
                                        duration: const Duration(seconds: 1),
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
