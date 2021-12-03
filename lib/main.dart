import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class SignUpScreen extends StatefulWidget {
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailCreateController = TextEditingController();
  final _passwordCreateController = TextEditingController();
  String _email = '';
  String _password = '';
  final _formkey = GlobalKey<FormState>();

  Future<void> signUp(String email, String password) async {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    await Firebase.initializeApp();
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      Navigator.pop(context);
      print("HOLLY SHIT, I'M INCREDIBLE!");
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "email-already-in-use":
          return showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                    title: Text(S.of(context).error),
                    content: Text(S.of(context).error_email_already_exist),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("OK"),
                      )
                    ]);
              });
        default:
          print("FUCK!");
          break;
      }
    }
  }

  void createAccount() {
    SystemChannels.textInput.invokeMethod("TextInput.hide");
    final form = _formkey.currentState;
    form!.validate() ? form.save() : null;
    signUp(_email, _password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Form(
          key: _formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailCreateController,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                onSaved: (val) => _email = val!,
                validator: (val) {
                  return !val!.contains("@")
                      ? S.of(context).email_validation_error
                      : null;
                },
                decoration: InputDecoration(
                    labelText: S.of(context).email_place_holder),
              ),
              TextFormField(
                controller: _passwordCreateController,
                textAlign: TextAlign.center,
                obscureText: true,
                onSaved: (val) => _password = val!,
                decoration: InputDecoration(
                    labelText: S.of(context).password_place_holder),
              ),
              MaterialButton(
                  child: Text(S.of(context).sign_up_button),
                  onPressed: () => createAccount()),
            ],
          ),
        ),
      ),
    );
  }
}

class AuthScreen extends StatefulWidget {
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  String _email = "";
  String _password = "";
  final _formkey = GlobalKey<FormState>();

  Future<void> signIn(String email, String password) async {
    await Firebase.initializeApp();
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      //print("OK,I'M IN");
      if (FirebaseAuth.instance.currentUser != null) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ChatScreen(name: _email)));
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "user-not-found":
          return showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(S.of(context).error),
                  content: Text(S.of(context).error_of_email),
                  actions: <Widget>[
                    TextButton(
                      child: const Text("OK"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              });
        case "wrong-password":
          return showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(S.of(context).error),
                  content: Text(S.of(context).error_of_password),
                  actions: <Widget>[
                    TextButton(
                      child: const Text("OK"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              });
        default:
          print(e.code.hashCode);
          break;
      }
    }
  }

  void submit() {
    SystemChannels.textInput.invokeMethod("TextInput.hide");
    final form = _formkey.currentState;
    form!.validate() ? form.save() : null;
    signIn(_email, _password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Form(
          key: _formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                textAlign: TextAlign.center,
                controller: _emailTextController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: S.of(context).email_place_holder,
                  labelText: S.of(context).email_place_holder,
                ),
                onSaved: (val) => _email = val!,
                validator: (val) {
                  return !val!.contains("@")
                      ? S.of(context).email_validation_error
                      : null;
                },
              ),
              TextFormField(
                textAlign: TextAlign.center,
                controller: _passwordTextController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: S.of(context).password_place_holder,
                  labelText: S.of(context).password_place_holder,
                ),
                onSaved: (val) => _password = val!,
              ),
              MaterialButton(
                child: Text(S.of(context).sign_in_button,
                    style: Theme.of(context).textTheme.button),
                onPressed: () => submit(),
              ),
              MaterialButton(
                  child: Text(S.of(context).sign_up_button,
                      style: Theme.of(context).textTheme.button),
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignUpScreen()))),
            ],
          ),
        ),
      ),
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: Theme.of(context).textTheme.headline4),
                  Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: Text(text, maxLines: null),
                  ),
                ],
              ),
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
    } on FirebaseAuthException catch (e) {}
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
                maxLines: null,
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
