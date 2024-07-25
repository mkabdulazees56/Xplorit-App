import 'package:flutter/material.dart';

class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({
    Key? key,
    this.btnColor,
  }) : super(key: key);

  final Color? btnColor;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Icon(
        Icons.arrow_back_ios_new,
        size: 15,
        color: btnColor ??
            Colors
                .black, // Use btnColor if provided, otherwise use default color
      ),
      label: Text(
        'Back',
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: btnColor ??
                Colors
                    .black), // Use btnColor if provided, otherwise use default color
      ),
    );
  }
}
