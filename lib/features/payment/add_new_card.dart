// ignore: file_names
// ignore_for_file: prefer_const_constructors, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:xplorit/common_widgets/back_botton_widget.dart';
import 'package:xplorit/common_widgets/elevated_btn_widget.dart';
import 'package:xplorit/features/payment/select_payment_method.dart';
import 'package:xplorit/utils/constants/colors.dart';
import 'package:xplorit/utils/constants/image_strings.dart';
import 'package:xplorit/utils/constants/sizes.dart';

class AddNewCard extends StatefulWidget {
  const AddNewCard({Key? key}) : super(key: key);
  @override
  State<AddNewCard> createState() => _AddNewCard();
}

class _AddNewCard extends State<AddNewCard> {
  int _type = 1;
  TextEditingController _cardHolder = TextEditingController();
  TextEditingController _cardNumber = TextEditingController();
  TextEditingController _cardExpiry = TextEditingController();
  TextEditingController _cardCVV = TextEditingController();

  void _handleRadio(int? value) {
    setState(() {
      _type = value!;
    });
  }

  void initState() {
    super.initState();
  }

  List<Map> lists = [
    {"name": "Accept the Term and Conditions", "isChecked": false},
    {"name": "Use as default payment method", "isChecked": false},
  ];
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BackButtonWidget(),
                const SizedBox(height: 10),
                Text(
                  'Payment',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 25),
                Text('Select card'),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: PaymentMethod(TImages.visa, 3, 1),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: PaymentMethod(TImages.masterCard, 1, 2),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: PaymentMethod(TImages.paypal, 3, 3),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                TextFields('Card Holder', 'Your Name', _cardHolder),
                const SizedBox(height: 15),
                Text('Card Number'),
                const SizedBox(height: 5),
                Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: TColors.lightGrey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _cardNumber,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.credit_card, color: TColors.darkGrey),
                      hintText: 'XXXX XXXX XXXX XXXX',
                            ),
                  ),
                ),
                const SizedBox(height: 15),

                Row(
                  children: [
                    Expanded(
                      child: TextFields('Valid until', 'MM/YYYY', _cardExpiry),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: TextFields('CVV Code', 'Enter CVV Code', _cardCVV),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Column(
                  children: lists.map((favourite) {
                    return CheckboxListTile(
                      title: Text(
                        favourite['name'],
                        style:Theme.of(context).textTheme.headlineSmall,
                      ),
                      value: favourite['isChecked'],
                      onChanged: (val) {
                        setState(() {
                          favourite['isChecked'] = val;
                        });
                      },
                      activeColor: TColors.primary,
                      controlAffinity: ListTileControlAffinity.leading,
                    );
                  }).toList(),
                ),

                //Button
                const SizedBox(height: 35),
                ElevatedBTN(titleBtn: 'Add Card', onTapCall: () {Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SelectPaymentMethod()),
                              );}),
                const SizedBox(height: 25),
              ],
            ),
          ), //main Column
        ),
      ),
    );
  }

  Container PaymentMethod(String imgText, double scale, int btnValue) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: TColors.blueLight,
        border: _type == btnValue
            ? Border.all(width: 1, color: TColors.primary)
            : Border.all(width: 1, color: TColors.darkGrey),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all( 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              imgText,
              scale: scale,
            ),
            Radio(
              value: btnValue,
              groupValue: _type,
              onChanged: _handleRadio,
              fillColor: MaterialStateColor.resolveWith(
                (Set<MaterialState> states) {
                  return _type == btnValue ? TColors.primary : TColors.darkGrey;
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

Column TextFields(
    String labelText, String hintText, TextEditingController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(labelText),
      const SizedBox(height: 5),
      Container(
        height: 50,
        decoration: BoxDecoration(
          color: TColors.lightGrey,
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
          ),
        ),
      ),
    ],
  );
}
