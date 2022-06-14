import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_app/pages/calls_page.dart';
import 'package:stream_chat_app/pages/contacts_page.dart';
import 'package:stream_chat_app/pages/messages_page.dart';
import 'package:stream_chat_app/pages/notification_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  final pages = const [
    MessagesPage(),
    NotificationPage(),
    CallsPage(),
    ContactsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stream Chat'),
      ),
      body: pages[0],
      bottomNavigationBar: _BottomNavigationBar(
        onItemSelected: (index) {},
      ),
    );
  }
}

class _BottomNavigationBar extends StatelessWidget {
  const _BottomNavigationBar({Key? key, required this.onItemSelected})
      : super(key: key);

  final ValueChanged<int> onItemSelected;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavigationBarItem(
            label: 'Messages',
            index: 0,
            icon: CupertinoIcons.bubble_left_bubble_right_fill,
            onTap: onItemSelected,
          ),
          _NavigationBarItem(
            label: 'Notifications',
            index: 1,
            icon: CupertinoIcons.bell_solid,
            onTap: onItemSelected,
          ),
          _NavigationBarItem(
            label: 'Calls',
            index: 2,
            icon: CupertinoIcons.phone_fill,
            onTap: onItemSelected,
          ),
          _NavigationBarItem(
            label: 'Contacts',
            index: 3,
            icon: CupertinoIcons.person_2_fill,
            onTap: onItemSelected,
          ),
        ],
      ),
    );
  }
}

class _NavigationBarItem extends StatelessWidget {
  const _NavigationBarItem({
    Key? key,
    required this.label,
    required this.icon,
    required this.index,
    required this.onTap,
  }) : super(key: key);

  final int index;
  final String label;
  final IconData icon;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap(index);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 20,
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }
}
