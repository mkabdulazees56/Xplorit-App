import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:xplorit/utils/constants/colors.dart';

class TimeWidget extends StatelessWidget {
  const TimeWidget({
    Key? key,
    required this.timeText,
    required this.timeFunc,
    required this.iconClock,
  }) : super(key: key);

  final String timeText;
  final TimeOfDay? timeFunc;
  final IconData iconClock;

  @override
  Widget build(BuildContext context) {
    final formattedTime = timeFunc != null
        ? DateFormat.Hm()
            .format(DateTime(0, 0, 0, timeFunc!.hour, timeFunc!.minute))
        : 'Select Time';

    return Row(
      children: [
        Container(
          height: 80,
          width: 50,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
            color: TColors.primary,
          ),
          child: Icon(
            iconClock,
            color: TColors.white,
          ),
        ),
        Container(
          width: 125,
          height: 80,
          decoration: const BoxDecoration(
            color: TColors.blueLight,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                timeText,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.apply(color: TColors.black),
              ),
              Text(formattedTime),
            ],
          ),
        ),
      ],
    );
  }
}
