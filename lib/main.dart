import 'package:flutter/material.dart';
import 'package:stream_chat_app/app.dart';
import 'package:stream_chat_app/screens/home_screen.dart';
import 'package:stream_chat_app/screens/select_user_screen.dart';
import 'package:stream_chat_app/theme.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

void main() {
  final client = StreamChatClient(streamKey);
  runApp(MyApp(
    client: client,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.client}) : super(key: key);

  final StreamChatClient client;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return StreamChatCore(
          client: client,
          // ignore: deprecated_member_use
          child: ChannelsBloc(child: child!),
        );
      },
      home: const SelectUserScreen(),
    );
  }
}
