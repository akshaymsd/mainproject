import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:mainproject/Db/db_service.dart';
import 'package:mainproject/modules/user/bookings/user_booking_confirmation.dart';
import 'package:mainproject/services/api_service.dart';
import 'package:mainproject/widgets/custom_button.dart';
import 'package:mainproject/widgets/custom_text_field.dart';

class UserPackageBookingScreeen extends StatefulWidget {
  const UserPackageBookingScreeen({super.key, required this.details});

  final Map<String, dynamic> details;

  @override
  State<UserPackageBookingScreeen> createState() =>
      _UserPackageBookingScreeenState();
}

class _UserPackageBookingScreeenState extends State<UserPackageBookingScreeen> {
  DateTime? newDateTime;

  bool loading = false;

  final locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print(widget.details);
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text('Book your package'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image(
                    image: NetworkImage(widget.details['image']),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                newDateTime != null
                    ? Text(
                        '${newDateTime!.day.toString()}/${newDateTime!.month.toString()}/${newDateTime!.year.toString()}')
                    : const Text('Select date'),
                CustomButton(
                  text: newDateTime != null ? 'change' : 'select',
                  onPressed: () async {
                    newDateTime = await showRoundedDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(DateTime.now().year - 1),
                      lastDate: DateTime(DateTime.now().year + 1),
                      borderRadius: 16,
                    );
                    if (newDateTime != null) {
                      setState(() {});
                    }
                  },
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              flex: 2,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListView(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            'Loaction',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        CustomTextField(
                          hintText: 'Enter Location',
                          controller: locationController,
                          borderColor: Colors.grey,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        const Text(
                          'Description',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          widget.details['description'],
                          maxLines: 8,
                          style: TextStyle(color: Colors.grey.shade400),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          'Type',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          widget.details['event_type'],
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 16,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            const Text(
                              'Price',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '₹${widget.details['price']}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: CustomButton(
                      text: 'Book',
                      onPressed: () async {
                        try {
                          setState(() {
                            loading = true;
                          });

                          if (locationController.text.isNotEmpty &&
                              newDateTime != null) {
                            await ApiService().bookEvent(
                                context,
                                DbService.getLoginId(),
                                widget.details['_id'],
                                '${newDateTime!.day}-${newDateTime!.month}-${newDateTime!.year}',
                                locationController.text);

                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      UserBookingConfirmScreen(),
                                ));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Date and location Required')),
                            );
                          }

                          setState(() {
                            loading = false;
                          });
                        } catch (e) {}
                      },
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
