import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mainproject/modules/user/bookings/package_booking.dart';
import 'package:mainproject/services/api_service.dart';
import 'package:mainproject/widgets/custom_button.dart';

class EventPackagesWidget extends StatelessWidget {
  EventPackagesWidget({Key? key});

  Future<List<dynamic>> _fetchEventPackages() async {
    final url = Uri.parse('${ApiService.baseUrl}/api/user/view-events');
    final response = await http.get(url);

    if (response.statusCode == 201) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data;
    } else {
      throw Exception('Failed to load event packages');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _fetchEventPackages(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: List.generate(
                snapshot.data!.length,
                (index) => GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 150,
                    height: 150,
                    margin: EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            snapshot.data![index]['image'],
                            fit: BoxFit.fill,
                            height: 120,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                snapshot.data![index]['event_type'],
                                style: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                '₹${snapshot.data![index]['price']}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: CustomButton(
                                  text: 'view more',
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              UserPackageBookingScreeen(
                                            details: snapshot.data![index],
                                          ),
                                        ));
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

class UserPackageBookingScreen {}
