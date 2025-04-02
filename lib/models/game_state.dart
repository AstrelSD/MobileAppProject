class GameState {
  int level;
  int score;
  int coins;
  int gold;
  int lives;
  String? character;
  DateTime? timestamp;
  

  GameState({
    required this.level,
    required this.score,
    required this.coins,
    required this.gold,
    required this.lives,
    this.character,
    this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'level': level,
      'score': score,
      'coins': coins,
      'gold': gold,
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
      gold: json['gold'],
      lives: json['lives'],
      character: json['character'],
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : null,
    );
  }
}
