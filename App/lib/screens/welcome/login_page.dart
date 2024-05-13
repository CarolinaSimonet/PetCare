import 'package:flutter/material.dart';

import '../general/navigation_bar.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
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
                            'Login on',
                            style: TextStyle(
                                color: Colors.brown.shade800,
                                fontFamily: 'Inter',
                                fontSize: 25
                            ),
                          ),
                          Text(
                            'PetCare',
                            style: TextStyle(
                                color: Colors.brown.shade800,
                                fontFamily: 'Inter',
                                fontSize: 25,
                                fontWeight: FontWeight.bold
                            ),
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
                      'If you already have an',
                      style: TextStyle(
                        color: Colors.brown.shade800,
                        fontFamily: 'Inter',
                        fontSize: 16,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'account ',
                          style: TextStyle(
                            color: Colors.brown.shade800,
                            fontFamily: 'Inter',
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'login here',
                          style: TextStyle(
                              color: Colors.brown.shade800,
                              fontFamily: 'Inter',
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        Text(
                          '.',
                          style: TextStyle(
                            color: Colors.brown.shade800,
                            fontFamily: 'Inter',
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 80,),
              Container(
                margin: const EdgeInsets.all(10),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    labelText: 'Email',
                    labelStyle: const TextStyle(color: Colors.grey, fontFamily: 'Inter'),
                    floatingLabelStyle: TextStyle(color: Colors.brown.shade800),
                    prefixIcon: Icon(Icons.email_outlined, color: Colors.brown.shade800,),
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
                        borderRadius: BorderRadius.circular(10)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    labelText: 'Password',
                    labelStyle: const TextStyle(color: Colors.grey, fontFamily: 'Inter'),
                    floatingLabelStyle: TextStyle(color: Colors.brown.shade800),
                    prefixIcon: Icon(Icons.key, color: Colors.brown.shade800,),
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              Container(
                margin: const EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        CheckboxButton(),
                        Text(
                          'Remember me',
                          style: TextStyle(
                              fontFamily: 'Inter',
                              color: Colors.grey,
                              fontSize: 14
                          ),
                        )
                      ],
                    ),
                    TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                              fontFamily: 'Inter',
                              color: Colors.grey,
                              fontSize: 14
                          ),
                        )
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.brown.shade800, backgroundColor: const Color(0xFFC8E7F4),
                        textStyle: const TextStyle(fontSize: 20, fontFamily: 'Inter', fontWeight: FontWeight.w700),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => const NavigationBarScreen()));
                      },
                      child: Container(
                          padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
                          child: const Text('LOGIN')
                      ),

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
        return Colors.blue.shade50;
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
