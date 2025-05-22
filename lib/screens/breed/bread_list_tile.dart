import 'package:flutter/material.dart';
import 'package:gausampada/backend/models/breed_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gausampada/screens/breed/breed_details.dart';

// The individual card that will be displayed in the horizontal list
class BreedCard extends StatelessWidget {
  final Breed breed;
  final bool showBookButton;

  const BreedCard({
    super.key,
    required this.breed,
    this.showBookButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                BreedDetailScreen(breed: breed),
            transitionDuration: const Duration(milliseconds: 500),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        );
      },
      child: Container(
        width: 320, // Fixed width for cards in a horizontal list
        margin: const EdgeInsets.only(right: 16, top: 12, bottom: 12, left: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFEAFFD8), // Light green background
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Green accent element in top-right corner
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Color(0xFF76C043), // Green accent color
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(24),
                    bottomLeft: Radius.circular(20),
                  ),
                ),
              ),
            ),

            // Main content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Content column (left side)
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Breed name and scientific name
                        Hero(
                          tag: 'breed-name-${breed.breedName}',
                          child: Material(
                            color: Colors.transparent,
                            child: Text(
                              breed.breedName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF194D00),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Details with icons
                        _buildInfoRow(
                            Icons.location_on_outlined,
                            AppLocalizations.of(context)!.origin,
                            AppLocalizations.of(context)!.india),
                        const SizedBox(height: 6),
                        _buildInfoRow(
                            Icons.currency_rupee,
                            AppLocalizations.of(context)!.cost,
                            '₹30,000 - ₹50,000'),
                        const SizedBox(height: 6),
                        _buildInfoRow(
                            Icons.opacity,
                            AppLocalizations.of(context)!.milk_yield,
                            breed.milkYield),
                      ],
                    ),
                  ),

                  // Image section (right side)
                  const SizedBox(width: 8),
                  Hero(
                    tag: 'breed-image-${breed.breedName}',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: 110,
                        height: 140,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            // Image
                            Positioned.fill(
                              child: Image.network(
                                breed.imageURl,
                                fit: BoxFit.cover,
                              ),
                            ),
                            // Gradient overlay at the bottom for better text visibility
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              height: 40,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.3),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: const Color(0xFF76C043),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$label: ',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                TextSpan(
                  text: value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
