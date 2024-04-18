import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mainproject/Db/db_service.dart';
import 'package:mainproject/modules/staff/staff_root_screen.dart';
import 'package:mainproject/modules/user/bookings/user_booking_confirmation.dart';

class ApiService {
  static const baseUrl = 'https://event-management-server-d9c9.onrender.com';

  Future<bool> registerUser({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/api/register/user');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }

  Future<int> loginUser(String email, String password) async {
    final url = Uri.parse('$baseUrl/api/login');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'email': email,
        'password': password,
      },
    );
    print(response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      DbService.setLoginId(data['login_id']);

      return data['role'];
    } else {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }

  //profile
  Future<Map<String, dynamic>> fetchProfile() async {
    final response = await http
        .get(Uri.parse('$baseUrl/api/profile/user/${DbService.getLoginId()}'));

    print(Uri.parse('$baseUrl/api/profile/user/${DbService.getLoginId()}'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'][0];
    } else {
      throw Exception('Failed to load profile');
    }
  }

  Future<void> addComplaint(
      String loginId, String complaint, BuildContext context) async {
    final url = Uri.parse('$baseUrl/api/user/add-complaint/$loginId');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'complaint': complaint,
        'date':
            '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}'
      },
    );

    print(response.body);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(jsonDecode(response.body)['Message'])));
    } else {
      throw Exception(jsonDecode(response.body)['Message']);
    }
  }

//view complaint
  Future<List<dynamic>> fetchComplaints() async {
    final loginId = DbService.getLoginId();
    final url = Uri.parse('$baseUrl/api/user/view-complaint/$loginId');
    final response = await http.get(url);

    print(response.body);

    if (response.statusCode == 201) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data;
    } else {
      throw Exception('Failed to load complaints');
    }
  }

  //add book event
  Future<void> bookEvent(BuildContext context, String loginId, String eventId,
      String date, String location) async {
    final url = Uri.parse('$baseUrl/api/user/book-event/$loginId/$eventId');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'date': date,
          'location': location,
        },
      );

      if (response.statusCode == 201) {
        print('Event booked successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event booked successfully')),
        );
      } else {
        print('Failed to book event: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to book event: ${response.statusCode}')),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<List<dynamic>> viewCart(String loginId) async {
    final url = Uri.parse('$baseUrl/api/user/view-cart/$loginId');
    final response = await http.get(url);

    print(response.body);

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    } else {
      throw Exception('Failed to load cart data');
    }
  }

  Future<void> addAddress(
      String loginId, Map<String, dynamic> data, BuildContext context) async {
    final url = Uri.parse('$baseUrl/api/user/add-address/$loginId');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: data,
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Address added!!!!!!!')));
        Navigator.pop(context, data);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Faild!!!')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Faild!!!!!!!')));
    }
  }

  Future<void> addCartItem(
      String loginId, String productId, String price) async {
    final url = Uri.parse('$baseUrl/api/user/add-cart/$loginId/$productId');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'price': price,
        },
      );

      if (response.statusCode == 200) {
        print('Item added to cart successfully');
      } else {
        print('Failed to add item to cart: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> placeOrder(BuildContext context) async {
    final url = Uri.parse(
        '$baseUrl/api/user/place-order-prod/${DbService.getLoginId()}');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order placed successfully')),
        );

        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const UserBookingConfirmScreen(),
            ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to place order: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

//user update

  Future<void> updateUserProfile(
      {required BuildContext context,
      required String loginId,
      required String name,
      required String phone,
      required String email}) async {
    final url = Uri.parse('$baseUrl/api/user/update-user-profile/$loginId');

    final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    final body = {
      'name': name,
      'phone': phone,
      'email': email,
    };

    try {
      final response = await http.put(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('User profile updated successfully'),
          backgroundColor: Colors.green,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text('Failed to update user profile: ${response.statusCode}'),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error updating user profile: $e'),
        backgroundColor: Colors.red,
      ));
    }
  }

  //get staff profile

  //get profile
  Future<List<dynamic>> getStaffProfile(String loginId) async {
    final url = '$baseUrl/api/profile/staff/$loginId';

    try {
      final response = await http.get(Uri.parse(url));

      print(response.body);

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['data'];
      } else {
        throw Exception('Somthing went wrong');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateBookingStatus(
      {required String id,
      required String bookedDate,
      required BuildContext context}) async {
    Uri url = Uri.parse('');
    var response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        // Add any additional form fields here if needed
      },
    );

    if (response.statusCode == 200) {
      // Handle successful response
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Booking status updated successfully'),
        ),
      );
    } else {
      // Handle error response
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update booking status'),
        ),
      );
    }
  }

//delete
  Future<void> deleteProduct(
      {required String productId, required BuildContext context}) async {
    var url = Uri.parse('$baseUrl/api/staff/delete-product/$productId');
    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    );

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      // Handle successful response
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product deleted successfully'),
        ),
      );

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const StaffRootScreen(),
          ),
          (route) => false);
    } else {
      // Handle error response
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to delete product'),
        ),
      );
    }
  }

  //delete event

  Future<void> deleteEvent(String productId, BuildContext context) async {
    var url = Uri.parse('$baseUrl/api/staff/delete-event/$productId');
    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        // Add any other headers if needed
      },
    );

    if (response.statusCode == 200) {
      // Handle successful response
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product deleted successfully'),
        ),
      );

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const StaffRootScreen(),
          ),
          (route) => false);
    } else {
      // Handle error response
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to delete product'),
        ),
      );
    }
  }

  Future<void> updateCartQuantity(
      {required int quantity,
      required String productId,
      required BuildContext context}) async {
    final url =
        '$baseUrl/api/user/update-cart-quantity/${DbService.getLoginId()}/$productId';
    final response = await http.post(
      Uri.parse(url),
      body: {'quantity': quantity.toString()},
    );

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, show a success message.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cart quantity updated successfully'),
        ),
      );
    } else {
      // If the server did not return a 200 OK response, show an error message.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update cart quantity'),
        ),
      );
    }
  }
} //close
