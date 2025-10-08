import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../services/quiz_service.dart';

final quizProvider = StateNotifierProvider<QuizNotifier, QuizState>((ref) {
  return QuizNotifier(ref);
});

class QuizState {
  final QuizData? quizData;
  final String? selectedAnswer;
  final bool isLoading;
  final String? error;

  QuizState({
    this.quizData,
    this.selectedAnswer,
    this.isLoading = false,
    this.error,
  });

  QuizState copyWith({
    QuizData? quizData,
    String? selectedAnswer,
    bool? isLoading,
    String? error,
  }) {
    return QuizState(
      quizData: quizData ?? this.quizData,
      selectedAnswer: selectedAnswer ?? this.selectedAnswer,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class QuizNotifier extends StateNotifier<QuizState> {
  QuizNotifier(Ref ref) : super(QuizState());

  Future<void> fetchQuiz() async {
    // Reset state before fetching a new quiz
    state = QuizState(isLoading: true);

    try {
      final quizData = await QuizService().generateDailyQuiz();
      state = state.copyWith(quizData: quizData, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void selectAnswer(String answer) {
    state = state.copyWith(selectedAnswer: answer);
  }

  bool isCorrect() =>
      state.selectedAnswer != null &&
      state.selectedAnswer == state.quizData?.correct;
}
