import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mainproject/Db/db_service.dart';
import 'package:mainproject/services/api_service.dart';

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({Key? key}) : super(key: key);

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  Future<List<dynamic>>? _futureFeedback;

  @override
  void initState() {
    super.initState();
    _futureFeedback = _fetchFeedback();
  }

  Future<List<dynamic>> _fetchFeedback() async {
    final loginId = DbService.getLoginId();
    final url = Uri.parse('${ApiService.baseUrl}/api/user/view-order/$loginId');

    print(url);
    final response = await http.get(url);

    print(response.body);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['Data'];

      return data;
    } else {
      throw Exception('Failed to load feedback');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Orders'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _futureFeedback,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return snapshot.data!.isEmpty
                ? Center(
                    child: Text('No bookings'),
                  )
                : ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final feedback = snapshot.data![index];

                      return Container(
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                            color: Colors.grey.shade300,
                          ),
                        ),
                        child: ListTile(
                          onTap: () {},
                          leading: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(Icons.bookmark)),
                          title: Text(
                            'order',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(feedback['subtotal'].toString()),
                        ),
                      );
                    },
                  );
          }
        },
      ),
    );
  }
}
