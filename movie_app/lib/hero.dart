import 'package:flutter/material.dart';

class MHero {
  final String name, description;
  final Color color;
  final AssetImage image, backGroundImage;
  final String heroName;
  final int id;

  MHero(
    this.id,
    this.name,
    this.image,
    this.description,
    this.color,
    this.backGroundImage,
    this.heroName,
  );
}

List<String> descriptions = [
  "Spider-Man is a superhero with spider-like abilities, including superhuman strength, agility, and reflexes, as well as the ability to climb walls and shoot webs from devices he designed himself.",
  "Iron Man is a superhero with a high-tech suit of armor that gives him superhuman strength, durability, and the ability to fly. The suit also features an array of powerful weapons and gadgets",
  "Captain America is a superhero with enhanced strength, agility, endurance, and reflexes. He is also a master tactician and skilled hand-to-hand combatant. Captain America is most well-known for his indestructible shield, which he uses both defensively and offensively in combat.",
];

final heroes = [
  MHero(
    1,
    "Spider-Man",
    const AssetImage("assets/spider_man.png"),
    descriptions[0],
    Colors.redAccent,
    const AssetImage("assets/spider_back.png"),
    "Peter Parker",
  ),
  MHero(
    2,
    "Iron-Man",
    const AssetImage("assets/iron_man.png"),
    descriptions[1],
    const Color.fromARGB(248, 255, 179, 38),
    const AssetImage("assets/iron_man_back.png"),
    "Tony Stark",
  ),
  MHero(
    3,
    "Spider-Man",
    const AssetImage("assets/spider_man.png"),
    descriptions[0],
    Colors.redAccent,
    const AssetImage("assets/spider_back.png"),
    "Peter Parker",
  ),
  MHero(
    4,
    "Iron-Man",
    const AssetImage("assets/iron_man.png"),
    descriptions[1],
    const Color.fromARGB(248, 255, 179, 38),
    const AssetImage("assets/iron_man_back.png"),
    "Tony Stark",
  ),
];
