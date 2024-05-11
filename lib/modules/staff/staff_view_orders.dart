import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mainproject/services/api_service.dart';

class StaffViewOrders extends StatelessWidget {
  const StaffViewOrders({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Orders'),
      ),
      body: FutureBuilder(
        future: fetchOrders(), // Your future function that fetches data
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // Use ListView.builder here with snapshot.data
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) => Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  leading: Icon(Icons.book),
                  trailing: Text(
                    'Status :${snapshot.data[index]['order_status']} ',
                    style: TextStyle(color: Colors.green),
                  ),
                  title: Text('order${index}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('price : ${snapshot.data[index]['price']}'),
                      Text('quantity : ${snapshot.data[index]['quantity']}'),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Future<List<dynamic>> fetchOrders() async {
    final response = await http
        .get(Uri.parse('${ApiService.baseUrl}/api/staff/view-orders'));

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON

      print(response.body);
      final List<dynamic> data = json.decode(response.body)['Data'];

      // Assuming the JSON response is an array of orders
      return data;
    } else {
      // If the server returns an error response, throw an exception
      throw Exception('Failed to load orders');
    }
  }

  // Example function for fetching data, replace this with your actual implementation
}
