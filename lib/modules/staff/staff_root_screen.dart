import 'package:action_slider/action_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mainproject/Db/db_service.dart';
import 'package:mainproject/modules/auth/login_screen.dart';
import 'package:mainproject/modules/staff/booking_list_screen.dart';
import 'package:mainproject/modules/staff/staff_add_event_screen.dart';
import 'package:mainproject/modules/staff/staff_add_product_screen.dart';
import 'package:mainproject/modules/staff/staff_eventList_screen.dart';
import 'package:mainproject/modules/staff/staff_product_list.dart';
import 'package:mainproject/services/api_service.dart';
import 'package:mainproject/utils/constants.dart';

class StaffRootScreen extends StatefulWidget {
  const StaffRootScreen({super.key});

  @override
  State<StaffRootScreen> createState() => _StaffRootScreenState();
}

class _StaffRootScreenState extends State<StaffRootScreen> {
  bool isAttend = false;

  bool loading = false;

  void getProfile() async {
    try {
      setState(() {
        loading = false;
      });

      List data = await ApiService().getStaffProfile(DbService.getLoginId()!);

      var today =
          "${DateTime.now().day}/0${DateTime.now().month}/${DateTime.now().year}";

      data[0]['attendance'].forEach((e) {
        isAttend = e['date'] == today;
      });

      setState(() {
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    getProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: KButtonColor,
        title: const Text(
          'Home',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: GridView(
                // Set the number of items in the grid
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of columns
                  crossAxisSpacing: 20.0, // Spacing between columns
                  mainAxisSpacing: 20.0, // Spacing between rows
                ),
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const StaffAddProductScreen(),
                          ));

                      // Add your navigation logic here
                    },
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15)),
                      child: GridTile(
                        footer: Container(
                          color: KButtonColor,
                          padding: const EdgeInsets.all(12),
                          child: const Text(
                            'Add product', // Name of the item
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        child: Image.asset(
                          'assets/images/addproduct.png', // URL of the image
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const StaffAddEventScreen(),
                          ));
                    },
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15)),
                      child: GridTile(
                        footer: Container(
                          color: KButtonColor,
                          padding: const EdgeInsets.all(12),
                          child: const Text(
                            'Add Event', // Name of the item
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        child: Image.asset(
                          'assets/images/event.jpeg', // URL of the image
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StaffProductList(),
                          ));
                    },
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15)),
                      child: GridTile(
                        footer: Container(
                          color: KButtonColor,
                          padding: const EdgeInsets.all(12),
                          child: const Text(
                            'View product', // Name of the item
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        child: Image.asset(
                          'assets/images/viewbooking.jpeg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Add your navigation logic here
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StaffEventList(),
                          ));
                    },
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15)),
                      child: GridTile(
                        footer: Container(
                          color: KButtonColor,
                          padding: const EdgeInsets.all(12),
                          child: const Text(
                            'View events', // Name of the item
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        child: Image.asset(
                          'assets/images/viewevent.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                          (route) => false);
                    },
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15)),
                      child: GridTile(
                        footer: Container(
                          color: KButtonColor,
                          padding: const EdgeInsets.all(12),
                          child: const Text(
                            'Logout', // Name of the item
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        child: Container(
                            color: Colors.white,
                            child: const Icon(
                              Icons.logout,
                              color: Colors.red,
                              size: 50,
                            )),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const StaffBookingListScreen(),
                          ));
                    },
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15)),
                      child: GridTile(
                        footer: Container(
                          color: KButtonColor,
                          padding: const EdgeInsets.all(12),
                          child: const Text(
                            'View bookings', // Name of the item
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        child: Image.asset(
                          'assets/images/view.jpeg', // URL of the image
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            isAttend
                ? const SizedBox()
                : ActionSlider.standard(
                    backgroundColor: KButtonColor,
                    toggleColor: Colors.white,
                    backgroundBorderRadius: BorderRadius.circular(0.0),
                    rolling: true,
                    action: (controller) async {
                      controller.loading();
                      String url =
                          '${ApiService.baseUrl}/api/staff/attendance/${DbService.getLoginId()}';

                      // Define the request body parameter
                      var body = {
                        'isPresent': 'true',
                      };

                      // Make the PUT request
                      var response = await http.put(Uri.parse(url), body: body);

                      // Check if the request was successful
                      if (response.statusCode == 200) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Attendance recorded successfully'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                          controller.success();
                        }
                      } else {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Failed to record attendance'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      }
                    },
                    child: const Text(
                      'Slide to add attendance',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
