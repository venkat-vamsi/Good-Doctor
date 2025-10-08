import 'dart:convert';

import 'package:google_generative_ai/google_generative_ai.dart';

class QuizService {
  static const String _apiKey =
      'AIzaSyDVrjJ8D6fnffYJEVEp3Kri6hh9aLke0nI'; // Your key
  final _model = GenerativeModel(model: 'gemini-2.5-flash', apiKey: _apiKey);

  Future<QuizData> generateDailyQuiz() async {
    // Add a random topic or context to the prompt
    final randomTopic = _getRandomTopic(); // Randomly select a topic
    final prompt = '''
    Generate a role-play scenario for an autistic child to practice real-life conversations.
    The scenario should be related to $randomTopic.
    Provide:
    1. A short real-life scenario description (2-3 sentences).
    2. A question based on the scenario.
    3. Four answer options (label them A, B, C, D), with one correct answer.
    4. Indicate the correct answer.
    Format the response as VALID JSON with no additional text or markdown outside the JSON:
    {
      "scenario": "...",
      "question": "...",
      "options": {"A": "...", "B": "...", "C": "...", "D": "..."},
      "correct": "A/B/C/D"
    }
    ''';

    try {
      final response = await _model.generateContent([Content.text(prompt)]);
      final jsonString = response.text ?? '{}';
      print('Raw API Response: $jsonString'); // Log raw response
      final quiz = QuizData.fromJson(jsonString);
      return quiz;
    } catch (e) {
      print('Quiz generation failed: $e');
      throw Exception('Failed to generate quiz: $e');
    }
  }

  // Helper method to generate a random topic
  String _getRandomTopic() {
    final topics = [
      'a library',
      'a grocery store',
      'a park',
      'a school',
      'a restaurant',
      'a bus stop',
      'a playground',
      'a doctor\'s office',
      'a friend\'s house',
      'a shopping mall',
    ];
    final random = topics.toList()..shuffle();
    return random.first;
  }
}

class QuizData {
  final String scenario;
  final String question;
  final Map<String, String> options;
  final String correct;

  QuizData({
    required this.scenario,
    required this.question,
    required this.options,
    required this.correct,
  });

  factory QuizData.fromJson(String input) {
    try {
      // Clean up potential markdown or extra text
      String cleanInput = input.trim();
      if (cleanInput.startsWith('```json') && cleanInput.endsWith('```')) {
        cleanInput = cleanInput.substring(7, cleanInput.length - 3).trim();
      } else if (cleanInput.startsWith('```') && cleanInput.endsWith('```')) {
        cleanInput = cleanInput.substring(3, cleanInput.length - 3).trim();
      }

      final Map<String, dynamic> data = jsonDecode(cleanInput);
      final options = (data['options'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, value as String),
          ) ??
          {'A': 'Option A', 'B': 'Option B', 'C': 'Option C', 'D': 'Option D'};

      print('Parsed JSON: $data'); // Log successful parse
      return QuizData(
        scenario: data['scenario'] as String? ?? 'Default scenario',
        question: data['question'] as String? ?? 'Default question',
        options: options,
        correct: data['correct'] as String? ?? 'A',
      );
    } catch (e) {
      print('Parsing error: $e');
      print('Failed input: $input');
      // Fallback for plain text parsing
      final lines = input.split('\n').map((line) => line.trim()).toList();
      if (lines.length >= 6) {
        try {
          return QuizData(
            scenario: lines[0].replaceFirst('Scenario: ', ''),
            question: lines[1].replaceFirst('Question: ', ''),
            options: {
              'A': lines[2].replaceFirst('A: ', ''),
              'B': lines[3].replaceFirst('B: ', ''),
              'C': lines[4].replaceFirst('C: ', ''),
              'D': lines[5].replaceFirst('D: ', ''),
            },
            correct: lines[6].replaceFirst('Correct: ', ''),
          );
        } catch (e) {
          print('Plain text parsing failed: $e');
        }
      }
      // Ultimate fallback
      return QuizData(
        scenario: 'Error parsing scenario',
        question: 'What should you do?',
        options: {
          'A': 'Try again',
          'B': 'Wait',
          'C': 'Ask for help',
          'D': 'Skip'
        },
        correct: 'C',
      );
    }
  }
}
