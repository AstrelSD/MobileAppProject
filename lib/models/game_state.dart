class GameState {
  int level;
  int score;
  int coins;
  int coconut;
  int lives;
  String? character;
  DateTime? timestamp;
  

  GameState({
    required this.level,
    required this.score,
    required this.coins,
    required this.coconut,
    required this.lives,
    this.character,
    this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'level': level,
      'score': score,
      'coins': coins,
      'coconut': coconut,
      'lives': lives,
      'character': character,
      'timestamp': timestamp?.toIso8601String(),
    };
  }

  static GameState fromJson(Map<String, dynamic> json) {
    return GameState(
      level: json['level'],
      score: json['score'],
      coins: json['coins'],
      coconut: json['coconut'],
      lives: json['lives'],
      character: json['character'],
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : null,
    );
  }
}
