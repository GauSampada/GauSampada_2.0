import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InfoMainScreen extends StatefulWidget {
  const InfoMainScreen({super.key});

  @override
  State<InfoMainScreen> createState() => InfoMainScreenState();
}

class InfoMainScreenState extends State<InfoMainScreen>
    with SingleTickerProviderStateMixin {
  final PageController controller = PageController(initialPage: 0);
  bool isLastPage = false;
  int currentPage = 0;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 0.97, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutQuad),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final List<Map<String, dynamic>> _features = [
      {
        "title": AppLocalizations.of(context)!.onboardingScreen2Title,
        "image": "assets/feed/cow_info.jpg",
        "color": const Color(0xFF4CAF50),
      },
      {
        "title": AppLocalizations.of(context)!.onboardingScreen3Title,
        "image": "assets/feed/products.jpg",
        "color": const Color(0xFFF57C00),
      },
      {
        "title": AppLocalizations.of(context)!.onboardingScreen4Title,
        "image": "assets/feed/farmers.jpg",
        "color": const Color(0xFF9C27B0),
      },
      {
        "title": AppLocalizations.of(context)!.feedScreen4Title,
        "image": "assets/feed/ai_assist.jpg",
        "color": const Color(0xFFE91E63),
      },
      {
        "title": AppLocalizations.of(context)!.onboardingScreen5Title,
        "image": "assets/feed/vetenary.jpg",
        "color": const Color(0xFF2196F3),
        "width": 0.7,
      },
    ];

    // double screenHeight = MediaQuery.of(context).size.height;
    // double screenWidth = MediaQuery.of(context).size.width;

    return AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.primaryColor.withOpacity(0.05),
                    Colors.white,
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  PageView.builder(
                    controller: controller,
                    onPageChanged: (index) {
                      setState(() {
                        isLastPage = index == _features.length - 1;
                        currentPage = index;
                        _animationController.reset();
                        _animationController.forward();
                      });
                    },
                    itemCount: _features.length,
                    itemBuilder: (context, index) {
                      return _buildInfoPage(
                        _features[index]["title"],
                        _features[index]["image"],
                        theme,
                        color: _features[index]["color"],
                        imageWidth: _features[index]["width"] ?? 1.0,
                      );
                    },
                  ),

                  // Left navigation icon (positioned at leftmost edge)
                  if (currentPage > 0)
                    Positioned(
                      left: 0,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.only(left: 8, right: 4),
                          decoration: const BoxDecoration(
                            color: Colors.black38,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () {
                              controller.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOut,
                              );
                            },
                            icon: const Icon(
                              Icons.arrow_back_ios_rounded,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),

                  // Right navigation icon (positioned at rightmost edge)
                  if (currentPage < _features.length - 1)
                    Positioned(
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.only(left: 4, right: 8),
                          decoration: const BoxDecoration(
                            color: Colors.black38,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                            ),
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () {
                              controller.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOut,
                              );
                            },
                            icon: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),

                  // Small dots indicator at bottom
                  Positioned(
                    bottom: 16,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _features.length,
                        (index) => Container(
                          width: index == currentPage ? 16 : 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: index == currentPage
                                ? _features[index]["color"]
                                : Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _buildInfoPage(String title, String imageAsset, ThemeData theme,
      {double imageWidth = 1.0, Color? color}) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background image with gradient overlay
        Image.asset(
          imageAsset,
          fit: BoxFit.cover,
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.1),
                Colors.black.withOpacity(0.7),
              ],
            ),
          ),
        ),

        // Content
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(1, 1),
                      blurRadius: 3,
                      color: Colors.black45,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: color ?? theme.primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.learnMore,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              // Extra space at bottom for page indicator
              const SizedBox(height: 30),
            ],
          ),
        ),
      ],
    );
  }
}
