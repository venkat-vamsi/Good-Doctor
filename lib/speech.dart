import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';

// Main entry point for the application
void main() {
  runApp(const MyApp());
}

// The root widget of the application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Speech Recordings',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFFF0F2F5),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Inter',
        textTheme: const TextTheme(
          headlineMedium:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
          titleLarge:
              TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
          bodyMedium: TextStyle(color: Colors.black54, height: 1.5),
        ),
      ),
      home: const SessionsScreen(),
    );
  }
}

//
// --- Data Models ---
// These classes represent the structure of the data from our backend.
//

class RecordingSession {
  final String sessionId;
  final String title;
  final DateTime sessionDate;
  final List<SpeechRecording> recordings;

  RecordingSession({
    required this.sessionId,
    required this.title,
    required this.sessionDate,
    required this.recordings,
  });

  factory RecordingSession.fromJson(Map<String, dynamic> json) {
    var recordingsList = json['recordings'] as List;
    List<SpeechRecording> recordings =
        recordingsList.map((i) => SpeechRecording.fromJson(i)).toList();

    // Sort recordings within the session by timestamp, latest first
    recordings.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return RecordingSession(
      sessionId: json['sessionId'],
      title: json['title'],
      sessionDate: DateTime.parse(json['sessionDate']),
      recordings: recordings,
    );
  }
}

class SpeechRecording {
  final String recordingId;
  final String text;
  final String audioUrl;
  final DateTime timestamp;

  SpeechRecording({
    required this.recordingId,
    required this.text,
    required this.audioUrl,
    required this.timestamp,
  });

  factory SpeechRecording.fromJson(Map<String, dynamic> json) {
    return SpeechRecording(
      recordingId: json['recordingId'],
      text: json['text'],
      audioUrl: json['audioUrl'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

//
// --- API Service ---
// This class handles fetching the data from your live AWS backend.
//

class ApiService {
  // Your live URL from API Gateway.
  final String _apiUrl =
      'https://1hx2s2h204.execute-api.us-east-1.amazonaws.com/prod/sessions';

  Future<List<RecordingSession>> getRecordingSessions() async {
    print("Attempting to fetch REAL data from your live AWS backend...");
    try {
      final response = await http.get(Uri.parse(_apiUrl));

      if (response.statusCode == 200) {
        // Handle case where body might be empty but successful
        if (response.body.isEmpty) {
          print(
              "✅ Successfully fetched data from AWS, but the response body is empty. Returning empty list.");
          return [];
        }

        final List<dynamic> sessionsJson = json.decode(response.body);
        print("✅ Successfully fetched data from AWS!");

        List<RecordingSession> sessions = sessionsJson
            .map((json) => RecordingSession.fromJson(json))
            .toList();

        // Sort sessions by date, latest first
        sessions.sort((a, b) => b.sessionDate.compareTo(a.sessionDate));

        return sessions;
      } else {
        print(
            "❌ Error from API Gateway/Lambda. Status code: ${response.statusCode}");
        print("Server response: ${response.body}");
        throw Exception(
            'Failed to load sessions. The server returned an error.');
      }
    } catch (e) {
      print("❌ A network or other error occurred: $e");
      throw Exception(
          'Could not connect to the server. Please check your internet connection and the API URL.');
    }
  }
}

//
// --- UI Screens ---
//

// Displays the list of all recording sessions
class SessionsScreen extends StatefulWidget {
  const SessionsScreen({super.key});

  @override
  State<SessionsScreen> createState() => _SessionsScreenState();
}

class _SessionsScreenState extends State<SessionsScreen> {
  late Future<List<RecordingSession>> _sessionsFuture;

  @override
  void initState() {
    super.initState();
    _sessionsFuture = ApiService().getRecordingSessions();
  }

  void _refreshSessions() {
    setState(() {
      _sessionsFuture = ApiService().getRecordingSessions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speech Sessions',
            style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 1,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshSessions,
          ),
        ],
      ),
      body: FutureBuilder<List<RecordingSession>>(
        future: _sessionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Error: ${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red)),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No recording sessions found.'));
          }

          final sessions = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: sessions.length,
            itemBuilder: (context, index) {
              final session = sessions[index];
              return Card(
                elevation: 2,
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  title: Text(session.title,
                      style: Theme.of(context).textTheme.titleLarge),
                  subtitle: Text('${session.recordings.length} recordings'),
                  trailing: const Icon(Icons.arrow_forward_ios,
                      size: 16, color: Colors.grey),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SessionDetailScreen(session: session),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// Displays the details of a single session (recordings and text)
class SessionDetailScreen extends StatelessWidget {
  final RecordingSession session;
  const SessionDetailScreen({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          session.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
        ),
        elevation: 1,
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: session.recordings.length,
        itemBuilder: (context, index) {
          final recording = session.recordings[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Question asked at: ${DateFormat.jm().format(recording.timestamp.toLocal())}',
                    style: TextStyle(
                        color: Colors.grey[600], fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '"${recording.text}"',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontSize: 16, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 16),
                  AudioPlayerWidget(audioUrl: recording.audioUrl),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

//
// --- Reusable Widgets ---
//

// A widget that plays audio from a URL
class AudioPlayerWidget extends StatefulWidget {
  final String audioUrl;
  const AudioPlayerWidget({super.key, required this.audioUrl});

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
  }

  Future<void> _initAudioPlayer() async {
    try {
      setState(() => _isLoading = true);
      // The pre-signed URL from S3 can be used directly here.
      await _audioPlayer.setUrl(widget.audioUrl);
    } catch (e) {
      print("Error loading audio source: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading audio: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          StreamBuilder<PlayerState>(
            stream: _audioPlayer.playerStateStream,
            builder: (context, snapshot) {
              final playerState = snapshot.data;
              final processingState = playerState?.processingState;
              final playing = playerState?.playing;

              if (_isLoading ||
                  processingState == ProcessingState.loading ||
                  processingState == ProcessingState.buffering) {
                return const SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(strokeWidth: 2));
              } else if (playing != true) {
                return IconButton(
                  icon: const Icon(Icons.play_arrow),
                  iconSize: 24,
                  onPressed: _audioPlayer.play,
                );
              } else if (processingState != ProcessingState.completed) {
                return IconButton(
                  icon: const Icon(Icons.pause),
                  iconSize: 24,
                  onPressed: _audioPlayer.pause,
                );
              } else {
                return IconButton(
                  icon: const Icon(Icons.replay),
                  iconSize: 24,
                  onPressed: () => _audioPlayer.seek(Duration.zero),
                );
              }
            },
          ),
          Expanded(
            child: StreamBuilder<Duration>(
              stream: _audioPlayer.positionStream,
              builder: (context, snapshot) {
                final position = snapshot.data ?? Duration.zero;
                final duration = _audioPlayer.duration ?? Duration.zero;
                return Slider(
                  min: 0.0,
                  max: duration.inSeconds.toDouble(),
                  value: position.inSeconds
                      .toDouble()
                      .clamp(0.0, duration.inSeconds.toDouble()),
                  onChanged: (value) {
                    _audioPlayer.seek(Duration(seconds: value.toInt()));
                  },
                  activeColor: Colors.deepPurple,
                  inactiveColor: Colors.deepPurple.withOpacity(0.3),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
