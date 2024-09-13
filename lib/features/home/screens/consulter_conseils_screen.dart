import 'package:e_commerce_app/common/widgets/appbar/appbar.dart';
import 'package:e_commerce_app/features/home/screens/widgets/build_conseil__card.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_app/utils/constants/sizes.dart';

class ConsulterConseilsScreen extends StatelessWidget {
  const ConsulterConseilsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TAppBar(
        showBackArrow: true,
        title:  Text('Conseils de recyclage'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: ListView(
          children: const [
    BuildConseilCard(
      recycleBien: 'Composter vos déchets alimentaires pour produire du compost organique. Recycler les emballages plastiques, les papiers et les restes alimentaires selon les directives locales de recyclage des déchets ménagers.',
      wasteType: 'Déchets ménagers',
      wasteIcon: Icons.house,
      example: 'Sacs poubelles, emballages plastiques, papiers, restes alimentaires',
      description: 'Déchets produits par les ménages dans leur vie quotidienne.'
    ),
    SizedBox(height: 20.0),
    BuildConseilCard(
      recycleBien: 'Contacter des services de collecte spéciaux ou des entreprises de recyclage pour gérer correctement les résidus de fabrication, les produits chimiques et les déchets métalliques. Éviter la contamination des sols et des eaux en manipulant ces déchets de manière sécurisée.',
      wasteType: 'Déchets industriels',
      wasteIcon: Icons.build_circle,
      example: 'Résidus de fabrication, produits chimiques, déchets métalliques',
      description: 'Déchets produits par les activités industrielles et commerciales.'
    ),
    SizedBox(height: 20.0),
    BuildConseilCard(
      recycleBien: 'Apporter les batteries usagées, les produits toxiques et les déchets médicaux aux centres de recyclage ou aux installations de traitement des déchets dangereux. Suivre les réglementations locales pour l\'élimination sûre de ces déchets.',
      wasteType: 'Déchets dangereux',
      wasteIcon: Icons.warning,
      example: 'Batteries, produits toxiques, déchets médicaux',
      description: 'Déchets qui présentent un risque pour la santé ou l’environnement.'
    ),
    SizedBox(height: 20.0),
    BuildConseilCard(
      recycleBien: 'Utiliser des composteurs pour décomposer les déchets alimentaires et les déchets verts. Le compost produit peut être réutilisé comme amendement pour le sol dans les jardins et les cultures.',
      wasteType: 'Déchets organiques',
      wasteIcon: Icons.eco,
      example: 'Déchets alimentaires, déchets verts, déchets biologiques',
      description: 'Déchets biodégradables d’origine végétale ou animale.'
    ),
    SizedBox(height: 20.0),
    BuildConseilCard(
      recycleBien: 'Trouver des programmes de recyclage électronique locaux ou des points de collecte pour déposer vos appareils électroniques usagés. Certains fabricants offrent également des programmes de reprise pour les anciens appareils.',
      wasteType: 'Déchets électroniques',
      wasteIcon: Icons.computer,
      example: 'Ordinateurs, téléphones, appareils électroménagers',
      description: 'Appareils électroniques en fin de vie ou obsolètes.'
    ),
    SizedBox(height: 20.0),
    BuildConseilCard(
      recycleBien: 'Séparer les matériaux de construction recyclables tels que le bois, le métal et le béton des autres débris de construction. Rechercher des entreprises de recyclage de matériaux de construction pour les déposer ou les collecter sur le site de construction.',
      wasteType: 'Déchets de construction et de démolition',
      wasteIcon: Icons.construction,
      example: 'Béton, bois, métaux, matériaux de construction',
      description: 'Déchets issus de chantiers de construction ou de démolition.'
    ),
    SizedBox(height: 20.0),
    BuildConseilCard(
      recycleBien: "Contacter les autorités locales ou les organisations spécialisées pour la gestion sûre des déchets radioactifs. Suivre les protocoles de sécurité stricts pour l'élimination et le stockage de ces déchets afin de prévenir les risques pour la santé et l'environnement.",
      wasteType: 'Déchets radioactifs',
      wasteIcon: Icons.medical_information_outlined,
      example: 'Déchets nucléaires, équipements médicaux irradiés',
      description: 'Déchets émettant des radiations ionisantes.'
    ),
    SizedBox(height: 20.0),
    BuildConseilCard(
      recycleBien: 'Composter les déchets végétaux pour produire du compost naturel. Certains services de collecte municipaux proposent également le ramassage des déchets verts pour les transformer en compost.',
      wasteType: 'Déchets verts',
      wasteIcon: Icons.nature,
      example: 'Feuilles mortes, branches, tontes de gazon',
      description: 'Déchets végétaux issus de jardins, parcs ou espaces verts.'
    ),
  ],
        ),
      ),
    );
  }
}
