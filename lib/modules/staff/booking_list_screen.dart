import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mainproject/Db/db_service.dart';
import 'package:mainproject/modules/staff/bookings_details.dart';
import 'package:mainproject/services/api_service.dart';
import 'package:mainproject/widgets/custom_button.dart';

class StaffBookingListScreen extends StatefulWidget {
  const StaffBookingListScreen({Key? key}) : super(key: key);

  @override
  State<StaffBookingListScreen> createState() => _StaffBookingListScreenState();
}

class _StaffBookingListScreenState extends State<StaffBookingListScreen> {
  late Future<List<dynamic>> _futurePendingFeedback;
  late Future<List<dynamic>> _futureAcceptedFeedback;

  @override
  void initState() {
    super.initState();
    _futurePendingFeedback = _fetchFeedback('pending');
    _futureAcceptedFeedback = _fetchFeedback('confirmed');
  }

  Future<List<dynamic>> _fetchFeedback(String status) async {
    final loginId = DbService.getLoginId();

    print(loginId);

    final url = Uri.parse('${ApiService.baseUrl}/api/staff/view-bookings');
    final response = await http.get(url);

    print(response.body);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];

      var filterdList =
          data.where((element) => element['status'] == status).toList();

      return filterdList;
    } else {
      throw Exception('Failed to load feedback');
    }
  }

  Future<void> _updateBookingStatus(String id, String bookedDate) async {
    final url = Uri.parse(
        '${ApiService.baseUrl}/api/staff/update-booking-stat/${id}/$bookedDate');
    final response = await http.put(url);

    print(response.body);

    if (response.statusCode == 200) {
      // Successfully updated booking status
      print('Booking status updated');
    } else {
      throw Exception('Failed to update booking status');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('Bookings'),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Pending'),
              Tab(text: 'Accepted'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildTabView(_futurePendingFeedback),
            _buildTabView(_futureAcceptedFeedback),
          ],
        ),
      ),
    );
  }

  Widget _buildTabView(Future<List<dynamic>> futureFeedback) {
    return FutureBuilder<List<dynamic>>(
      future: futureFeedback,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final feedbackList = snapshot.data;
          if (feedbackList == null || feedbackList.isEmpty) {
            return const Center(
              child: Text('No bookings'),
            );
          } else {
            return ListView.builder(
              itemCount: feedbackList.length,
              itemBuilder: (context, index) {
                final feedback = feedbackList[index];
                return Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      color: Colors.grey.shade300,
                    ),
                  ),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StaffBookingsDetails(
                            details: feedback,
                          ),
                        ),
                      );
                    },
                    leading: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.network(feedback['events_data']['image']),
                    ),
                    title: Text(
                      feedback['events_data']['event_type'],
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(feedback['date']),
                    trailing: feedback['status'] == 'confirmed'
                        ? null
                        : CustomButton(
                            text: 'Accept',
                            onPressed: () async {
                              print(feedback);
                              print(feedback['date']);
                              await _updateBookingStatus(
                                  feedback['login_id'], feedback['date']);
                              setState(() {});
                            },
                          ),
                  ),
                );
              },
            );
          }
        }
      },
    );
  }
}
