import 'package:flutter/material.dart';
import 'package:stream_chat_app/app.dart';
import 'package:stream_chat_app/screens/chat_screen.dart';
import 'package:stream_chat_app/widgets/display_error_message.dart';
import 'package:stream_chat_app/widgets/widgets.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return UserListCore(
      filter: Filter.notEqual('id', context.currentUser!.id),
      errorBuilder: (context, error) => DisplayErrorMessage(
        error: error,
      ),
      emptyBuilder: (context) => const Center(
        child: Text('There are no users'),
      ),
      loadingBuilder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
      listBuilder: (context, items) {
        return Scrollbar(
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: ((context, index) {
              return items[index].when(
                headerItem: (_) => const SizedBox.shrink(),
                userItem: (user) => _ContactTile(user: user),
              );
            }),
          ),
        );
      },
    );
  }
}

class _ContactTile extends StatelessWidget {
  const _ContactTile({Key? key, required this.user}) : super(key: key);

  final User user;

  Future<void> createChannel(BuildContext context) async {
    final core = StreamChatCore.of(context);
    final channel = core.client.channel(
      'messaging',
      extraData: {
        'members': [
          core.currentUser!.id,
          user.id,
        ],
      },
    );
    await channel.watch();
    // Navigator.of(context).push(
    //   ChatScreen.routeWithChannel(channel),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        createChannel(context);
      },
      child: ListTile(
        leading: Avatar.small(
          url: user.image,
        ),
        title: Text(user.name),
      ),
    );
  }
}
