class Yoga {
  final String url;
  final String title;
  final int setCount;
  bool isFav;

  Yoga(this.url, this.title, this.setCount, this.isFav);
}

// ignore: constant_identifier_names
const URL =
    "https://img.freepik.com/free-vector/cute-astronaut-super-hero-cartoon-vector-icon-illustration_138676-3470.jpg?t=st=1675781669~exp=1675782269~hmac=2e2bbf89b34bebecde70a5c10d7470f10a8c969d26598b15c58e1dfc42ffe404";

List<Yoga> yogas = [
  Yoga(URL, "Toe Reach", 15, false),
  Yoga(URL, "Leg V-Up", 20, false),
  Yoga(URL, "Ball Rollout", 12, true),
  Yoga(URL, "Side Jump", 15, false),
  Yoga(URL, "Side Plank", 20, true),
  Yoga(URL, "Russian Twist", 15, false),
  Yoga(URL, "Windshield Wipers", 12, false),
];
