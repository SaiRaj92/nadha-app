import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

enum Sender { me, nadha }

class Message {
  final String id;
  final String text;
  final Sender sender;
  final DateTime time;

  Message({
    required this.id,
    required this.text,
    required this.sender,
    required this.time,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'text': text,
    'sender': sender.name,
    'time': time.toIso8601String(),
  };

  factory Message.fromJson(Map<String, dynamic> j) => Message(
    id: j['id'],
    text: j['text'],
    sender: Sender.values.byName(j['sender']),
    time: DateTime.parse(j['time']),
  );
}

class StorageManager {
  static const String _messagesKey = 'nadha_messages';
  static const String _lastClearKey = 'nadha_last_clear';

  // Save messages to SharedPreferences
  static Future<void> saveMessages(List<Message> messages) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(messages.map((m) => m.toJson()).toList());
    await prefs.setString(_messagesKey, encoded);
  }

  // Load messages — auto-delete if older than 12 hours
  static Future<List<Message>> loadMessages() async {
    final prefs = await SharedPreferences.getInstance();

    // Check if 12 hours passed since last clear
    final lastClear = prefs.getString(_lastClearKey);
    if (lastClear != null) {
      final last = DateTime.parse(lastClear);
      if (DateTime.now().difference(last).inHours >= 12) {
        await prefs.remove(_messagesKey);
        await prefs.setString(_lastClearKey, DateTime.now().toIso8601String());
        return [];
      }
    } else {
      await prefs.setString(_lastClearKey, DateTime.now().toIso8601String());
    }

    final raw = prefs.getString(_messagesKey);
    if (raw == null) return [];

    final List decoded = jsonDecode(raw);
    return decoded.map((e) => Message.fromJson(e)).toList();
  }
}
