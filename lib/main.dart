import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  runApp(
    FriendlyChatApp(),
  );
}

class AuthScreen extends StatefulWidget {
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  Future<void> signUp() async {
    await Firebase.initializeApp();
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: "AB@fuckingSlaves.com", password: "VGLASS");
      print("HOLLY SHIT, I'M INCREDIBLE!");
    } on FirebaseAuthException catch (e) {
      //print(e.code.toString());
    }
  }

  Future<void> signIn(String email, String password) async {
    await Firebase.initializeApp();
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      print("OK,I'M IN");
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => ChatScreen(name: email)));
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "user-not-found":
          print("No user found");
          break;
        case "wrong-password":
          print("Wrong passord");
          break;
        default:
          print(e.code.toString());
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: _buildAuthText(),
      ),
    );
  }

  Widget _buildAuthText() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          textAlign: TextAlign.center,
          controller: _emailTextController,
          onSubmitted: (name) => {name = _emailTextController.text},
          decoration: InputDecoration.collapsed(
              hintText: S.of(context).email_place_holder),
        ),
        TextField(
          textAlign: TextAlign.center,
          controller: _passwordTextController,
          decoration: InputDecoration.collapsed(
              hintText: S.of(context).password_place_holder),
        ),
        MaterialButton(
          child: Text(S.of(context).sign_in_button),
          onPressed: () async => await signIn(
              _emailTextController.text, _passwordTextController.text),
        ),
      ],
    );
  }
}

class FriendlyChatApp extends StatefulWidget {
  _FriendlyChatAppState createState() => _FriendlyChatAppState();
}

class _FriendlyChatAppState extends State<FriendlyChatApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          throw Exception("Error of connection");
        }
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return AdaptiveTheme(
              light: themeLight,
              dark: themeDark,
              initial: AdaptiveThemeMode.light,
              builder: (theme, darkTheme) => MaterialApp(
                localizationsDelegates: [
                  S.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: S.delegate.supportedLocales,
                title: "FriendlyChat",
                home: AuthScreen(),
                theme: theme,
                darkTheme: darkTheme,
              ),
            );
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
          case ConnectionState.none:
            return Center(
              child: Text(S.of(context).none),
            );
          default:
            return Center(child: Text(""));
        }
      },
    );
  }
}

class ChatMessage extends StatelessWidget {
  const ChatMessage({
    required this.name,
    required this.text,
    required this.animationController,
    Key? key,
  }) : super(key: key);
  final String text;
  final AnimationController animationController;
  final String name;
  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity:
          CurvedAnimation(parent: animationController, curve: Curves.bounceIn),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(child: Text(name[0])),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name[0], style: Theme.of(context).textTheme.headline4),
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: Text(text),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String name;
  const ChatScreen({required this.name, Key? key}) : super(key: key);
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final List<ChatMessage> _messages = [];
  final _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isComposing = false;
  Future<void> signOut() async {
    await Firebase.initializeApp();
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pop(context);
    } catch (e) {}
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async => await signOut(),
              icon: Icon(Icons.exit_to_app))
        ],
        title: Text(S.of(context).app_bar_title),
        leading: IconButton(
          icon: const Icon(Icons.dark_mode),
          onPressed: () => {
            AdaptiveTheme.of(context).mode.isDark
                ? AdaptiveTheme.of(context).setLight()
                : AdaptiveTheme.of(context).setDark()
          },
        ),
      ),
      body: Theme(
        data: Theme.of(context),
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                reverse: true,
                itemBuilder: (_, index) => _messages[index],
                itemCount: _messages.length,
              ),
            ),
            const Divider(
              height: 1.0,
            ),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
              ),
              child: _buildTextComposer(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).colorScheme.secondary),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                onChanged: (text) {
                  setState(() {
                    _isComposing = text.isNotEmpty;
                  });
                },
                decoration: InputDecoration.collapsed(
                    hintText: S.of(context).message_place_holder),
                focusNode: _focusNode,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: const Icon(Icons.send),
                color: Theme.of(context).primaryColor,
                onPressed: _isComposing
                    ? () => _handleSubmitted(_textController.text, widget.name)
                    : null,
              ),
            )
          ],
        ),
      ),
    );
  }

  void _handleSubmitted(String text, String name) {
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
    var message = ChatMessage(
        name: name,
        text: text,
        animationController: AnimationController(
          duration: const Duration(microseconds: 700),
          vsync: this,
        ));
    setState(() {
      _messages.insert(0, message);
    });
    _focusNode.requestFocus();
    message.animationController.forward();
  }

  void disponse() {
    for (var message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }
}
