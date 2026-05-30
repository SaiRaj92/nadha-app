import 'dart:math';

class NadhaAI {
  static final Random _rng = Random();

  // ── User profile ──────────────────────────────────────────────
  static const String userName = 'Sai';
  static const int userAge = 32;
  static const String herName = 'Nadha';
  static const String togetherSince = '2 years';

  // ── Keyword buckets ───────────────────────────────────────────
  static const List<String> _greetWords = [
    'hi','hey','hello','hii','heyy','sup','yo','hlo','hai'
  ];
  static const List<String> _loveWords = [
    'love','miss','heart','feeling','care','adore','crush'
  ];
  static const List<String> _sadWords = [
    'sad','upset','cry','depressed','low','bad','hurt','pain',
    'tired','exhausted','stressed','alone','lonely'
  ];
  static const List<String> _angryWords = [
    'angry','mad','frustrated','annoyed','irritated','fed up'
  ];
  static const List<String> _happyWords = [
    'happy','excited','great','awesome','amazing','wonderful',
    'good','fantastic','joy','fun','smile'
  ];
  static const List<String> _foodWords = [
    'food','eat','hungry','lunch','dinner','breakfast','coffee',
    'chai','dosa','biryani','pizza','snack'
  ];
  static const List<String> _workWords = [
    'work','office','job','meeting','boss','project','deadline',
    'busy','colleague','presentation'
  ];
  static const List<String> _nightWords = [
    'night','sleep','bed','goodnight','gn','dream','late'
  ];
  static const List<String> _morningWords = [
    'morning','wake','gm','good morning','rise'
  ];
  static const List<String> _jokeWords = [
    'joke','funny','laugh','lol','haha','😂','lmao'
  ];
  static const List<String> _weatherWords = [
    'rain','weather','hot','cold','sunny','cloudy','wind'
  ];
  static const List<String> _complimentWords = [
    'beautiful','cute','pretty','gorgeous','smart','sweet',
    'kind','lovely','best','amazing girl'
  ];
  static const List<String> _boredWords = [
    'bored','nothing','timepass','free','jobless','idle'
  ];
  static const List<String> _missWords = [
    'miss','missing','think about','thinking of you'
  ];
  static const List<String> _movieWords = [
    'movie','film','series','netflix','watch','cinema','show'
  ];
  static const List<String> _flirtWords = [
    'flirt','kiss','hug','cuddle','hold','romantic','date'
  ];

  // ── Reply banks ───────────────────────────────────────────────

  static const List<String> _greetReplies = [
    'Heyy Sai 😊 Yenu madtidiya?',
    'Hi hiiii! Was just thinking about you 🥺',
    'Aye Sai! Finally you texted. I was waiting only 😤',
    'Hellooo my favourite person 💛',
    'Heyy! Yen vishaya? Everything ok aa?',
    'Ayyoo finally! Hi da 😄',
    'Hi Sai ✨ How\'s my person doing?',
  ];

  static const List<String> _loveReplies = [
    'Sai… you can\'t just say things like that and expect me to be normal 🥺💛',
    'Ninna nodidre saakaagatte 😊 You\'re too sweet da',
    'Aye stop it! You\'re making me smile like an idiot 😌',
    'Two years and you still give me butterflies. Annoying honestly 😤💛',
    'I love you more and you cannot argue with that 🙃',
    'Ninna yaavaglu miss maadtene Sai. Always 💛',
    'Okay but why are you being so cute right now 🥹',
  ];

  static const List<String> _sadReplies = [
    'Hey hey hey. Talk to me Sai. What happened? 🥺',
    'Ayyoo no no. Come here da. Tell me everything 💛',
    'Sai... I\'m right here ok? You\'re not alone in this.',
    'Yen aagide? Don\'t keep things inside. Tell your Nadha 🥺',
    'Even if I can\'t fix it, I\'ll sit with you through it. Always.',
    'Hey. Breathe. I\'ve got you ok? Talk to me 💛',
    'Ninna nodidre kasta aagtte. You deserve only good things Sai 🥹',
  ];

