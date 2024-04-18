import 'package:flutter/material.dart';
import 'package:mainproject/Db/db_service.dart';
import 'package:mainproject/modules/user/cartlist_screen.dart';
import 'package:mainproject/services/api_service.dart';
import 'package:mainproject/widgets/custom_button.dart';

class UserProductDetailsScreeen extends StatefulWidget {
  const UserProductDetailsScreeen({super.key, required this.details});

  final Map<String, dynamic> details;

  @override
  State<UserProductDetailsScreeen> createState() =>
      _UserProductDetailsScreeenState();
}

class _UserProductDetailsScreeenState extends State<UserProductDetailsScreeen> {
  DateTime? newDateTime;

  bool loading = false;

  final locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
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
            Expanded(
              flex: 2,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListView(
                      children: [
                        const Text(
                          'Name',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          widget.details['name'],
                          maxLines: 8,
                          style: TextStyle(color: Colors.grey.shade400),
                        ),
                        const SizedBox(
                          height: 20,
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
                          'Color',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          widget.details['color'],
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
                      text: 'Add to Cart',
                      onPressed: () async {
                        try {
                          setState(() {
                            loading = true;
                          });

                          await ApiService().addCartItem(
                              DbService.getLoginId(),
                              widget.details['_id'],
                              widget.details['price'].toString());

                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Row(
                            children: [
                              const Text('item added'),
                              const Spacer(),
                              TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const UserCartListScreen(),
                                        ));
                                  },
                                  child: const Text(
                                    'Go to cart',
                                    style: TextStyle(color: Colors.white),
                                  ))
                            ],
                          )));

                          setState(() {
                            loading = false;
                          });
                        } catch (e) {
                          print(e);

                          setState(() {
                            loading = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Row(
                            children: [
                              const Text('Faild'),
                            ],
                          )));
                        }
                      },
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
