import 'package:flutter_test/flutter_test.dart';
import 'package:flame/game.dart';
import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('GameWidget renders correctly', (WidgetTester tester) async {
    // Build the game widget and trigger a frame.
    await tester.pumpWidget(
        GameWidget(game: ProjectGame())); // Use GameWidget to load the game

    // Verify that the GameWidget is rendered
    expect(find.byType(GameWidget), findsOneWidget);

    // If your game has components or sprites, you can check them here.
    // For example, you can test if a sprite or game component is visible
    // after it's loaded into the game. However, for Flame, this may require
    // checking internal game states rather than just the widget tree.

    // Example check: Make sure a sprite or object is rendered after game load
    // expect(find.byKey(Key('mySprite')), findsOneWidget); // Replace with your sprite's key if you have one.
  });
}