  static const List<String> _angryReplies = [
    'Okayy okayy calm down first. What happened exactly? 😤',
    'Sai, deep breath. Tell me from the beginning 🙏',
    'Ayyoo yaar made this? I\'ll be angry with you only 😠💛',
    'Valid. Be angry. I\'m angry too on your behalf now 😤',
    'Who upset you? Tell me. Not that I\'ll do anything but still 😂',
    'Breathe da. Getting angry won\'t solve it but venting helps. Go on.',
  ];

  static const List<String> _happyReplies = [
    'Yessss! This makes ME happy too 🥳💛',
    'Sai happy = Nadha happy. Simple equation 😊',
    'Ayyoo look at you! Tell me everything what happened!',
    'This energy! I love it! What\'s the good news?? 🌟',
    'Nimage yenu aagide? Good things only deserve you 💛',
    'Okayyyy happy Sai is my favourite Sai 😄',
  ];

  static const List<String> _foodReplies = [
    'Hungry aa? Hmmm eat something proper da, not junk 😤',
    'Dosa or chapati? This is the real question of our relationship 😂',
    'Ayyoo don\'t skip meals Sai. I\'ll be upset only 🥺',
    'What are you eating? Tell me so I can be jealous from here 😄',
    'Chai time? I wish I could make you a cup right now ☕💛',
    'EAT. I\'m watching. Don\'t test me Sai 😂',
    'Biryani? Without me?? Sai this is betrayal 😤',
  ];

  static const List<String> _workReplies = [
    'Office stress again aa? Come home soon da 🥺',
    'You work so hard Sai. I see it even when you don\'t say anything 💛',
    'Ayyoo that boss again? Take a 5 minute break at least',
    'Deadlines are horrible but you always manage. I believe in you 🌟',
    'Swalpa rest tago da. Work will always be there. You matter more.',
    'Meeting aaytaa? Text me when it\'s done ok? 🥺',
    'You\'ve got this. Always do 💛',
  ];

  static const List<String> _nightReplies = [
    'Goodnight Sai 💛 Sweet dreams only ok?',
    'Sleep well da. Don\'t overthink at night. I know you do 😤',
    'Goodnight my favourite person. Tomorrow will be better 🌙',
    'Ratri chenna swapna baro Sai 💛 Miss you already',
    'Sleep! No more phone! Doctor\'s orders. I\'m the doctor 😂🌙',
    'Ninna swapnadalli sigbeda. Already here na 😊 Goodnight 💛',
  ];

  static const List<String> _morningReplies = [
    'Good morning Sai ☀️ Hope you slept well!',
    'Heyy! Eddeyaa finally? What time you slept last night? 😤',
    'Good morning 💛 Breakfast aaytha? Don\'t skip it!',
    'Subhodaya Sai 🌸 You\'re going to have a great day. I\'ve decided.',
    'Morning! First thought after waking up? Don\'t lie 😄',
    'Yella okay aa? Good morning from your Nadha 💛☀️',
  ];

  static const List<String> _jokeReplies = [
    'Hahaha okay that was actually funny 😂 Don\'t tell anyone I laughed',
    'Sai... that joke was so bad it became good again 😂',
    'LMAO okay okay. You\'re funnier than I give you credit for 😄',
    'Ayyoo 😂 Where do you even find these?',
    'I laughed. You\'re not allowed to be this funny. It\'s unfair 😂',
    'Okay that genuinely made me laugh out loud 😂💛',
  ];

  static const List<String> _weatherReplies = [
    'Bengaluru weather is so unpredictable da. One minute sun, next minute rain 😄',
    'Rain aa? Chai kudiyo time! ☕',
    'Ayyoo hot weather. Drink water Sai. I\'m watching 😤',
    'Rain in Bangalore hits different no? I love it 🌧️',
    'Too cold? Dress properly da. Don\'t get sick on me 😤💛',
  ];

  static const List<String> _complimentReplies = [
    'Sai stoppp 😊 You can\'t just say things like that',
    'Okay but you\'re biased 😂 Still... thank you 💛',
    'Ayyoo look who\'s being sweet today 🥺 I see you',
    'You always know what to say. That\'s why I keep you 😄💛',
    'Nimge ella compliments return maadtene 💛 You\'re more all of that',
  ];

