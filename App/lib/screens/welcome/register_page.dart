import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:petcare/screens/data/firebase_functions.dart';
import 'package:petcare/main.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

  @override
  void initState() {
    nameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
        emailController.text,
        passwordController.text,
        nameController.text,
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LandingPage()),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'An error occurred during registing.'),
          backgroundColor:
              Colors.red, // Optional: change background color to red for errors
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 50),
                child: Row(
                  children: [
                    ClipOval(
                      child: Image.asset(
                        'assets/images/Logo2.png',
                        width: 140,
                        height: 140,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Register on',
                            style: TextStyle(
                                color: Colors.brown.shade800,
                                fontFamily: 'Inter',
                                fontSize: 25),
                          ),
                          Text(
                            'PetCare',
                            style: TextStyle(
                                color: Colors.brown.shade800,
                                fontFamily: 'Inter',
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 10, top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Don't have an account yet?",
                      style: TextStyle(
                        color: Colors.brown.shade800,
                        fontFamily: 'Inter',
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Create your account here',
                      style: TextStyle(
                          color: Colors.brown.shade800,
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "We can't wait to have you!",
                      style: TextStyle(
                        color: Colors.brown.shade800,
                        fontFamily: 'Inter',
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)),
                    labelText: 'Name',
                    labelStyle: const TextStyle(
                        color: Colors.grey, fontFamily: 'Inter'),
                    floatingLabelStyle: TextStyle(color: Colors.brown.shade800),
                    prefixIcon: Icon(
                      Icons.person,
                      color: Colors.brown.shade800,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)),
                    labelText: 'Email',
                    labelStyle: const TextStyle(
                        color: Colors.grey, fontFamily: 'Inter'),
                    floatingLabelStyle: TextStyle(color: Colors.brown.shade800),
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: Colors.brown.shade800,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: TextField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)),
                    labelText: 'Phone',
                    labelStyle: const TextStyle(
                        color: Colors.grey, fontFamily: 'Inter'),
                    floatingLabelStyle: TextStyle(color: Colors.brown.shade800),
                    prefixIcon: Icon(
                      Icons.phone_android_outlined,
                      color: Colors.brown.shade800,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)),
                    labelText: 'Password',
                    labelStyle: const TextStyle(
                        color: Colors.grey, fontFamily: 'Inter'),
                    floatingLabelStyle: TextStyle(color: Colors.brown.shade800),
                    prefixIcon: Icon(
                      Icons.key,
                      color: Colors.brown.shade800,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: TextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)),
                    labelText: 'Repeat Password',
                    labelStyle: const TextStyle(
                        color: Colors.grey, fontFamily: 'Inter'),
                    floatingLabelStyle: TextStyle(color: Colors.brown.shade800),
                    prefixIcon: Icon(
                      Icons.key,
                      color: Colors.brown.shade800,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                margin: const EdgeInsets.only(left: 10, right: 10),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CheckboxButton(),
                    Text(
                      'I agree to the Terms and Conditions',
                      style: TextStyle(
                          fontFamily: 'Inter',
                          color: Colors.grey,
                          fontSize: 14),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.brown.shade800,
                        backgroundColor: const Color(0xFFC8E7F4),
                        textStyle: const TextStyle(
                            fontSize: 20,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        //Navigator.push(context,
                        // MaterialPageRoute(builder: (context) => const NavigationBarScreen()));
                        createUserWithEmailAndPassword();
                      },
                      child: Container(
                          padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
                          child: const Text('REGISTER')),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CheckboxButton extends StatefulWidget {
  const CheckboxButton({super.key});

  @override
  State<CheckboxButton> createState() => _CheckboxButtonState();
}

class _CheckboxButtonState extends State<CheckboxButton> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return const Color(0xFFC8E7F4);
      }
      return Colors.brown.shade800;
    }

    return Checkbox(
      checkColor: Colors.white,
      fillColor: MaterialStateProperty.resolveWith(getColor),
      value: isChecked,
      onChanged: (bool? value) {
        setState(() {
          isChecked = value!;
        });
      },
    );
  }
}
