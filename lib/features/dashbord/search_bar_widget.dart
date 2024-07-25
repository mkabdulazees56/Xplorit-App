// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xplorit/features/dashbord/vehicle_filter.dart';
import 'package:xplorit/features/product/product_list.dart';
import 'package:xplorit/utils/constants/colors.dart';
import 'package:xplorit/utils/constants/sizes.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({
    required this.title,
    required this.hintText,
    super.key,
  });

  final String title, hintText;

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: TColors.secondary,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                      border: Border(
                        right: BorderSide(
                          color: TColors
                              .primary, // Change this to the desired border color
                          width: 0.5, // Change this to the desired border width
                        ),
                      ),
                    ),
                    child: TextField(
                      controller: searchController,
                      onChanged: (value) {
                        setState(() {
                          searchController.text = value;
                        });
                        print('Search result: ${searchController.text}');
                      },
                      decoration: InputDecoration(
                        fillColor: TColors.secondary,
                        hintText: widget.hintText,
                        enabledBorder: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                      ),
                      textAlignVertical: TextAlignVertical.center,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: TColors.secondary,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    border: Border(
                      left: BorderSide(
                        color: TColors
                            .primary, // Change this to the desired border color
                        width: 0.5, // Change this to the desired border width
                      ),
                    ),
                  ),
                  child: IconButton(
                    onPressed: () {
                      // setState(() {
                      Get.to(() => ProductListing(
                            model: searchController.text,
                          ));
                      // });
                    },
                    icon: Icon(Icons.search),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: TColors.secondary, // Set blue background color
                    borderRadius: BorderRadius.circular(
                        TSizes.borderRadiusLg), // Set border radius to 12
                  ),
                  child: IconButton(
                    onPressed: () {
                      Get.to(VehicleFilter());
                    },
                    icon: const Icon(Icons.tune),
                    iconSize: 25,
                    color: Colors.black, // Set icon color to white
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
