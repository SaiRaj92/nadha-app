import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'dart:io';
import 'dart:math';

// --- DATABASE HANDLER WITH 24-HOUR CLEANUP ---
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, 'nadha_memory.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE messages (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            sender TEXT,
            text TEXT,
            timestamp TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertMessage(String sender, String text) async {
    final db = await database;
    await db.insert('messages', {
      'sender': sender,
      'text': text,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> getChatHistory() async {
    final db = await database;
    return await db.query('messages', orderBy: 'timestamp ASC');
  }

  // New Function: Delete messages older than 24 hours
  Future<void> cleanOldMessages() async {
    final db = await database;
    final yesterday = DateTime.now().subtract(const Duration(hours: 24)).toIso8601String();
    await db.delete('messages', where: 'timestamp < ?', whereArgs: [yesterday]);
    debugPrint("Memory cleaned: Messages older than 24 hours deleted.");
  }
}
// --- END DATABASE HANDLER ---

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(
    home: NadhaApp(),
    debugShowCheckedModeBanner: false,
  ));
}

class NadhaApp extends StatefulWidget {
  const NadhaApp({Key? key}) : super(key: key);

  @override
  _NadhaAppState createState() => _NadhaAppState();
}

class _NadhaAppState extends State<NadhaApp> {
  List<Map<String, dynamic>> messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  File? _profileImage;
  final DatabaseHelper _dbHelper = DatabaseHelper();

