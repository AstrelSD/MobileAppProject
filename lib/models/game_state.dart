class GameState {
  final int level;
  final int score;
  final int coins;
  final int coconut;
  final int lives;
  final String character;
  final DateTime timestamp;

  GameState({
    required this.level,
    required this.score,
    required this.coins,
    required this.coconut,
    required this.lives,
    required this.character,
    required this.timestamp,
  });

  // Convert GameState to a map (for saving to Firestore)
  Map<String, dynamic> toJson() {
    return {
      'level': level,
      'score': score,
      'coins': coins,
      'coconut': coconut,
      'lives': lives,
      'character': character,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  // Create GameState from a map (for loading from Firestore)
  factory GameState.fromJson(Map<String, dynamic> json) {
    return GameState(
      level: json['level'],
      score: json['score'],
      coins: json['coins'],
      coconut: json['coconut'],
      lives: json['lives'],
      character: json['character'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
