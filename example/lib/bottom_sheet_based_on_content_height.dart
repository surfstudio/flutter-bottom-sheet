import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';

const _rabbitImagePath = 'assets/images/rabbit.jpg';
const _deerImagePath = 'assets/images/deer.jpg';

class BottomSheetBasedOnContentHeight extends StatelessWidget {
  const BottomSheetBasedOnContentHeight({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children:
          _listAnimals.map((animal) => _AnimalCard(animal: animal)).toList(),
    );
  }
}

class _AnimalCard extends StatelessWidget {
  final _Animal animal;

  const _AnimalCard({
    required this.animal,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 16.0,
        right: 8.0,
        left: 8.0,
      ),
      child: GestureDetector(
        onTap: () => _openBottomSheetWithInfo(context, animal),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Image(
              image: AssetImage(animal.photo),
            ),
          ),
        ),
      ),
    );
  }

  void _openBottomSheetWithInfo(BuildContext context, _Animal animal) {
    showFlexibleBottomSheet<void>(
      isExpand: false,
      initHeight: 0.8,
      maxHeight: 0.8,
      context: context,
      builder: (context, controller, offset) {
        return _BottomSheet(
          animal: animal,
          controller: controller,
        );
      },
    );
  }
}

class _BottomSheet extends StatelessWidget {
  final _Animal animal;
  final ScrollController controller;

  const _BottomSheet({
    required this.animal,
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        controller: controller,
        shrinkWrap: true,
        children: [
          Text(
            animal.animalName,
            style: const TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16.0),
          ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Image(
              image: AssetImage(animal.photo),
            ),
          ),
          const SizedBox(height: 16.0),
          Text(
            animal.description,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class _Animal {
  final String animalName;
  final String photo;
  final String description;

  _Animal(this.animalName, this.photo, this.description);
}

final _listAnimals = <_Animal>[
  _Animal(
    'Rabbit',
    _rabbitImagePath,
    'Rabbits are small, furry mammals with long ears, short fluffy tails, and strong, large hind legs. They have 2 pairs of sharp incisors (front teeth), one pair on top and one pair on the bottom. They also have 2 peg teeth behind the top incisors',
  ),
  _Animal(
    'Deer',
    _deerImagePath,
    "Members of the deer family (Cervidae) are cloven-hoofed ungulates that typically have compact torsos with long, slender legs and small tails — and most males have antlers. The family is quite large, and includes caribou, elk, moose, muntjacs and wapiti. Cervids are the second most diverse family after bovids (antelopes, bison, buffalo, goats, sheep, etc.). There are about 50 species, but there is some disagreement about cervid classification. According to the University of Michigan's Animal Diversity Web (ADW), no single well-supported phylogenetic and taxonomic history has been established. Deer species range from very large to very small. The smallest deer is the Southern pudu, according to the ARKive project. It weighs only abbout 20 lbs. (9 kilograms) and gets to be only about 14 inches (36 centimeters) tall when fully grown. The largest deer is the moose. It can grow up to 6.5 feet (2 meters) from hoof to shoulder and weigh around 1,800 lbs. (820 kg).",
  ),
];
