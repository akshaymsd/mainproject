import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mainproject/modules/staff/staff_root_screen.dart';
import 'package:mainproject/services/api_service.dart';
import 'package:mainproject/widgets/custom_button.dart';
import 'package:mainproject/widgets/custom_text_field.dart';

class StaffUpdateEventScreen extends StatefulWidget {
  const StaffUpdateEventScreen(
      {super.key,
      required this.eventType,
      required this.color,
      required this.price,
      required this.description,
      required this.productId});

  final String eventType;
  final String color;
  final String price;
  final String description;
  final String productId;

  @override
  State<StaffUpdateEventScreen> createState() => _StaffUpdateEventScreenState();
}

class _StaffUpdateEventScreenState extends State<StaffUpdateEventScreen> {
  final ImagePicker picker = ImagePicker();
  XFile? image;

  void _getFromCamera() async {
    image = await picker.pickImage(source: ImageSource.camera);
  }

  void _getFromgallary() async {
    image = await picker.pickImage(source: ImageSource.gallery);
  }

  final TextEditingController eventTypeController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool loading = false;

  @override
  void dispose() {
    eventTypeController.dispose();

    priceController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    eventTypeController.text = widget.eventType;
    priceController.text = widget.price;
    descriptionController.text = widget.description;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upadate Event'),
      ),
      bottomSheet: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: CustomButton(
          text: 'Update',
          onPressed: () async {
            if (!areControllersEmpty()) {
              setState(() {
                loading = true;
              });

              var request = http.MultipartRequest(
                'PUT',
                Uri.parse(
                    '${ApiService.baseUrl}/api/staff/update-event/${widget.productId}'),
              );

              // Add form fields
              request.fields['event_type'] = eventTypeController.text;
              request.fields['price'] = priceController.text;
              request.fields['description'] = descriptionController.text;

              // Add image file
              if (image != null) {
                request.files.add(
                  await http.MultipartFile.fromPath('image', image!.path),
                );
              }

              // Send the request
              var response = await request.send();

              print(response.statusCode);

              if (response.statusCode == 200) {
                // Handle successful response
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Event updated successfully'),
                  ),
                );

                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StaffRootScreen(),
                    ),
                    (route) => false);
              } else {
                // Handle error response

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Failed to update'),
                  ),
                );
              }

              setState(() {
                loading = false;
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All fields are required'),
                ),
              );
            }
          },
        ),
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  fixedSize: const Size(150, 50)),
                              onPressed: () {
                                showModalBottomSheet(
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  builder: (context) => Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                  backgroundColor: Colors.white,
                                                  fixedSize: Size(
                                                      MediaQuery.of(context)
                                                          .size
                                                          .width,
                                                      50)),
                                              onPressed: () {
                                                _getFromCamera();
                                                Navigator.pop(context);
                                              },
                                              child: const Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons
                                                      .camera_alt_outlined),
                                                  Text("Take a photo")
                                                ],
                                              )),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                  backgroundColor: Colors.white,
                                                  fixedSize: Size(
                                                      MediaQuery.of(context)
                                                          .size
                                                          .width,
                                                      50)),
                                              onPressed: () {
                                                _getFromgallary();
                                                Navigator.pop(context);
                                              },
                                              child: const Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(CupertinoIcons
                                                      .photo_on_rectangle),
                                                  Text("Upload from gallary")
                                                ],
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: const Text("Add photo")),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: image == null
                                      ? const Text("upload image")
                                      : Image(
                                          image: FileImage(File(image!.path))),
                                ),
                              );
                            },
                            icon: const Icon(
                              CupertinoIcons.eye,
                              size: 30,
                            ))
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                      hintText: 'Enter name',
                      controller: eventTypeController,
                      borderColor: Colors.grey,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                      hintText: 'Enter description',
                      controller: descriptionController,
                      borderColor: Colors.grey,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                      hintText: 'Enter price',
                      controller: priceController,
                      borderColor: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  bool areControllersEmpty() {
    return eventTypeController.text.isEmpty &&
        priceController.text.isEmpty &&
        descriptionController.text.isEmpty;
  }
}
