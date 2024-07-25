// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:xplorit/utils/constants/colors.dart';

class RenterUserTile extends StatelessWidget {
  final String name;
  final String message;
  final Timestamp timestamp;
  final String image;
  final void Function()? onTap;

  // const RenterUserTile({super.key});

  RenterUserTile({
    super.key,
    required this.name,
    required this.message,
    required this.timestamp,
    required this.onTap,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: image.startsWith('http')
                  ? Image.network(
                      image,
                      fit: BoxFit.cover,
                      width: 70,
                      height: 80,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(
                            Icons.person,
                            color: TColors.secondary,
                            size: 60,
                          ),
                        );
                      },
                    )
                  : Image.asset(
                      image,
                      fit: BoxFit.cover,
                      width: 70,
                      height: 80,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(
                            Icons.person,
                            color: TColors.secondary,
                            size: 60,
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(
              width: 10.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  message,
                  style: TextStyle(
                      color: Colors.black45,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  timestamp.toDate().toString(),
                  style: TextStyle(
                      color: Colors.black45,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
