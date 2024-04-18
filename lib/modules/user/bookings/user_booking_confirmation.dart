import 'package:flutter/material.dart';
import 'package:mainproject/modules/user/user_root_screen.dart';
import 'package:mainproject/utils/constants.dart';

import '../../../widgets/custom_button.dart';

class UserBookingConfirmScreen extends StatefulWidget {
  const UserBookingConfirmScreen({super.key});

  @override
  State<UserBookingConfirmScreen> createState() =>
      _UserBookingConfirmScreenState();
}

class _UserBookingConfirmScreenState extends State<UserBookingConfirmScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const sizedBox = SizedBox(
      height: 20,
    );
    return Scaffold(
      backgroundColor: KButtonColor,
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(
            Icons.check_circle,
            size: 80,
            color: Colors.white,
          ),
          sizedBox,
          const Text(
            'Your order has been received',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            'Order status',
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(
            height: 5,
          ),
          sizedBox,
          SizedBox(
            width: 200,
            child: CustomButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UserRootScreen(),
                    ),
                    (route) => false);
              },
              text: 'Home',
              color: Colors.white,
              texColor: KButtonColor,
            ),
          )
        ]),
      ),
    );
  }
}
