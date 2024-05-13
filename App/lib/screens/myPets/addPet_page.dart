import 'package:flutter/material.dart';

import '../general/generic_app_bar.dart';


class AddPetScreen extends StatefulWidget {
  const AddPetScreen({Key? key}) : super(key: key);

  @override
  State<AddPetScreen> createState() => _AddPetScreenState();
}

class _AddPetScreenState extends State<AddPetScreen> {

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: const Color(0xfffafbfa),
      appBar:
      GenericAppBar(
        title: "Add New Pet",
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_month, size: 40, color: Colors.brown.shade800),
            onPressed: () {
              // Add your onPressed logic here
            },
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
          Container(
          margin: const EdgeInsets.only(left: 10, top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 141.69,
                height: 129.25,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                        width: 141.69,
                        height: 129.25,
                        decoration: ShapeDecoration(
                          color: Color(0xFFF6F6F6),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(width: 1, color: Color(0xFFE7E7E7)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 20.91,
                      top: 53.56,
                      child: SizedBox(
                        width: 99.88,
                        height: 23.29,
                        child: Text(
                          'Add Photo',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFFABABAB),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            height: 0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
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
                        borderRadius: BorderRadius.circular(10)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    labelText: 'Name',
                    labelStyle: const TextStyle(color: Colors.grey, fontFamily: 'Inter'),
                    floatingLabelStyle: TextStyle(color: Colors.brown.shade800),
                    prefixIcon: Icon(Icons.person, color: Colors.brown.shade800,),
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
                  controller: phoneController,
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
                    labelText: 'Phone',
                    labelStyle: const TextStyle(color: Colors.grey, fontFamily: 'Inter'),
                    floatingLabelStyle: TextStyle(color: Colors.brown.shade800),
                    prefixIcon: Icon(Icons.phone_android_outlined, color: Colors.brown.shade800,),
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
                        borderRadius: BorderRadius.circular(10)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    labelText: 'Repeat Password',
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    CheckboxButton(),
                    Text(
                      'I agree to the Terms and Conditions',
                      style: TextStyle(
                          fontFamily: 'Inter',
                          color: Colors.grey,
                          fontSize: 14
                      ),
                    )
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
                        //Navigator.push(context,
                        // MaterialPageRoute(builder: (context) => const NavigationBarScreen()));
                      },
                      child: Container(
                          padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
                          child: const Text('REGISTER')
                      ),

                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ])),
    )) ;

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
