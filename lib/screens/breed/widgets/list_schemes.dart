import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ImageCarousel extends StatefulWidget {
  const ImageCarousel({super.key});

  @override
  _ImageCarouselState createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<String> imageUrls = [
    'assets/schemes/farmer_schemes.png',
    'assets/schemes/pm-kisan.png',
    'assets/schemes/samman_nidhi.png',
    'assets/schemes/gokul.png',
  ];

  final List<String> links = [
    'https://agriwelfare.gov.in/en/Major',
    'https://pmkisan.gov.in/',
    'https://pmkisan.gov.in/',
    "https://dahd.gov.in/schemes/programmes/rashtriya_gokul_mission"
  ];

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      if (!await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      )) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open $url')),
        );
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          width: MediaQuery.of(context).size.width * 0.9,
          child: PageView.builder(
            controller: _pageController,
            itemCount: imageUrls.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => _launchURL(links[index]),
                child: Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Image.asset(
                      imageUrls[index],
                      fit: BoxFit.fill,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            imageUrls.length,
            (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentIndex == index ? 12 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentIndex == index ? Colors.blue : Colors.grey,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
