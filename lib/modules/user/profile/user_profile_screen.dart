import 'package:flutter/material.dart';
import 'package:mainproject/modules/auth/login_screen.dart';
import 'package:mainproject/modules/user/profile/user_edit_profile_screen.dart';
import 'package:mainproject/modules/user/user_add_complaint.dart';
import 'package:mainproject/services/api_service.dart';
import 'package:mainproject/utils/constants.dart';
import 'package:mainproject/widgets/custom_button.dart';
import 'package:mainproject/widgets/custom_text_field.dart';

class UserProfileScreen extends StatefulWidget {
  UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  TextEditingController _nameController = TextEditingController();

  TextEditingController _emailController = TextEditingController();

  TextEditingController _phoneControllers = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: ApiService().fetchProfile(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final profileData = snapshot.data!;

          _nameController.text = profileData['name'];
          _emailController.text = profileData['email'];
          _phoneControllers.text = profileData['phone'];

          return Center(
            child: Column(
              children: [
                AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  actions: [
                    IconButton(
                      onPressed: ()  async{
                      bool a =  await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserEditProfileScreen(
                              name: _nameController.text,
                              email: _emailController.text,
                              phone: _phoneControllers.text,
                            ),
                          ),
                        );
                      if(a){
                        setState(() {
                          
                        });
                      }
                      },
                      icon: Icon(
                        Icons.edit,
                        size: 30,
                        color: KButtonColor,
                      ),
                    )
                  ],
                ),
                const CircleAvatar(
                  radius: 100,
                  child: Icon(Icons.person),
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: CustomTextField(
                    hintText: 'name',
                    controller: _nameController,
                    isEnabled: false,
                    borderColor: Colors.grey.shade500,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: CustomTextField(
                    hintText: 'email',
                    controller: _emailController,
                    isEnabled: false,
                    borderColor: Colors.grey.shade500,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: CustomTextField(
                    hintText: 'phone',
                    controller: _phoneControllers,
                    isEnabled: false,
                    borderColor: Colors.grey.shade500,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(children: [
                    Expanded(
                      child: CustomButton(
                        text: 'Log out',
                        color: KButtonColor,
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
                              (route) => false);
                        },
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: CustomButton(
                        text: 'complaint',
                        color: KButtonColor,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserAddComplaintScreen(),
                              ));
                        },
                      ),
                    ),
                  ]),
                )
              ],
            ),
          );
        }
      },
    );
  }
}
