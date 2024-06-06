import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class ActivitiesListPage extends StatefulWidget {
  @override
  _ActivitiesListPageState createState() => _ActivitiesListPageState();
}

class _ActivitiesListPageState extends State<ActivitiesListPage> {
  final userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: const Color(0xfffafbfa),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0,
        toolbarHeight: 100,
        title: Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 10.0),
          child: Text(
            'My Activities',
            style: TextStyle(
              color: Colors.brown.shade800,
              fontSize: 36,
              fontWeight: FontWeight.w900,
              fontFamily: 'Rowdies',
            ),
          ),
        ),
      ),
      body: userId == null
          ? Center(child: Text("No user logged in"))
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('activities')
                  .where('userId', isEqualTo: userId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  default:
                    return ListView(
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        DateTime date = (data['date'] as Timestamp).toDate();

                        // Format DateTime
                        String formattedDate = DateFormat('yyyy-MM-dd – kk:mm')
                            .format(date); // Customize the format as needed
                        return Card(
                          child: Column(
                            children: <Widget>[
                              Image.network(
                                data['imageUrl'],
                                fit: BoxFit.cover,
                                height: 200,
                                width: double.infinity,
                              ),
                              ListTile(
                                title: Text(data['description']),
                                subtitle: Text('Date: ${formattedDate}'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    'Distance: ${data['distance']} meters'),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                }
              },
            ),
    );
  }
}
