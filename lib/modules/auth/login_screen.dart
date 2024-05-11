import 'package:flutter/material.dart';
import 'package:mainproject/modules/auth/forgot_password_screen.dart';
import 'package:mainproject/modules/auth/user_registrattion_screen.dart';
import 'package:mainproject/modules/staff/staff_root_screen.dart';
import 'package:mainproject/modules/user/user_root_screen.dart';
import 'package:mainproject/services/api_service.dart';
import 'package:mainproject/utils/constants.dart';
import 'package:mainproject/utils/validator.dart';
import 'package:mainproject/widgets/custom_button.dart';
import 'package:mainproject/widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  var outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: const BorderSide(color: Colors.white),
  );

  String? emailError;
  String? passwordError;

  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                'Sign in',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.w600),
              ),
            ),
            CustomTextField(
              hintText: 'Enter Email',
              controller: _emailController,
              errorText: emailError,
              borderColor: Colors.grey.shade300,
            ),
            const SizedBox(height: 30),
            CustomTextField(
              hintText: 'Enter password',
              controller: _passwordController,
              errorText: passwordError,
              obscureText: _obscureText,
              borderColor: Colors.grey.shade300,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ForgotPasswordScreen()),
                  );
                },
                child: const Text(
                  'Forget password',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            _loading
                ? Center(
                    child: CircularProgressIndicator(
                      color: KButtonColor,
                    ),
                  )
                : SizedBox(
                    width: MediaQuery.of(context).size.width / 1.2,
                    height: 50,
                    child: CustomButton(
                      text: 'SIGN IN',
                      color: KButtonColor,
                      onPressed: () {
                        _loginHandler();
                      },
                    ),
                  ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Dont have an account?',
                  style: TextStyle(color: Colors.black),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserRegistrationScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Register',
                      style: TextStyle(
                          color: KButtonColor, fontWeight: FontWeight.bold),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }

  void _loginHandler() async {
    setState(() {
      emailError = validateEmail(_emailController.text);
      passwordError = validatePassword(_passwordController.text);
    });
    if (emailError == null && passwordError == null) {
      try {
        setState(() {
          _loading = true;
        });

        int role = await ApiService()
            .loginUser(_emailController.text, _passwordController.text);

        if (role == 2) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserRootScreen(),
              ));
        }

        if (role == 3) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StaffRootScreen(),
              ));
        }

        setState(() {
          _loading = false;
        });
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString()),
            ),
          );
        }
        setState(() {
          _loading = false;
        });
      }
    }
  }
}
