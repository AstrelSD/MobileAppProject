class GameState {
  int level;
  int score;
  int coins;
  int gold;
  int lives;
  

  GameState({
    required this.level,
    required this.score,
    required this.coins,
    required this.gold,
    required this.lives
  });

  Map<String, dynamic> toJson() {
    return {
      'level': level,
      'score': score,
      'coins': coins,
      'gold': gold,
      'lives': lives
    };
  }

  static GameState fromJson(Map<String, dynamic> json) {
    return GameState(
      level: json['level'],
      score: json['score'],
      coins: json['coins'],
      gold: json['gold'],
      lives: json['lives']
    );
  }
}
