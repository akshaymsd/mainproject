import 'package:flutter/material.dart';
import 'package:mainproject/modules/user/payment_screen.dart';
import 'package:mainproject/modules/user/user_add_address_screen.dart';
import 'package:mainproject/services/api_service.dart';
import 'package:mainproject/utils/constants.dart';
import 'package:mainproject/widgets/custom_button.dart';

class CheckOut extends StatefulWidget {
  const CheckOut({super.key, required this.total});

  final String total;

  @override
  State<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  Map<String, dynamic>? address;
  bool isPaid = false;

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: KButtonColor,
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text('CheckOut',
            style: TextStyle(color: Colors.white, fontFamily: 'Ubuntu-Bold')),
      ),
      body: Container(
        child: Column(children: [
          Expanded(
              child: ListView(children: [
            Container(
              margin:
                  const EdgeInsets.only(top: 50, bottom: 4, left: 4, right: 4),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              child: Card(
                elevation: 0,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4))),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                      border: Border.all(color: Colors.grey.shade200)),
                  padding: const EdgeInsets.only(left: 12, top: 8, right: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),

                      if (address != null) Text('Address'),
                      if (address != null)
                        Text(
                            '${address!['address']},${address!['pincode']},${address!['state']}'),
                      if (address == null)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Address:',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey.shade800),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            CustomButton(
                              text: 'Add',
                              onPressed: () async {
                                address = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const UserAddAddressScreen(),
                                    ));
                                print(address);
                                if (address != null) {
                                  setState(() {});
                                }
                              },
                            )
                          ],
                        ),

                      isPaid
                          ? Text('payment  :   complete')
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Payement',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade800),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                CustomButton(
                                  text: 'select',
                                  onPressed: () async {
                                    isPaid = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const PaymentScreen(),
                                        ));

                                    if (isPaid) {
                                      setState(() {});
                                    }
                                  },
                                )
                              ],
                            ),

                      const SizedBox(
                        height: 15,
                      ),

                      // standard Delivery

                      Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(4)),
                            border: Border.all(
                                color: Colors.tealAccent.withOpacity(0.4),
                                width: 1),
                            color: Colors.tealAccent.withOpacity(0.2)),
                        margin: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Radio(
                              value: 1,
                              groupValue: 1,
                              onChanged: (isChecked) {},
                              activeColor: Colors.tealAccent.shade400,
                            ),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Standard Delivery",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // price section

                      Container(
                        margin: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                        child: Card(
                          elevation: 0,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4))),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(4)),
                                border:
                                    Border.all(color: Colors.grey.shade200)),
                            padding: const EdgeInsets.only(
                                left: 12, top: 8, right: 12, bottom: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const SizedBox(
                                  height: 4,
                                ),
                                const Text(
                                  "PRICE DETAILS",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 0.5,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 3),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "Total MRP",
                                        style: TextStyle(
                                            color: Colors.grey.shade700,
                                            fontSize: 12),
                                      ),
                                      Text(
                                        widget.total,
                                        style: TextStyle(
                                            color: Colors.grey.shade700,
                                            fontSize: 12),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 3),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "Bag discount",
                                        style: TextStyle(
                                            color: Colors.grey.shade700,
                                            fontSize: 12),
                                      ),
                                      Text(
                                        '0',
                                        style: TextStyle(
                                            color: Colors.teal.shade300,
                                            fontSize: 12),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 3),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "Tax",
                                        style: TextStyle(
                                            color: Colors.grey.shade700,
                                            fontSize: 12),
                                      ),
                                      Text(
                                        '0',
                                        style: TextStyle(
                                            color: Colors.grey.shade700,
                                            fontSize: 12),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 3),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "Order Total",
                                        style: TextStyle(
                                            color: Colors.grey.shade700,
                                            fontSize: 12),
                                      ),
                                      Text(
                                        widget.total,
                                        style: TextStyle(
                                            color: Colors.grey.shade700,
                                            fontSize: 12),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 3),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "Delievery Charges",
                                        style: TextStyle(
                                            color: Colors.grey.shade700,
                                            fontSize: 12),
                                      ),
                                      Text(
                                        'FREE',
                                        style: TextStyle(
                                            color: Colors.teal.shade700,
                                            fontSize: 12),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 0.5,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Total",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 12),
                                    ),
                                    Text(
                                      widget.total,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 12),
                                    )
                                  ],
                                ),

                                const SizedBox(
                                  height: 120,
                                ),

                                //button

                                Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 12),
                                    child: loading
                                        ? Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.teal,
                                            ),
                                          )
                                        : CustomButton(
                                            text: 'Place Order',
                                            onPressed: () async {
                                              setState(() {
                                                loading = true;
                                              });

                                              await ApiService()
                                                  .placeOrder(context);

                                              setState(() {
                                                loading = false;
                                              });
                                            },
                                          ))
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ]))
        ]),
      ),
    );
  }
}
