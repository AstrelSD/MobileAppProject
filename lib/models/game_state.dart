class GameState {
  final int level;
  final int score;
  final int coins;
  final int coconut;
  final int gold; 
  final int lives;
  final String character;
  final DateTime timestamp;

  GameState({
    required this.level,
    required this.score,
    required this.coins,
    required this.coconut,
    required this.gold,  
    required this.lives,
    required this.character,
    required this.timestamp,
  });

  // Convert GameState to JSON (for saving to Firestore)
  Map<String, dynamic> toJson() {
    return {
      'level': level,
      'score': score,
      'coins': coins,
      'coconut': coconut,
      'gold': gold,  
      'lives': lives,
      'character': character,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  // Create GameState from JSON (for loading from Firestore)
  factory GameState.fromJson(Map<String, dynamic> json) {
    return GameState(
      level: json['level'],
      score: json['score'],
      coins: json['coins'],
      coconut: json['coconut'],
      gold: json['gold'] ?? 0, 
      lives: json['lives'],
      character: json['character'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
