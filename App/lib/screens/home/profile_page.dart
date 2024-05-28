import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:petcare/screens/general/navigation_bar.dart';

import '../general/generic_app_bar.dart';
import '../data/firebase_functions.dart';
import '../../main.dart';
import 'configrfid_page.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  late TextEditingController oldPasswordController;
  late TextEditingController newPasswordController;

  @override
  void initState() {
    oldPasswordController = TextEditingController();
    newPasswordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: const Color(0xfffafbfa),
      appBar: GenericAppBar(
        title: "My Profile",
        actions: [
          IconButton(
            icon: Icon(Icons.settings, size: 40, color: Colors.brown.shade800),
            onPressed: () {
              // Add your onPressed logic here
            },
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 10),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                CircleAvatar(
                  backgroundImage: const AssetImage('assets/images/Logo2.png'),
                  radius: 60,
                  child: Container(
                      margin: const EdgeInsets.only(left: 70, top: 80),
                      child: IconButton(
                        hoverColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onPressed: () {},
                        icon: Icon(
                          Icons.camera_alt,
                          size: 35,
                          color: Colors.brown.shade800,
                        ),
                      )),
                ),
                myInfo(context),
                changePassword(context),
                ConnectRfid(context),
                myLogOut(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget myInfo(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          return Container(
            margin: const EdgeInsets.all(20),
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildInfoRow(context, 'Name', data['name'] ?? '', data),
                  const SizedBox(height: 10),
                  _buildInfoRow(context, 'Email', data['email'] ?? '', data),
                ],
              ),
            ),
          );
        }
        return const CircularProgressIndicator(); // Show a loading indicator while fetching
      },
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value,
      Map<String, dynamic> data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$label:',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.brown.shade800,
          ),
        ),
        Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 2,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.brown.shade800),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                value,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18,
                  color: Colors.brown.shade800,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.edit, color: Colors.brown.shade800),
              onPressed: () async {
                final newName = await showDialog<String>(
                  context: context,
                  builder: (context) => _buildEditDialog(
                      context, label, data[label.toLowerCase()] ?? ''),
                );

                if (newName != null) {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .update({label.toLowerCase(): newName});
                  // Update your widget state here to trigger a rebuild
                }
              },
              // ... (rest of the IconButton code)
            )
          ],
        ),
      ],
    );
  }

  Widget _buildEditDialog(
      BuildContext context, String label, String currentValue) {
    TextEditingController controller =
        TextEditingController(text: currentValue);
    return AlertDialog(
      title: Text('Edit $label'),
      content: TextField(
        controller: controller,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, controller.text);
            Navigator.pushReplacement(context, 
            MaterialPageRoute(builder: (context) => NavigationBarScreen()));
          },
          child: Text('Save'),
        ),
      ],
    );
  }

  Widget changePassword(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 20, top: 20),
            child: Text(
              'Security Settings',
              style: TextStyle(
                  fontFamily: 'Rowdies',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.brown.shade800),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Change Password',
                  style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.brown.shade800),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: oldPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.transparent,
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.brown.shade800),
                        borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.brown.shade800),
                        borderRadius: BorderRadius.circular(10)),
                    labelText: 'Old Password',
                    labelStyle: TextStyle(
                        color: Colors.brown.shade800, fontFamily: 'Inter'),
                    floatingLabelStyle: TextStyle(color: Colors.brown.shade800),
                    prefixIcon: Icon(
                      Icons.key,
                      color: Colors.brown.shade800,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: newPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.transparent,
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.brown.shade800),
                        borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.brown.shade800),
                        borderRadius: BorderRadius.circular(10)),
                    labelText: 'New Password',
                    labelStyle: TextStyle(
                        color: Colors.brown.shade800, fontFamily: 'Inter'),
                    floatingLabelStyle: TextStyle(color: Colors.brown.shade800),
                    prefixIcon: Icon(
                      Icons.key,
                      color: Colors.brown.shade800,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.brown.shade800,
                    textStyle: const TextStyle(
                        fontSize: 15,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text('Change Password'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

Widget myLogOut(BuildContext context) {
  return Container(
    margin: const EdgeInsets.all(20),
    width: MediaQuery.of(context).size.width * 0.9,
    decoration: BoxDecoration(
      color: Colors.grey.shade200,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              'Logout',
              style: TextStyle(
                  fontFamily: 'Rowdies',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.brown.shade800),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.brown.shade800,
              textStyle: const TextStyle(
                  fontSize: 15,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Auth().signOut();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LandingPage()),
              );
            },
            child: const Text('Logout'),
          ),
          SizedBox(height: 20),
        ],
      ),
    ),
  );
}

Widget ConnectRfid(BuildContext context) {
  return Container(
    margin: const EdgeInsets.all(20),
    width: MediaQuery.of(context).size.width * 0.9,
    decoration: BoxDecoration(
      color: Colors.grey.shade200,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              'Connect your RFID',
              style: TextStyle(
                  fontFamily: 'Rowdies',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.brown.shade800),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.brown.shade800,
              textStyle: const TextStyle(
                  fontSize: 15,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ConfigRfid_page()),
              );
              // Assuming you have a MapPage to navigate to
            },
            child: const Text('Connect'),
          ),
          SizedBox(height: 20),
        ],
      ),
    ),
  );
}
