import 'package:flutter/material.dart';
import 'package:gausampada/screens/breed/sub_screens/cattle_feed.dart';
import 'package:gausampada/screens/breed/sub_screens/finance.dart';
import 'package:gausampada/screens/breed/sub_screens/insurance.dart';
import 'package:gausampada/screens/breed/sub_screens/medicine.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CattleServicesGrid extends StatelessWidget {
  const CattleServicesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // color: const Color(0xFF8CBE55), // Darker green background
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(12.0),
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        children: [
          ServiceTile(
            svgAsset: 'assets/schemes/finance.png',
            fallbackIcon: Icons.attach_money,
            label: AppLocalizations.of(context)!.finance,
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const FinanceScreen()));
            },
          ),
          ServiceTile(
            svgAsset: 'assets/schemes/insurance.png',
            fallbackIcon: Icons.shield,
            label: AppLocalizations.of(context)!.insurance,
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const InsuranceScreen())),
          ),
          ServiceTile(
            svgAsset: 'assets/schemes/medicines.png',
            fallbackIcon: Icons.medical_services,
            label: AppLocalizations.of(context)!.medicines,
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const MedicinesScreen())),
          ),
          ServiceTile(
            svgAsset: 'assets/schemes/cattle_feeds.png',
            fallbackIcon: Icons.grass,
            label: AppLocalizations.of(context)!.cattleFeeds,
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const CattleFeedsScreen())),
          ),
        ],
      ),
    );
  }
}

class ServiceTile extends StatelessWidget {
  final String svgAsset;
  final IconData fallbackIcon;
  final String label;
  final void Function()? onTap;

  const ServiceTile({
    super.key,
    required this.svgAsset,
    required this.fallbackIcon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFE3F8D2), // Light green background
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Builder(
              builder: (context) {
                try {
                  // return SvgPicture.asset(
                  //   svgAsset,
                  //   height: 50.0,
                  //   width: 50.0,
                  //   colorFilter:
                  //       const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                  //   placeholderBuilder: (BuildContext context) => Container(
                  //     height: 50.0,
                  //     width: 50.0,
                  //     color: Colors.grey[300],
                  //     child: const Icon(Icons.image),
                  //   ),
                  // );
                  return Image.asset(
                    svgAsset,
                    height: 50,
                    width: 50,
                  );
                } catch (e) {
                  // Fallback to regular icon if SVG asset fails to load
                  return Icon(
                    fallbackIcon,
                    size: 50.0,
                    color: Colors.black,
                  );
                }
              },
            ),
            const SizedBox(height: 12.0),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
