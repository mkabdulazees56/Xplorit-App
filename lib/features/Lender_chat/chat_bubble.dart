// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:xplorit/utils/constants/colors.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  final DateTime timestamp;

  ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    String formattedTime = DateFormat.Hm().format(timestamp);

    return Container(
      decoration: BoxDecoration(
        color: isCurrentUser ? TColors.chatBlue : TColors.greyLight,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
      margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: 2),
          Text(
            formattedTime,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
