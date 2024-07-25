// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xplorit/common_widgets/back_botton_widget.dart';
import 'package:xplorit/common_widgets/elevated_btn_widget.dart';
import 'package:xplorit/features/payment/add_new_card.dart';
import 'package:xplorit/utils/constants/colors.dart';
import 'package:xplorit/utils/constants/image_strings.dart';
import 'package:xplorit/utils/constants/sizes.dart';

class SelectPaymentMethod extends StatefulWidget {
  const SelectPaymentMethod({Key? key}) : super(key: key);
  @override
  State<SelectPaymentMethod> createState() => _SelectPaymentMethod();
}

class _SelectPaymentMethod extends State<SelectPaymentMethod> {
  int _type = 1;

  void _handleRadio(int? value) {
    setState(() {
      _type = value!;
    });
  }

  void initState() {
    super.initState();
  }

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
                const Center(child: Text('TOTAL')),
                Center(
                    child: Text(
                  '12,500 PKR',
                  style: Theme.of(context).textTheme.headlineLarge,
                )),
                const SizedBox(height: 50),
                Column(
                  children: [
                    PaymentMethod(TImages.visa,
                        '**** ***** **** 2334', 2, 1),
                    const SizedBox(height: 15),
                    PaymentMethod(
                        TImages.masterCard,
                        '**** ***** **** 3774',
                        .8,
                        2),
                    const SizedBox(height: 15),
                    PaymentMethod(TImages.paypal,
                        'abc@gmail.com', 2, 3),
                    const SizedBox(height: 15),
                    PaymentMethod(TImages.paystack,
                        'Pay directly to lender', 35, 4),
                  ],
                ),
                const SizedBox(height: 50),
                ElevatedBTN(titleBtn: 'Pay Now', onTapCall: () {}),
                const SizedBox(height: 20),
                SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                        onPressed: () {Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddNewCard()),
                              );}, child: Text(' + Add New Card'))),
                const SizedBox(height: 25),
              ],
            ),
          ), //main Column
        ),
      ),
    );
  }

  Container PaymentMethod(
      String imgText, String text1, double scale, int btnValue) {
    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        border: _type == btnValue
            ? Border.all(width: 1, color: TColors.primary)
            : Border.all(width: 1, color: TColors.secondary),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  imgText,
                  scale: scale,
                ),
                const SizedBox(width: 15),
                Text(
                  text1,
                  style: _type == btnValue
                      ? const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: TColors.primary)
                      : const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: TColors.darkGrey),
                ),
              ],
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
