import 'package:flutter/material.dart';
import 'package:xplorit/utils/constants/sizes.dart';

class SelectionMode extends StatelessWidget {
  const SelectionMode({
    required this.title,
    required this.txt1,
    required this.txt2,
    required this.bgcolor,
    required this.iconImg,
    required this.onTapCall,
    super.key, 
  });

  final String title,txt1,txt2;
  final Color bgcolor;
  final String iconImg;
  final VoidCallback onTapCall;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTapCall,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgcolor,
        padding: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(TSizes.borderRadiusLg),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Rent Category Icon and Title
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              Image(image: AssetImage(iconImg)),
            ],
          ),
          // Description for Rent Category
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(
                txt1,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: TSizes.defaultSpace),
              Text(
                txt2,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
