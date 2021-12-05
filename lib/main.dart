import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  final _userNameCreateController = TextEditingController();
  final _phoneCreateController = TextEditingController();
  CollectionReference users = FirebaseFirestore.instance.collection("users");
  String _email = '';
  String _password = '';
  String _userName = '';
  String _phone = '';
  final _formkey = GlobalKey<FormState>();
  final _formkeyUser = GlobalKey<FormState>();
  void addUser() {
    final form = _formkeyUser.currentState;
    if (form!.validate()) {
      form.save();
      users
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({'userName': _userName, 'phone': _phone});
    }
  }

  Future<void> signUp(String email, String password) async {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: Text("User data"),
                content: Form(
                    key: _formkeyUser,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _userNameCreateController,
                          decoration: InputDecoration(labelText: "UserName"),
                          onSaved: (val) => _userName = val!,
                        ),
                        TextFormField(
                          controller: _phoneCreateController,
                          decoration: InputDecoration(labelText: "Phone"),
                          keyboardType: TextInputType.phone,
                          onSaved: (val) => _phone = val!,
                        )
                      ],
                    )),
                actions: [
                  TextButton(
                      onPressed: () {
                        addUser();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatList()));
                      },
                      child: Text("OK"))
                ],
              ));
      //Navigator.pop(context);
      //print("HOLLY SHIT, I'M INCREDIBLE!");
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
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      //print("OK,I'M IN");
      if (FirebaseAuth.instance.currentUser != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ChatList()));
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
          print(e.code);
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

class ChatList extends StatefulWidget {
  const ChatList({Key? key}) : super(key: key);
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final currentUser = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid);
  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context),
      child: Scaffold(
        appBar: AppBar(title: Text("CHAT"), actions: [
          IconButton(
              onPressed: () async => await signOut(),
              icon: Icon(Icons.exit_to_app)),
        ]),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                child: FutureBuilder<DocumentSnapshot>(
                  future: currentUser.get(),
                  builder:
                      (context, AsyncSnapshot<DocumentSnapshot> snapshot) =>
                          Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            child: Text(snapshot.data!.get("userName")[0]),
                          ),
                          IconButton(
                            onPressed: () => {
                              AdaptiveTheme.of(context).mode.isDark
                                  ? AdaptiveTheme.of(context).setLight()
                                  : AdaptiveTheme.of(context).setDark()
                            },
                            icon: Icon(Icons.dark_mode),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Column(
                            children: [
                              Text(snapshot.data!.get("userName")),
                              Text(snapshot.data!.get("phone")),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                title: Text(S.of(context).listTile_title),
                onTap: () {},
              ),
            ],
          ),
        ),
        body: Container(
          child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection("users").snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return Text(S.of(context).none);
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                        leading: CircleAvatar(
                          child: Text(
                              snapshot.data!.docs[index].get("userName")[0]),
                        ),
                        title: Text(snapshot.data!.docs[index].get("userName")),
                        subtitle: Text("Last Message"),
                        onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                      name: snapshot.data!.docs[index]
                                          .get("userName"),
                                      user: FirebaseAuth
                                          .instance.currentUser!.uid)),
                            ));
                  },
                );
              }),
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
    required this.date,
    Key? key,
  }) : super(key: key);
  final String text;
  final String name;
  final String date;
  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String name;
  final String user;
  ChatScreen({required this.name, required this.user, Key? key})
      : super(key: key);
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isComposing = false;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: Theme(
        data: Theme.of(context),
        child: Column(
          children: [
            Flexible(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('messages')
                    .where("receiver", isEqualTo: widget.name)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) return Text(S.of(context).none);
                  return ListView.builder(
                    reverse: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return Container(
                          key: Key(snapshot.data!.docs[index].id),
                          child: ChatMessage(
                            date: snapshot.data!.docs[index].get('dataMessage'),
                            text: snapshot.data!.docs[index].get('textMessage'),
                            name: snapshot.data!.docs[index].get("receiver"),
                          ));
                    },
                  );
                },
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
                    ? () => _handleSubmitted(
                        _textController.text, widget.name, DateTime.now())
                    : null,
              ),
            )
          ],
        ),
      ),
    );
  }

  void _handleSubmitted(String text, String name, DateTime date) {
    FirebaseFirestore.instance.collection('messages').add({
      'textMessage': text,
      'receiver': name,
      'dataMessage': date.toString(),
      'sender': widget.user
    });
    _textController.clear();
    setState(() {
      _isComposing = false;
    });

    _focusNode.requestFocus();
  }
}