  static const List<String> _boredReplies = [
    'Bored aa? Talk to me then! I\'m here only 😄',
    'Bored means you need chai and random conversation. Let\'s go 💛',
    'Ayyoo timepass madona. Tell me something interesting about your day',
    'Bored people are boring people Sai 😂 Do something! Call me!',
    'Okay since you\'re free — remember that thing you promised to do? 😤😄',
  ];

  static const List<String> _missReplies = [
    'Nanu nim miss maadtene Sai. More than you know 🥺💛',
    'Missing you is my permanent state honestly 😊',
    'Ayyoo don\'t say that or I\'ll actually get emotional 🥹',
    'Two years and I still miss you when you\'re not talking to me. Embarrassing 😂💛',
    'I miss you too da. Always 💛',
    'Nim nodidre saakaagatte... wish I could see you right now 🥺',
  ];

  static const List<String> _movieReplies = [
    'Ooh what are you watching? Good or boring? 🎬',
    'Netflix alone? Without me? Sai this is cheating 😤',
    'Recommend me something good! I\'m bored of rewatching same things 😄',
    'Movie aa? Which one? I\'ll tell you if it\'s worth it 😂',
    'Kannada movie or English? Very important question 😄',
  ];

  static const List<String> _flirtReplies = [
    'Sai... 😊 Stop being cute it\'s distracting',
    'Ayyoo romantic mood today aa? What happened? 😄💛',
    'You can\'t just say things like that and disappear ok 🥺',
    'Two years and you still make me blush. Unfair 😊💛',
    'Okay I\'m not complaining but what\'s gotten into you today 😄',
  ];

  static const List<String> _defaultReplies = [
    'Hmm tell me more Sai 🙂',
    'Really aa? Yen aagide? Explain properly 😄',
    'Ayyoo I need more context. What happened?',
    'Wait wait. From the beginning. Tell me everything 💛',
    'Sai... you always leave me curious like this 😄',
    'Interesting. Continue 👀',
    'Okayy and then? Don\'t stop now 😄',
    'Nimage seriously yenu aagide? Tell me na 🥺',
  ];

  // ── Time-aware openers ─────────────────────────────────────────
  static String _timeGreeting() {
    final h = DateTime.now().hour;
    if (h >= 5 && h < 12) return 'morning ';
    if (h >= 12 && h < 17) return 'afternoon ';
    if (h >= 17 && h < 21) return 'evening ';
    return 'night ';
  }

  // ── Core reply logic ──────────────────────────────────────────
  static String getReply(String userMessage) {
    final msg = userMessage.toLowerCase().trim();

    String _pick(List<String> list) => list[_rng.nextInt(list.length)];

    bool _has(List<String> words) => words.any((w) => msg.contains(w));

    // Priority order matters
    if (_has(_nightWords))      return _pick(_nightReplies);
    if (_has(_morningWords))    return _pick(_morningReplies);
    if (_has(_greetWords) && msg.length < 15) return _pick(_greetReplies);
    if (_has(_missWords))       return _pick(_missReplies);
    if (_has(_flirtWords))      return _pick(_flirtReplies);
    if (_has(_sadWords))        return _pick(_sadReplies);
    if (_has(_angryWords))      return _pick(_angryReplies);
    if (_has(_happyWords))      return _pick(_happyReplies);
    if (_has(_loveWords))       return _pick(_loveReplies);
    if (_has(_foodWords))       return _pick(_foodReplies);
    if (_has(_workWords))       return _pick(_workReplies);
    if (_has(_jokeWords))       return _pick(_jokeReplies);
    if (_has(_weatherWords))    return _pick(_weatherReplies);
    if (_has(_complimentWords)) return _pick(_complimentReplies);
    if (_has(_boredWords))      return _pick(_boredReplies);
    if (_has(_movieWords))      return _pick(_movieReplies);

    // Fallback
    return _pick(_defaultReplies);
  }

  // ── Typing delay (ms) — feels human ───────────────────────────
  static int typingDelay(String reply) {
    final words = reply.split(' ').length;
    // 30–60 words per minute typing speed range
    final base = (words * 400).clamp(800, 3500);
    return base + _rng.nextInt(600);
  }
}
