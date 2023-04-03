import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hostel_finder_noor_rehman/screens/add_hostel_screen.dart';
import 'package:hostel_finder_noor_rehman/screens/landing_screen.dart';
import 'package:hostel_finder_noor_rehman/screens/update_hostel_screen.dart';
import 'package:hostel_finder_noor_rehman/widgets/n_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/hostel.dart';

class HostelsListScreen extends StatefulWidget {
  const HostelsListScreen({Key? key}) : super(key: key);

  @override
  State<HostelsListScreen> createState() => _HostelsListScreenState();
}

class _HostelsListScreenState extends State<HostelsListScreen> {
  DatabaseReference? hostelReference;
  String? uid;

  @override
  void initState() {
    super.initState();

    uid = FirebaseAuth.instance.currentUser!.uid;
    hostelReference = FirebaseDatabase.instance.ref().child('hostels');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      drawer: const NDrawer(),
      appBar: AppBar(
        title: const Text('Manage Hostel Details'),

        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (ctx) {
                      return AlertDialog(
                        title: const Text('Confirmation !!!'),
                        content: const Text('Are you sure to Log Out ? '),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                            child: const Text('No'),
                          ),
                          TextButton(
                            onPressed: () async{
                              Navigator.of(ctx).pop();

                              await FirebaseAuth.instance.signOut();

                              SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
                              await sharedPrefs.clear();

                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (context) {
                                return const LandingScreen();
                              }));
                            },
                            child: const Text('Yes'),
                          ),
                        ],
                      );
                    });
              },
              icon: const Icon(Icons.logout)),
        ],
      ),
      floatingActionButton: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20))),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return const AddHostelScreen();
          }));
        },
        icon: const Icon(Icons.house),
        label: const Text('Add Hostel'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: StreamBuilder(
          stream: hostelReference?.onValue,
          builder: (context, snapshot) {
            if (snapshot.hasData && !snapshot.hasError) {
              var event = snapshot.data as DatabaseEvent;
              var snapshot2 = event.snapshot.value;
              if (snapshot2 == null) {
                return const Center(child: Text('No Hostels Added Yet'));
              }

              Map<String, dynamic> map =
                  Map<String, dynamic>.from(snapshot2 as Map);

              List<Hostel> hostels = [];

              for (var hostelMap in map.values) {
                Hostel hostel =
                    Hostel.fromMap(Map<String, dynamic>.from(hostelMap));
                if (hostel.ownerId == uid) {
                  hostels.add(hostel);
                }
              }

              if (hostels.isEmpty) {
                return const Center(child: Text('No Hostels Added Yet'));
              } else {
                return ListView.builder(
                    itemCount: hostels.length,
                    itemBuilder: (context, index) {
                      Hostel hostel = hostels[index];
                      return Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10)),
                                  child: Image.network(
                                    hostel.photos[0] as String,
                                    width: double.infinity,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  )),
                              const SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 5),
                                child: Text(
                                  hostel.hostelName,
                                  style: const TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: Row(children: [
                                    const Icon(
                                      Icons.location_city,
                                      color: Colors.grey,
                                    ),
                                    const Text(' City: '),
                                    Text(hostel.cityName,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold))
                                  ])),
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: Row(children: [
                                    const Icon(
                                      Icons.roofing,
                                      color: Colors.grey,
                                    ),
                                    const Text(' Hostel Name: '),
                                    Text(hostel.hostelName,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold))
                                  ])),
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: Row(children: [
                                    const Icon(
                                      Icons.person,
                                      color: Colors.grey,
                                    ),
                                    const Text(' Owner: '),
                                    Text(hostel.ownerName,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold))
                                  ])),
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: Row(children: [
                                    const Icon(
                                      Icons.phone,
                                      color: Colors.grey,
                                    ),
                                    const Text(' Contact: '),
                                    Text(hostel.contactNum,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold))
                                  ])),
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: Row(children: [
                                    const Icon(
                                      Icons.bed,
                                      color: Colors.grey,
                                    ),
                                    const Text(' Seats Available: '),
                                    Text(hostel.availableSeats,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold))
                                  ])),
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: Row(children: [
                                    const Icon(
                                      Icons.done_all,
                                      color: Colors.grey,
                                    ),
                                    const Text(' Seat Rent: '),
                                    Text(hostel.seatRent,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold))
                                  ])),
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: Row(children: [
                                    const Icon(
                                      Icons.map,
                                      color: Colors.grey,
                                    ),
                                    const Text(' Facilities: '),
                                    Expanded(
                                      child: Text(hostel.facilities,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    )
                                  ])),
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: Row(children: [
                                    const Icon(
                                      Icons.house,
                                      color: Colors.grey,
                                    ),
                                    const Text(' Total Rooms: '),
                                    Text(hostel.totalRooms,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold))
                                  ])),
                              Row(
                                children: [
                                  const SizedBox(width: 10,),
                                  Expanded(

                                    child: ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red),
                                        onPressed: () {
                                          showDialog(
                                              barrierDismissible: false,
                                              context: context, builder: (context){
                                            return AlertDialog(
                                              title: const Text('Confirmation !!!'),
                                              content: const Text('Are you sure to delete ?'),
                                              actions: [
                                                TextButton(onPressed: (){
                                                  Navigator.of(context).pop();
                                                }, child: const Text('No')),
                                                TextButton(onPressed: () async{
                                                  Navigator.of(context).pop();

                                                  await hostelReference?.child(hostel.hostelId).remove();
                                                  Fluttertoast.showToast(msg: 'Hostel Deleted');
                                                  }, child: const Text('Yes')),
                                              ],
                                            );
                                          });
                                        },
                                        icon: const Icon(Icons.delete),

                                        label: const Text('Delete')),
                                  ),
                                  const SizedBox(width: 10,),
                                  Expanded(
                                    child: ElevatedButton.icon(

                                        onPressed: () {
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                            return UpdateHostelScreen(hostel: hostel);
                                          }));
                                        },
                                        icon: const Icon(Icons.edit),
                                        label: const Text('Update')),
                                  ),
                                  const SizedBox(width: 10,),

                                ],
                              )
                            ],
                          ));
                    });
              }
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
