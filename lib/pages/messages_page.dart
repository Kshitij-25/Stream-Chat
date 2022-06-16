import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:stream_chat_app/app.dart';
import 'package:stream_chat_app/helpers.dart';
import 'package:stream_chat_app/models/models.dart';
import 'package:stream_chat_app/models/story_data.dart';
import 'package:stream_chat_app/screens/screens.dart';
import 'package:stream_chat_app/theme.dart';
import 'package:stream_chat_app/widgets/display_error_message.dart';
import 'package:stream_chat_app/widgets/widgets.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({Key? key}) : super(key: key);

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final channelListController = ChannelListController();
  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return ChannelListCore(
      channelListController: channelListController,
      filter: Filter.and(
        [
          Filter.equal('type', 'messaging'),
          Filter.in_(
            'members',
            [StreamChatCore.of(context).currentUser!.id],
          ),
        ],
      ),
      emptyBuilder: (context) => const Center(
        child: Text(
          'So empty.\nGo and message someone',
          textAlign: TextAlign.center,
        ),
      ),
      errorBuilder: (context, error) => DisplayErrorMessage(
        error: error,
      ),
      loadingBuilder: (context) => const Center(
        child: SizedBox(
          width: 100,
          height: 100,
          child: CircularProgressIndicator(),
        ),
      ),
      listBuilder: (context, channels) {
        return CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
              child: _Stories(),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return _MessageTitle(
                    channel: channels[index],
                  );
                },
                childCount: channels.length,
              ),
            )
          ],
        );
      },
    );
  }
}

class _MessageTitle extends StatelessWidget {
  const _MessageTitle({
    Key? key,
    required this.channel,
  }) : super(key: key);

  final Channel channel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          ChatScreen.routeWithChannel(channel),
        );
      },
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Avatar.medium(
              url: Helpers.getChannelImage(channel, context.currentUser!),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    Helpers.getChannelName(channel, context.currentUser!),
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      letterSpacing: 0.2,
                      wordSpacing: 1.5,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.5,
                  child: _buildLastMessage(),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(
                  height: 4,
                ),
                _buildLastMessageAt(),
                const SizedBox(
                  height: 8,
                ),
                Center(
                  child: UnreadIndicator(channel: channel),
                )
                // Container(
                //   width: 18,
                //   height: 18,
                //   decoration: const BoxDecoration(
                //       color: AppColors.secondary, shape: BoxShape.circle),
                //   child: const Center(
                //     child: Text(
                //       '1',
                //       style: TextStyle(
                //         fontSize: 10,
                //         color: AppColors.textLight,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLastMessage() {
    return BetterStreamBuilder<int>(
      stream: channel.state!.unreadCountStream,
      initialData: channel.state?.unreadCount ?? 0,
      builder: (context, count) {
        return BetterStreamBuilder<Message>(
          stream: channel.state!.lastMessageStream,
          initialData: channel.state!.lastMessage,
          builder: (context, lastMessage) {
            return Text(
              lastMessage.text ?? '',
              overflow: TextOverflow.ellipsis,
              style: (count > 0)
                  ? const TextStyle(
                      fontSize: 12,
                      color: AppColors.secondary,
                    )
                  : const TextStyle(
                      fontSize: 12,
                      color: AppColors.textFaded,
                    ),
            );
          },
        );
      },
    );
  }

  Widget _buildLastMessageAt() {
    return BetterStreamBuilder<DateTime>(
      stream: channel.lastMessageAtStream,
      initialData: channel.lastMessageAt,
      builder: (context, data) {
        final lastMessageAt = data.toLocal();
        String stringDate;
        final now = DateTime.now();

        final startOfDay = DateTime(now.year, now.month, now.day);

        if (lastMessageAt.millisecondsSinceEpoch >=
            startOfDay.microsecondsSinceEpoch) {
          stringDate = Jiffy(lastMessageAt.toLocal()).jm;
        } else if (lastMessageAt.millisecondsSinceEpoch >=
            startOfDay
                .subtract(const Duration(days: 1))
                .millisecondsSinceEpoch) {
          stringDate = 'Yesterday';
        } else if (startOfDay.difference(lastMessageAt).inDays < 7) {
          stringDate = Jiffy(lastMessageAt.toLocal()).EEEE;
        } else {
          stringDate = Jiffy(lastMessageAt.toLocal()).yMd;
        }
        return Text(
          stringDate,
          style: const TextStyle(
            fontSize: 11,
            letterSpacing: -0.2,
            fontWeight: FontWeight.w600,
            color: AppColors.textFaded,
          ),
        );
      },
    );
  }
}

class _Stories extends StatelessWidget {
  const _Stories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.transparent,
      child: SizedBox(
        height: 134,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 16, top: 8, bottom: 16),
              child: Text(
                'Stories',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                  color: AppColors.textFaded,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  final faker = Faker();
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 60,
                      child: _StoryCard(
                        storyData: StoryData(
                          name: faker.person.firstName(),
                          url: Helpers.randomPictureUrl(),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StoryCard extends StatelessWidget {
  const _StoryCard({Key? key, required this.storyData}) : super(key: key);

  final StoryData storyData;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Avatar.medium(url: storyData.url),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Text(
            storyData.name,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              letterSpacing: 0.3,
              fontWeight: FontWeight.bold,
            ),
          ),
        ))
      ],
    );
  }
}
