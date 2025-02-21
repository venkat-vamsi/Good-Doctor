import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/quiz_provider.dart';

class QuizScreen extends HookConsumerWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizState = ref.watch(quizProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Puzzle Quiz'),
        backgroundColor: Colors.purple[400],
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[100]!, Colors.purple[100]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: quizState.isLoading
            ? const Center(child: SpinKitWave(color: Colors.purple, size: 50))
            : quizState.error != null
                ? Center(child: Text('Error: ${quizState.error}'))
                : quizState.quizData == null
                    ? const Center(
                        child:
                            Text('Press the refresh button to generate a quiz'))
                    : _buildQuizContent(context, ref, quizState),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(quizProvider.notifier).fetchQuiz(),
        backgroundColor: Colors.purple[500],
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildQuizContent(
      BuildContext context, WidgetRef ref, QuizState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PuzzleCard(
            color: Colors.blue[300]!,
            child: Text(
              state.quizData!.scenario,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          const SizedBox(height: 20),
          PuzzleCard(
            color: Colors.purple[300]!,
            child: Text(
              state.quizData!.question,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          ...state.quizData!.options.entries
              .map((entry) => _buildOption(ref, state, entry.key, entry.value)),
          if (state.selectedAnswer != null) ...[
            const SizedBox(height: 20),
            PuzzleCard(
              color: state.selectedAnswer == state.quizData!.correct
                  ? Colors.green[200]!
                  : Colors.red[200]!,
              child: Text(
                state.selectedAnswer == state.quizData!.correct
                    ? 'Awesome! You nailed it!'
                    : 'Try again! Correct answer: ${state.quizData!.correct}',
                style: TextStyle(
                    color: state.selectedAnswer == state.quizData!.correct
                        ? Colors.green[800]
                        : Colors.red[800],
                    fontSize: 18),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOption(
      WidgetRef ref, QuizState state, String key, String value) {
    final isSelected = state.selectedAnswer == key;
    final isCorrect = state.quizData!.correct == key;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected
              ? (isCorrect ? Colors.green[400] : Colors.red[400])
              : Colors.blue[400],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.all(16),
          elevation: 5,
        ),
        onPressed: state.selectedAnswer == null
            ? () => ref.read(quizProvider.notifier).selectAnswer(key)
            : null,
        child: Text('$key: $value',
            style: const TextStyle(color: Colors.white, fontSize: 16)),
      ),
    );
  }
}

class PuzzleCard extends StatelessWidget {
  final Color color;
  final Widget child;

  const PuzzleCard({required this.color, required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const PuzzleShape(),
      color: color,
      elevation: 5,
      child: Padding(padding: const EdgeInsets.all(16.0), child: child),
    );
  }
}

class PuzzleShape extends ShapeBorder {
  const PuzzleShape();

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      getOuterPath(rect);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final path = Path();
    final tab = rect.width * 0.1;
    path
      ..moveTo(rect.left, rect.top)
      ..lineTo(rect.right - tab, rect.top)
      ..relativeArcToPoint(Offset(tab, tab), radius: const Radius.circular(10))
      ..lineTo(rect.right, rect.bottom - tab)
      ..relativeArcToPoint(Offset(-tab, tab), radius: const Radius.circular(10))
      ..lineTo(rect.left, rect.bottom)
      ..close();
    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;
}
