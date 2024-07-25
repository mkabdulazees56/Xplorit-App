import 'package:flutter/material.dart';

class LenderReviewItem extends StatefulWidget {
  final String name;
  final String review;
  final String date;
  final double rating;
  final String avatar;

  const LenderReviewItem({
    Key? key,
    required this.name,
    required this.review,
    required this.date,
    required this.rating,
    required this.avatar,
  }) : super(key: key);

  @override
  _LenderReviewItemState createState() => _LenderReviewItemState();
}

class _LenderReviewItemState extends State<LenderReviewItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(widget.avatar),
              ),
              SizedBox(width: 8.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.name,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(widget.date),
                ],
              ),
              Spacer(),
              StarDisplay(value: widget.rating),
            ],
          ),
          SizedBox(height: 8.0),
          Text(widget.review, style: Theme.of(context).textTheme.titleMedium),
          Divider(thickness: 1.0),
        ],
      ),
    );
  }
}

class StarDisplay extends StatelessWidget {
  final double value;

  const StarDisplay({Key? key, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < value ? Icons.star : Icons.star_border,
          color: Colors.amber,
        );
      }),
    );
  }
}
