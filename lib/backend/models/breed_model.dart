import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Breed {
  String breedName;
  String origin;
  List<String> localNames;
  String milkYield;
  String lactationPeriod;
  String description;
  String cost;
  String imageURl;
  Breed({
    required this.breedName,
    required this.origin,
    required this.localNames,
    required this.milkYield,
    required this.lactationPeriod,
    required this.description,
    required this.cost,
    required this.imageURl,
  });
}

List<Breed> getBreeds(BuildContext context) {
  return [
    Breed(
      breedName: AppLocalizations.of(context)!.gir_breedName,
      origin: AppLocalizations.of(context)!.gir_origin,
      localNames: [AppLocalizations.of(context)!.gir_localNames],
      milkYield: AppLocalizations.of(context)!.gir_milkYield,
      lactationPeriod: AppLocalizations.of(context)!.gir_lactationPeriod,
      description: AppLocalizations.of(context)!.gir_description,
      cost: "₹50,000 - ₹1,50,000",
      imageURl:
          "https://timesofagriculture.in/wp-content/uploads/2023/12/e036ab.jpg",
    ),
    Breed(
      breedName: AppLocalizations.of(context)!.sahiwal_breedName,
      origin: AppLocalizations.of(context)!.sahiwal_origin,
      localNames: [],
      milkYield: AppLocalizations.of(context)!.sahiwal_milkYield,
      lactationPeriod: AppLocalizations.of(context)!.sahiwal_lactationPeriod,
      description: AppLocalizations.of(context)!.sahiwal_description,
      cost: "₹60,000 - ₹1,80,000",
      imageURl:
          "https://timesofagriculture.in/wp-content/uploads/2023/12/16f343.jpg",
    ),
    Breed(
      breedName: AppLocalizations.of(context)!.red_sindhi_breedName,
      origin: AppLocalizations.of(context)!.red_sindhi_origin,
      localNames: [
        AppLocalizations.of(context)!.red_sindhi_localNames,
        // "Red Karachi"
      ],
      milkYield: AppLocalizations.of(context)!.red_sindhi_milkYield,
      lactationPeriod: AppLocalizations.of(context)!.red_sindhi_lactationPeriod,
      description: AppLocalizations.of(context)!.red_sindhi_description,
      cost: "₹40,000 - ₹1,20,000",
      imageURl:
          "https://timesofagriculture.in/wp-content/uploads/2023/12/7ebbae.jpg",
    ),
    Breed(
      breedName: AppLocalizations.of(context)!.tharparkar_breedName,
      origin: AppLocalizations.of(context)!.tharparkar_origin,
      localNames: [AppLocalizations.of(context)!.tharparkar_localNames],
      milkYield: AppLocalizations.of(context)!.tharparkar_milkYield,
      lactationPeriod: AppLocalizations.of(context)!.tharparkar_lactationPeriod,
      description: AppLocalizations.of(context)!.tharparkar_description,
      cost: "₹50,000 - ₹1,40,000",
      imageURl:
          "https://timesofagriculture.in/wp-content/uploads/2023/12/c03272.jpg",
    ),
    Breed(
      breedName: AppLocalizations.of(context)!.deoni_breedName,
      origin: AppLocalizations.of(context)!.deoni_origin,
      localNames: [AppLocalizations.of(context)!.deoni_localNames],
      milkYield: AppLocalizations.of(context)!.deoni_milkYield,
      lactationPeriod: AppLocalizations.of(context)!.deoni_lactationPeriod,
      description: AppLocalizations.of(context)!.deoni_description,
      cost: "₹40,000 - ₹1,10,000",
      imageURl:
          "https://timesofagriculture.in/wp-content/uploads/2023/12/bd29c5.jpg",
    ),
    Breed(
      breedName: AppLocalizations.of(context)!.ongole_breedName,
      origin: AppLocalizations.of(context)!.ongole_origin,
      localNames: [AppLocalizations.of(context)!.ongole_localNames],
      milkYield: AppLocalizations.of(context)!.ongole_milkYield,
      lactationPeriod: AppLocalizations.of(context)!.ongole_lactationPeriod,
      description: AppLocalizations.of(context)!.ongole_description,
      cost: "₹50,000 - ₹1,20,000",
      imageURl:
          "https://timesofagriculture.in/wp-content/uploads/2023/12/133b3f.jpg",
    ),
    Breed(
      breedName: AppLocalizations.of(context)!.hariana_breedName,
      origin: AppLocalizations.of(context)!.hariana_origin,
      localNames: [],
      milkYield: AppLocalizations.of(context)!.hariana_milkYield,
      lactationPeriod: AppLocalizations.of(context)!.hariana_lactationPeriod,
      description: AppLocalizations.of(context)!.hariana_description,
      cost: "₹40,000 - ₹1,00,000",
      imageURl:
          "https://timesofagriculture.in/wp-content/uploads/2023/12/7d6ee1.jpg",
    ),
    Breed(
      breedName: AppLocalizations.of(context)!.kankrej_breedName,
      origin: AppLocalizations.of(context)!.kankrej_origin,
      localNames: [AppLocalizations.of(context)!.kankrej_localNames],
      milkYield: AppLocalizations.of(context)!.kankrej_milkYield,
      lactationPeriod: AppLocalizations.of(context)!.kankrej_lactationPeriod,
      description: AppLocalizations.of(context)!.kankrej_description,
      cost: "₹55,000 - ₹1,50,000",
      imageURl:
          "https://timesofagriculture.in/wp-content/uploads/2023/12/58b291.jpg",
    ),
    Breed(
      breedName: AppLocalizations.of(context)!.khillari_breedName,
      origin: AppLocalizations.of(context)!.khillari_origin,
      localNames: [],
      milkYield: AppLocalizations.of(context)!.khillari_milkYield,
      lactationPeriod: AppLocalizations.of(context)!.khillari_lactationPeriod,
      description: AppLocalizations.of(context)!.khillari_description,
      cost: "₹40,000 - ₹1,10,000",
      imageURl:
          "https://timesofagriculture.in/wp-content/uploads/2023/12/d8dd9c.jpg",
    ),
    Breed(
      breedName: AppLocalizations.of(context)!.hallikar_breedName,
      origin: AppLocalizations.of(context)!.hallikar_origin,
      localNames: [],
      milkYield: AppLocalizations.of(context)!.hallikar_milkYield,
      lactationPeriod: AppLocalizations.of(context)!.hallikar_lactationPeriod,
      description: AppLocalizations.of(context)!.hallikar_description,
      cost: "₹30,000 - ₹80,000",
      imageURl:
          "https://timesofagriculture.in/wp-content/uploads/2023/12/80427b.jpg",
    ),
    Breed(
      breedName: AppLocalizations.of(context)!.amritmahal_breedName,
      origin: AppLocalizations.of(context)!.amritmahal_origin,
      localNames: [],
      milkYield: AppLocalizations.of(context)!.amritmahal_milkYield,
      lactationPeriod: AppLocalizations.of(context)!.amritmahal_lactationPeriod,
      description: AppLocalizations.of(context)!.amritmahal_description,
      cost: "₹30,000 - ₹75,000",
      imageURl:
          "https://timesofagriculture.in/wp-content/uploads/2023/12/6afde2.jpg",
    ),
    Breed(
      breedName: AppLocalizations.of(context)!.khillari_breedName,
      origin: AppLocalizations.of(context)!.khillari_origin,
      localNames: [],
      milkYield: AppLocalizations.of(context)!.khillari_milkYield,
      lactationPeriod: AppLocalizations.of(context)!.khillari_lactationPeriod,
      description: AppLocalizations.of(context)!.khillari_description,
      cost: "₹30,000 - ₹85,000",
      imageURl:
          "https://timesofagriculture.in/wp-content/uploads/2023/12/d8dd9c.jpg",
    ),
    Breed(
      breedName: AppLocalizations.of(context)!.kangayam_breedName,
      origin: AppLocalizations.of(context)!.kangayam_origin,
      localNames: [],
      milkYield: AppLocalizations.of(context)!.kangayam_milkYield,
      lactationPeriod: AppLocalizations.of(context)!.kangayam_lactationPeriod,
      description: AppLocalizations.of(context)!.kangayam_description,
      cost: "₹35,000 - ₹90,000",
      imageURl:
          "https://timesofagriculture.in/wp-content/uploads/2023/12/d3bd97.jpg",
    ),
    Breed(
      breedName: AppLocalizations.of(context)!.bargur_breedName,
      origin: AppLocalizations.of(context)!.bargur_origin,
      localNames: [AppLocalizations.of(context)!.bargur_localNames],
      milkYield: AppLocalizations.of(context)!.bargur_milkYield,
      lactationPeriod: AppLocalizations.of(context)!.bargur_lactationPeriod,
      description: AppLocalizations.of(context)!.bargur_description,
      cost: "₹25,000 - ₹70,000",
      imageURl:
          "https://timesofagriculture.in/wp-content/uploads/2023/12/6978fb.jpg",
    ),
  ];
}
