import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:xplorit/common_widgets/elevated_btn_widget.dart';
import 'package:xplorit/common_widgets/icon_text_widget.dart';
import 'package:xplorit/utils/constants/colors.dart';
import 'package:xplorit/utils/constants/image_strings.dart';

class LendOrdersCancelledCardWidget extends StatefulWidget {
  final String renderImg;
  final String renterName;
  final String vehicleImg;
  final String vehicleName;
  final String ratingText;
  final Timestamp startDate;
  final Timestamp endDate;
  final String statusText;
  final Color statusFgColor;
  final Color statusBgColor;
  final VoidCallback trackVehicleTapCall;

  const LendOrdersCancelledCardWidget({
    Key? key,
    required this.renderImg,
    required this.renterName,
    required this.vehicleImg,
    required this.vehicleName,
    required this.ratingText,
    required this.startDate,
    required this.endDate,
    required this.statusText,
    required this.statusFgColor,
    required this.statusBgColor,
    required this.trackVehicleTapCall,
  }) : super(key: key);

  @override
  State<LendOrdersCancelledCardWidget> createState() =>
      _LendOrdersCancelledCardWidgetState();
}

class _LendOrdersCancelledCardWidgetState
    extends State<LendOrdersCancelledCardWidget> {
  String endDate = '';
  String startDate = '';
  String dateOnPerDay = '';

  @override
  void initState() {
    super.initState();
    dateOnPerDay = startDate;
    startDate = widget.startDate.toDate().toString().split(' ')[0];
    endDate = widget.endDate.toDate().toString().split(' ')[0];

    if (startDate == endDate) {
      startDate =
          '${widget.startDate.toDate().hour.toString().padLeft(2, '0')}:${widget.startDate.toDate().minute.toString().padLeft(2, '0')}';
      endDate =
          '${widget.endDate.toDate().hour.toString().padLeft(2, '0')}:${widget.endDate.toDate().minute.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: TColors.secondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: widget.renderImg.startsWith('http')
                          ? Image.network(
                              widget.renderImg,
                              fit: BoxFit.cover,
                              width: 70,
                              height: 70,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Icon(
                                    Icons.person,
                                    color: TColors.secondary,
                                    size: 60,
                                  ),
                                );
                              },
                            )
                          : Image.asset(
                              widget.renderImg,
                              fit: BoxFit.cover,
                              width: 70,
                              height: 70,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Icon(
                                    Icons.person,
                                    color: TColors.secondary,
                                    size: 60,
                                  ),
                                );
                              },
                            ),
                      // Image.asset(renderImg, scale: renderImgScale).image,
                    ),
                    const SizedBox(width: 5),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Requested By',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Text(
                          widget.renterName,
                          style: Theme.of(context).textTheme.headlineMedium,
                        )
                      ],
                    )
                  ],
                ),
                Container(
                  width: 100,
                  height: 40,
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: widget.statusBgColor,
                  ),
                  child: Center(
                    child: Text(
                      widget.statusText,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.apply(color: widget.statusFgColor),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.vehicleName,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 5),
                    IconTextWidget(
                      icon: Icons.star,
                      txt: widget.ratingText,
                      colorIcon: Colors.yellow,
                    ),
                  ],
                ),
                SizedBox(
                  height: 100,
                  width: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: widget.vehicleImg.startsWith('http')
                        ? Image.network(
                            widget.vehicleImg,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Image.asset(
                                  TImages.car,
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          )
                        : Image.asset(
                            widget.vehicleImg,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Image.asset(
                                  TImages.car,
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today),
                    Text(
                      startDate,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(dateOnPerDay != '' ? Icons.calendar_today : null),
                    Text(
                      dateOnPerDay,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.calendar_today),
                    Text(
                      endDate,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedBTN(
                    titleBtn: 'Remove',
                    onTapCall: widget.trackVehicleTapCall,
                    btnColor: TColors.grey,
                    textColor: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';

// import 'package:xplorit/common_widgets/icon_text_widget.dart';
// import 'package:xplorit/utils/constants/colors.dart';

// class LendOrdersCancelledCardWidget extends StatelessWidget {
//   final String renderImg;
//   final double renderImgScale;
//   final String renterName;
//   final String vehicleImg;
//   final String vehicleName;
//   final String ratingText;
//   final String idText;
//   final double imgScale;
//   final String startDate;
  
//   final String statusText;
//   final Color statusFgColor;
//   final Color statusBgColor;
 

//   const LendOrdersCancelledCardWidget({
//     Key? key,
//     required this.renderImg,
//     required this.renderImgScale,
//     required this.renterName,
//     required this.vehicleImg,
//     required this.vehicleName,
//     required this.ratingText,
//     required this.idText,
//     required this.imgScale,
//     required this.startDate,

//     required this.statusText,
//     required this.statusFgColor,
//     required this.statusBgColor,
   
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: TColors.secondary,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(10),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     CircleAvatar(
//                       radius: 25,
//                       backgroundImage:
//                           Image.asset(renderImg, scale: renderImgScale).image,
//                     ),
//                     const SizedBox(width: 5),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           renterName,
//                           style: Theme.of(context).textTheme.headlineMedium,
//                         )
//                       ],
//                     )
//                   ],
//                 ),
//                 Container(
//                   width: 100,
//                   height: 40,
//                   padding: EdgeInsets.all(2),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(20),
//                     color: statusBgColor,
//                   ),
//                   child: Center(
//                     child: Text(
//                       statusText,
//                       style: Theme.of(context)
//                           .textTheme
//                           .headlineSmall
//                           ?.apply(color: statusFgColor),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       vehicleName,
//                       style: Theme.of(context).textTheme.bodyLarge,
//                     ),
//                     const SizedBox(height: 5),
//                     IconTextWidget(
//                       icon: Icons.star,
//                       txt: ratingText,
//                       colorIcon: Colors.yellow,
//                     ),
//                     IconTextWidget(icon: Icons.numbers, txt: idText),
//                   ],
//                 ),
//                 Image.asset(
//                   vehicleImg,
//                   scale: imgScale,
//                 )
//               ],
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     const Icon(Icons.calendar_today),
//                     Text(
//                       startDate,
//                       style: Theme.of(context).textTheme.titleMedium,
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