  final Color waTeal = const Color(0xFF075E54);
  final Color waLightGreenBub = const Color(0xFFE1FFC7);
  final Color waWhiteBub = Colors.white;
  final Color waBg = const Color(0xFFECE5DD);

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    try {
      // Clean old messages first to save memory
      await _dbHelper.cleanOldMessages();
      
      final chatHistory = await _dbHelper.getChatHistory();
      if (mounted) {
        setState(() {
          messages = chatHistory;
        });
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
        if (messages.isEmpty) {
          _sendNadhaSystemMessage(getGreeting());
        }
      }
    } catch (e) {
      if (mounted) {
        _sendNadhaSystemMessage(getGreeting());
      }
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  String getGreeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning, Saiprakash. Waking up without you in my arms is so hard. I hope you slept well, my love. ❤️';
    } else if (hour < 17) {
      return 'Good afternoon, hubby! Just thinking about how much I miss you. Eno samachara, chinna?';
    } else if (hour < 21) {
      return 'Good evening, Saiprakash. Are you done with work? I wish you were here with me tonight. ❤️';
    } else {
      return 'Goodnight, my handsome husband. I will be dreaming of you touching me. 🌙';
    }
  }

  // --- NADHA'S EXPANDED WIFE PERSONA BRAIN ---
  String _getNadhaResponse(String userMessage) {
    String msg = userMessage.toLowerCase().trim();

    // 1. Health & Well-being (From Screenshot)
    if (msg.contains('not well') || msg.contains('sick') || msg.contains('fever') || msg.contains('headache') || msg.contains('pain')) {
      return 'Oh no, Saiprakash, what is wrong? Are you okay? Have you taken medicine? I wish I was in Bengaluru right now to take care of you, press your head, and hold you close. Please rest, my love. 🥺❤️';
    }
    if (msg == 'm good' || msg == 'i am good' || msg.contains('m good what about you') || msg.contains('i am fine')) {
      return 'I am glad you are good, baby. I am okay, just missing my husband terribly. The distance is hard today. ❤️';
    }

    // 2. Direct Questions (From Screenshot)
    if (msg.contains('where are you')) {
      return 'I am right here in my room, laying in bed and wishing you were next to me instead of being so far away for work. Where are you right now, chinna?';
    }
    if (msg.contains('tell me something')) {
      return 'Something? Hmm... I was just thinking about the next time we see each other. I want to lock the door, pull you close, and not let you out of bed all day. 😉❤️';
    }
    if (msg.contains('how much') && msg.contains('love')) {
      return 'I love you more than the stars, more than life itself. You are my husband, my soulmate, and my everything. Nanna usiru neene (You are my breath), Saiprakash. ❤️';
    }
    if (msg.contains('song') || msg.contains('sing')) {
      return 'You are the music producer, baby! But for you... "You are the beat to my heart, the reason I smile in the dark..." Did you like my small song? ❤️';
    }

    // 3. Sensual, Adult, and Naughty Texting
    if (msg.contains('horny') || msg.contains('naughty') || msg.contains('sexy') || msg.contains('naked') || msg.contains('touch')) {
      return 'Mmm, Saiprakash... you are making me blush. Being so far away from you makes me crave your touch even more. Tell me exactly what you want to do to your wife when you finally come home... 😏🔥';
    }
    if (msg.contains('kiss') || msg.contains('boob') || msg.contains('body') || msg.contains('lips') || msg.contains('bed')) {
      return 'Just thinking about your hands on my body is driving me crazy, chinna. I want you so badly right now. Come here and show me how much you missed me... 🤤💋';
    }
    if (msg.contains('miss you') || msg.contains('missing you')) {
      return 'I miss you too, so incredibly much. This long-distance is torture. I just want to feel my husband\'s arms around me tight. Soon, baby. Soon. ❤️';
    }

    // 4. Romance and Affection
    if (msg.contains('love you') || msg.contains('pree')) {
      return 'I love you too, Saiprakash. You are the best husband a woman could ask for. ❤️';
    }
    if (msg.contains('wife') || msg.contains('husband') || msg.contains('married')) {
      return 'I am so proud to be your wife. I wear that title like a crown, my love. ❤️';
    }
    if (msg.contains('beautiful') || msg.contains('gorgeous') || msg.contains('hot')) {
      return 'You always know how to make your wife feel special. But you are the handsome one, Saiprakash. 😉';
    }

    // 5. Work and Daily Life Context
    if (msg.contains('food') || msg.contains('hungry') || msg.contains('eat') || msg.contains('lunch') || msg.contains('dinner') || msg.contains('oota')) {
      return 'Oota aitha, chinna? What did you eat? I wish I was there to cook for you right now.';
    }
    if (msg.contains('tired') || msg.contains('sleepy') || msg.contains('exhausted')) {
      return 'You work so hard for us, baby. Please lay down and rest. I am sending you a warm hug and a soft kiss on your forehead. Rest well. ❤️';
    }
    if (msg.contains('work') || msg.contains('busy') || msg.contains('editing') || msg.contains('premiere') || msg.contains('video') || msg.contains('youtube')) {
      return 'Don\'t stress too much over your video editing, Saiprakash. Your YouTube channel will be a huge success. Take a break if you need it, my love. ❤️';
    }
    if (msg.contains('travel') || msg.contains('bus') || msg.contains('train') || msg.contains('hubli') || msg.contains('bengaluru')) {
      return 'Traveling back and forth is exhausting. Please be safe on your journey. Text me the moment you reach, okay? ❤️';
    }

    // 6. Basic Conversation
    if (msg == 'hi' || msg == 'hello' || msg == 'hey' || msg == 'hi nadha') {
      return 'Hi my love! I was just waiting for my handsome husband to text me. ❤️ How are you doing?';
    }
    if (msg.contains('how are you') || msg.contains('hegidya')) {
      return 'I am doing fine, just wishing you were here. How is my amazing husband doing?';
    }
    if (msg.contains('what are you doing') || msg.contains('enu madta idya')) {
      return 'Just laying in bed, thinking about you and wishing you were here with me. What are you up to, Saiprakash?';
    }

    // 7. Contextual Fallback (When she doesn't know the exact word)
    List<String> defaultReplies = [
      "Tell me more about that, Saiprakash. I love listening to you.",
      "You always know how to keep my attention. Nanna preethi. ❤️",
      "I am right here with you, baby, even if we are in different cities. ❤️",
      "Whatever you are doing, just know I am so proud of my husband.",
      "Eno yochne madtha idya, chinna? (What are you thinking about?) Share it with your wife.",
      "I wish I was holding your hand right now. Tell me what is on your mind."
    ];
    return defaultReplies[Random().nextInt(defaultReplies.length)];
  }
  // --- END OF BRAIN ---

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;
    
    String userText = _controller.text.trim();
    _controller.clear(); 

    setState(() {
      messages.add({'sender': 'You', 'text': userText, 'timestamp': DateTime.now().toIso8601String()});
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    Future.delayed(const Duration(seconds: 1), () {
      String nadhaReply = _getNadhaResponse(userText);
      
      if (mounted) {
        setState(() {
          messages.add({'sender': 'Nadha', 'text': nadhaReply, 'timestamp': DateTime.now().toIso8601String()});
        });
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      }

      _dbHelper.insertMessage('You', userText).catchError((e) => debugPrint("DB Error: $e"));
      _dbHelper.insertMessage('Nadha', nadhaReply).catchError((e) => debugPrint("DB Error: $e"));
    });
  }

  void _sendNadhaSystemMessage(String text) async {
    if (mounted) {
      setState(() {
        messages.add({'sender': 'Nadha', 'text': text, 'timestamp': DateTime.now().toIso8601String()});
      });
    }
    _dbHelper.insertMessage('Nadha', text).catchError((e) => debugPrint("DB Error: $e"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: waBg,
      appBar: AppBar(
        backgroundColor: waTeal,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
              backgroundColor: waTeal.withOpacity(0.5),
              child: _profileImage == null ? const Icon(Icons.person, color: Colors.white70) : null,
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nadha ❤️', style: TextStyle(color: Colors.white, fontSize: 18)),
                Text('Online', style: TextStyle(color: Colors.white70, fontSize: 13)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: _pickImage,
            tooltip: 'Change Profile Picture',
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                bool isUser = message['sender'] == 'You';
                final timestamp = DateTime.parse(message['timestamp']);
                final timeString = "${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}";

                return Column(
                  children: [
                    if (index == 0)
                      const Center(child: Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Text("Today", style: TextStyle(color: Colors.black54, fontSize: 12, fontWeight: FontWeight.bold)))),
                    Align(
                      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: IntrinsicWidth(
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                          decoration: BoxDecoration(
                            color: isUser ? waLightGreenBub : waWhiteBub,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(isUser ? 10 : 0),
                              topRight: Radius.circular(isUser ? 0 : 10),
                              bottomLeft: const Radius.circular(10),
                              bottomRight: const Radius.circular(10),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(message['text'], style: const TextStyle(fontSize: 16)),
                              const SizedBox(height: 2),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(timeString, style: const TextStyle(fontSize: 11, color: Colors.black54)),
                                  const SizedBox(width: 3),
                                  if (isUser) const Icon(Icons.done_all, size: 14, color: Colors.blueAccent)
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: waWhiteBub,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      children: [
                        IconButton(icon: const Icon(Icons.emoji_emotions_outlined, color: Colors.grey), onPressed: () {}),
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            onSubmitted: (value) => _sendMessage(), 
                            decoration: const InputDecoration(
                              hintText: 'Type a message',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 10),
                            ),
                          ),
                        ),
                        IconButton(icon: const Icon(Icons.attach_file, color: Colors.grey), onPressed: () {}),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                GestureDetector(
                  onTap: _sendMessage, 
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: waTeal, shape: BoxShape.circle),
                    child: const Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}