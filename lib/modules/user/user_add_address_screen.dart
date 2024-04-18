import 'package:flutter/material.dart';
import 'package:mainproject/Db/db_service.dart';
import 'package:mainproject/services/api_service.dart';
import 'package:mainproject/widgets/custom_button.dart';
import 'package:mainproject/widgets/custom_text_field.dart';

class UserAddAddressScreen extends StatefulWidget {
  const UserAddAddressScreen({super.key});

  @override
  State<UserAddAddressScreen> createState() => _UserAddAddressScreenState();
}

class _UserAddAddressScreenState extends State<UserAddAddressScreen> {
  String? emailError;
  String? passwordError;

  bool _obscureText = true;

  final _addressController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _stateController = TextEditingController();
  final _cityController = TextEditingController();
  final _landmarkController = TextEditingController();
  final _userRegisterFormKey = GlobalKey<FormState>();
  final _nameControllers = TextEditingController();
  final _phoneControllers = TextEditingController();

  bool loading = false;

  @override
  void dispose() {
    _addressController.dispose();
    _pincodeController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    _landmarkController.dispose();
    _nameControllers.dispose();

    super.dispose();
  }

  String? fieldValidate(String? value, String fieldsName) {
    if (value == null || value.isEmpty) {
      return 'Please enter an  $fieldsName';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Add address',
          style: TextStyle(
              color: Colors.black, fontSize: 25, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _userRegisterFormKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 60,
                ),
                CustomTextField(
                  hintText: 'Enter name',
                  controller: _nameControllers,
                  borderColor: Colors.grey.shade300,
                  validator: (value) => fieldValidate(value, 'name'),
                ),
                SizedBox(
                  height: 30,
                ),
                CustomTextField(
                  hintText: 'Enter Address',
                  controller: _addressController,
                  borderColor: Colors.grey.shade300,
                  validator: (value) => fieldValidate(value, 'name'),
                ),
                const SizedBox(height: 30),
                CustomTextField(
                  hintText: 'Enter pincode',
                  controller: _pincodeController,
                  input: TextInputType.number,
                  borderColor: Colors.grey.shade300,
                  validator: (value) => fieldValidate(value, 'pincode'),
                ),
                const SizedBox(height: 30),
                CustomTextField(
                  hintText: 'Enter city',
                  controller: _cityController,
                  input: TextInputType.text,
                  borderColor: Colors.grey.shade300,
                  validator: (value) => fieldValidate(value, 'city'),
                ),
                const SizedBox(height: 30),
                CustomTextField(
                  hintText: 'Enter land mark',
                  controller: _landmarkController,
                  validator: (value) => fieldValidate(value, 'land mark'),
                  borderColor: Colors.grey.shade300,
                ),
                const SizedBox(height: 30),
                CustomTextField(
                  hintText: 'Enter state',
                  controller: _stateController,
                  validator: (value) => fieldValidate(value, 'land state'),
                  borderColor: Colors.grey.shade300,
                ),
                SizedBox(
                  height: 30,
                ),
                CustomTextField(
                  hintText: 'Enter phone',
                  controller: _phoneControllers,
                  validator: (value) => fieldValidate(value, 'land mark'),
                  borderColor: Colors.grey.shade300,
                ),
                const SizedBox(height: 30),
                loading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.teal,
                        ),
                      )
                    : SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: CustomButton(
                          text: 'ADD',
                          onPressed: () async {
                            if (_userRegisterFormKey.currentState!.validate()) {
                              final addressData = {
                                'address': _addressController.text,
                                'pincode': _pincodeController.text,
                                'state': _stateController.text,
                                'city': _cityController.text,
                                'landmark': _landmarkController.text,
                                'name': _nameControllers.text,
                                'phone': _phoneControllers.text
                              };

                              setState(() {
                                loading = true;
                              });

                              await ApiService().addAddress(
                                  DbService.getLoginId(), addressData, context);
                            }

                            setState(() {
                              loading = false;
                            });
                          },
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
