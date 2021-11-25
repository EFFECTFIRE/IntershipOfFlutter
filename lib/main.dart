import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'themes.dart';

void main() {
  runApp(
    FriendlyChatApp(),
  );
}

String _name = "Your name";

class FriendlyChatApp extends StatelessWidget {
  const FriendlyChatApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        home: ChatScreen(),
        theme: theme,
        darkTheme: darkTheme,
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  const ChatMessage({
    required this.text,
    required this.animationController,
    Key? key,
  }) : super(key: key);
  final String text;
  final AnimationController animationController;
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
              child: CircleAvatar(child: Text(_name[0])),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_name, style: Theme.of(context).textTheme.headline4),
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
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final List<ChatMessage> _messages = [];
  final _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isComposing = false;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).app_bar_title),
        leading: IconButton(
          icon: Icon(Icons.dark_mode),
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
                onSubmitted: _isComposing ? _handleSubmitted : null,
                decoration: InputDecoration.collapsed(
                    hintText: S.of(context).place_holder),
                focusNode: _focusNode,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: const Icon(Icons.send),
                color: Theme.of(context).primaryColor,
                onPressed: _isComposing
                    ? () => _handleSubmitted(_textController.text)
                    : null,
              ),
            )
          ],
        ),
      ),
    );
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
    var message = ChatMessage(
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
