import 'dart:io';
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ndialog/ndialog.dart';

import '../models/facility.dart';
import '../models/hostel.dart';
import '../utils/network_connection.dart';

class UpdateHostelScreen extends StatefulWidget {
  final Hostel hostel;

  const UpdateHostelScreen({Key? key, required this.hostel}) : super(key: key);

  @override
  State<UpdateHostelScreen> createState() => _UpdateHostelScreenState();
}

class _UpdateHostelScreenState extends State<UpdateHostelScreen> {
  late TextEditingController _cityController,
      _contactController,
      _hostelNameController,
      _ownerNameController,
      _availableSeatsController,
      _rentController,
      _totalRoomsController;

  String facilities = '';
  bool imagePicked = false;
  File? imageFile;
  List<File>? imageFiles;
  List<Object> photos = [];


  List<Facility> facilitiesList = [
    Facility(name: 'WiFi', value: false),
    Facility(name: 'Bath', value: false),
    Facility(name: 'UPS', value: false),
    Facility(name: 'Laundry', value: false),
    Facility(name: 'Generator', value: false),
    Facility(name: 'Meals', value: false),
    Facility(name: 'Hot Water', value: false),
    Facility(name: 'Room Cleaning', value: false),
    Facility(name: 'Gas in Rooms', value: false),
    Facility(name: 'Kitchen with Rooms', value: false),
  ];

  final GeolocatorPlatform _geoLocatorPlatform = GeolocatorPlatform.instance;

  double latitude = 0.0;
  double longitude = 0.0;

  @override
  void initState() {
    super.initState();
    _cityController = TextEditingController();
    _contactController = TextEditingController();
    _hostelNameController = TextEditingController();
    _ownerNameController = TextEditingController();
    _availableSeatsController = TextEditingController();
    _rentController = TextEditingController();
    _totalRoomsController = TextEditingController();

    _cityController.text = widget.hostel.cityName;
    _contactController.text = widget.hostel.contactNum;
    _hostelNameController.text = widget.hostel.hostelName;
    _ownerNameController.text = widget.hostel.ownerName;
    _availableSeatsController.text = widget.hostel.availableSeats;
    _rentController.text = widget.hostel.seatRent;
    _totalRoomsController.text = widget.hostel.totalRooms;
    facilities = widget.hostel.facilities;
    // _getCurrentPosition();
  }

  @override
  void dispose() {
    super.dispose();
    _cityController.dispose();
    _contactController.dispose();
    _hostelNameController.dispose();
    _availableSeatsController.dispose();
    _rentController.dispose();
    _totalRoomsController.dispose();
  }

  _pickImageFrom({required ImageSource source}) async {
    XFile? xFile = await ImagePicker().pickImage(source: source);

    if (xFile == null) return;

    final tempImage = File(xFile.path);

    imageFile = tempImage;
    imagePicked = true;
    setState(() {});
  }

  _pickMultiplesImages() async {
    List<XFile>? xFiles = await ImagePicker().pickMultiImage();

    if (xFiles == null) return;

    if (xFiles.isEmpty) return;

    imageFiles = [];
    for (var xFile in xFiles) {
      imageFiles?.add(File(xFile.path));
    }

    imagePicked = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Hostel Record'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                'Hostel Details',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: _cityController,
                decoration: InputDecoration(
                    hintText: 'Enter City Name',
                    labelText: 'City Name',
                    prefixIcon: const Icon(Icons.house),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: _hostelNameController,
                decoration: InputDecoration(
                    hintText: 'Enter Hostel Name',
                    labelText: 'Hostel Name',
                    prefixIcon: const Icon(Icons.edit),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: _ownerNameController,
                decoration: InputDecoration(
                    hintText: 'Enter Owner Name',
                    labelText: 'Owner Name',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                keyboardType: TextInputType.number,
                maxLength: 11,
                controller: _contactController,
                decoration: InputDecoration(
                    hintText: 'Enter Contact Number',
                    labelText: 'Contact No',
                    prefixIcon: const Icon(Icons.phone),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                keyboardType: TextInputType.number,
                controller: _availableSeatsController,
                decoration: InputDecoration(
                    hintText: 'Enter Available Seats',
                    labelText: 'Seats Available',
                    prefixIcon: const Icon(Icons.bed),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                keyboardType: TextInputType.number,
                controller: _rentController,
                decoration: InputDecoration(
                    hintText: 'Enter Rent per Seat',
                    labelText: 'Seat Rent',
                    prefixIcon: const Icon(Icons.format_align_justify),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Facilities'),
                                content: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  height:
                                      MediaQuery.of(context).size.height * 0.8,
                                  margin: const EdgeInsets.all(20),
                                  child: StatefulBuilder(
                                    builder: (context, setState) {
                                      return ListView.builder(
                                          itemCount: facilitiesList.length,
                                          itemBuilder: (context, index) {
                                            //Facility facility = facilitiesList[index];

                                            return CheckboxListTile(
                                                title: Text(
                                                    facilitiesList[index].name),
                                                value:
                                                    facilitiesList[index].value,
                                                onChanged: (isChecked) {
                                                  print(isChecked);
                                                  setState(() {
                                                    facilitiesList[index]
                                                        .value = isChecked!;
                                                  });
                                                });
                                          });
                                    },
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();

                                        setState(() {
                                          facilities = '';
                                          for (var facility in facilitiesList) {
                                            if (facility.value) {
                                              facilities += facility.name + ',';
                                            }
                                          }
                                        });
                                      },
                                      child: const Text('CANCEL')),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();

                                        setState(() {
                                          facilities = '';
                                          for (var facility in facilitiesList) {
                                            if (facility.value) {
                                              facilities += facility.name + ',';
                                            }
                                          }
                                        });
                                      },
                                      child: const Text('OK')),
                                ],
                              );
                            });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('Facilities'),
                          Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black45,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(child: Text(facilities)),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                keyboardType: TextInputType.number,
                controller: _totalRoomsController,
                decoration: InputDecoration(
                    hintText: 'Enter Total Rooms',
                    labelText: 'Total Rooms',
                    prefixIcon: const Icon(Icons.roofing),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                        onTap: () {
                          _pickMultiplesImages();
                        },
                        child: const Text('Hostel Photo - Tap to Select')),
                    const SizedBox(
                      height: 10,
                    ),
                    imagePicked == false
                        ? const SizedBox.shrink()
                        : Expanded(
                            child: GridView.builder(
                                itemCount: imageFiles!.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 5,
                                ),
                                itemBuilder: (context, index) {
                                  return Image.file(
                                    imageFiles![index],
                                    fit: BoxFit.cover,
                                  );
                                }),
                          )
                    /*
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    leading: const Icon(
                                      Icons.photo,
                                    ),
                                    title: const Text('From Gallery'),
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      _pickImageFrom(
                                          source: ImageSource.gallery);
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(
                                      Icons.camera_alt,
                                    ),
                                    title: const Text('From Camera'),
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      _pickImageFrom(
                                          source: ImageSource.camera);
                                    },
                                  ),
                                ],
                              );
                            });
                      },
                      child: imagePicked
                          ? Image.file(
                              imageFile!,
                              width: double.infinity,
                              height: 110,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              widget.hostel.photos[0] as String,
                              width: double.infinity,
                              height: 110,
                              fit: BoxFit.cover,
                            ),
                    ) */
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () async {
                      if (validate()) {
                        if (await NetworkConnection.isNotConnected()) {
                          Fluttertoast.showToast(
                              msg:
                                  'You are Offline\nConnect to Internet and try again');
                          return;
                        }

                        ProgressDialog progressDialog = ProgressDialog(
                          context,
                          title: const Text('Updating'),
                          message: const Text('Please wait'),
                        );
                        progressDialog.show();

                        if (imagePicked && imageFiles != null) {
                          // upload image to storage
                          try {
                            // var fileName = DateTime.now().toIso8601String();
                            //
                            // UploadTask uploadTask = FirebaseStorage.instance
                            //     .ref()
                            //     .child('hostel_images')
                            //     .child(fileName)
                            //     .putFile(imageFile!);
                            //
                            // TaskSnapshot snapshot = await uploadTask;
                            // String hostelPhotoUrl =
                            //     await snapshot.ref.getDownloadURL();
                            // print(hostelPhotoUrl);


                            await Future.forEach(imageFiles!, (File image) async {

                              var fileName = 'hostel' + Random().nextInt(1000000).toString();

                              Reference ref = FirebaseStorage.instance
                                  .ref()
                                  .child('hostel_images')
                                  .child(fileName);
                              final UploadTask uploadTask = ref.putFile(image);
                              final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
                              final url = await taskSnapshot.ref.getDownloadURL();
                              photos.add(url);
                            });

                            print(photos);
                            // Update Hostel record in RTDB

                            DatabaseReference hostelReference = FirebaseDatabase
                                .instance
                                .ref()
                                .child('hostels')
                                .child(widget.hostel.hostelId);
                            //String? hostelId = hostelReference.push().key;

                            Hostel hostel = Hostel(
                              hostelId: widget.hostel.hostelId,
                              cityName: _cityController.text.trim(),
                              hostelName: _hostelNameController.text.trim(),
                              ownerName: _ownerNameController.text.trim(),
                              ownerId: widget.hostel.ownerId,
                              contactNum: _contactController.text.trim(),
                              availableSeats:
                                  _availableSeatsController.text.trim(),
                              seatRent: _rentController.text.trim(),
                              facilities: facilities,
                              totalRooms: _totalRoomsController.text.trim(),
                              photos: photos,
                              //hostelPhotoUrl,
                              latitude: widget.hostel.latitude,
                              longitude: widget.hostel.longitude,
                            );

                            await hostelReference.update(hostel.toMap());

                            Fluttertoast.showToast(
                                msg: 'Hostel Record Updated',
                                backgroundColor: Colors.green);
                            progressDialog.dismiss();
                            Navigator.of(context).pop();
                          } catch (e) {
                            progressDialog.dismiss();

                            print(e.toString());
                          }
                        } else {
                          // No need of uploading image, user haven't changed photo
                          try {
                            // Update Hostel record in RTDB

                            DatabaseReference hostelReference = FirebaseDatabase
                                .instance
                                .ref()
                                .child('hostels')
                                .child(widget.hostel.hostelId);
                            //String? hostelId = hostelReference.push().key;

                            Hostel hostel = Hostel(
                              hostelId: widget.hostel.hostelId,
                              cityName: _cityController.text.trim(),
                              hostelName: _hostelNameController.text.trim(),
                              ownerName: _ownerNameController.text.trim(),
                              ownerId: widget.hostel.ownerId,
                              contactNum: _contactController.text.trim(),
                              availableSeats:
                                  _availableSeatsController.text.trim(),
                              seatRent: _rentController.text.trim(),
                              facilities: facilities,
                              totalRooms: _totalRoomsController.text.trim(),
                              photos: <Object>[],
                              //widget.hostel.photo,
                              latitude: widget.hostel.latitude,
                              longitude: widget.hostel.longitude,
                            );

                            await hostelReference.update(hostel.toMap());

                            Fluttertoast.showToast(
                                msg: 'Hostel Record Updated',
                                backgroundColor: Colors.green);
                            progressDialog.dismiss();
                            Navigator.of(context).pop();
                          } catch (e) {
                            progressDialog.dismiss();
                          }
                        }
                      }
                    },
                    child: const Text('Update')),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool validate() {
    String cityName = _cityController.text.trim();
    String hostelName = _hostelNameController.text.trim();
    String ownerName = _ownerNameController.text.trim();
    String contactNum = _contactController.text.trim();
    String seatsAvailable = _availableSeatsController.text.trim();
    String rentPerSeat = _rentController.text.trim();
    String totalRooms = _totalRoomsController.text.trim();

    if (cityName.isEmpty) {
      Fluttertoast.showToast(
          msg: 'Please provide city name', backgroundColor: Colors.red);
      return false;
    }
    if (hostelName.isEmpty) {
      Fluttertoast.showToast(
          msg: 'Please provide city name', backgroundColor: Colors.red);
      return false;
    }

    if (ownerName.isEmpty) {
      Fluttertoast.showToast(
          msg: 'Please provide owner name', backgroundColor: Colors.red);
      return false;
    }

    if (contactNum.isEmpty) {
      Fluttertoast.showToast(
          msg: 'Please provide contact number', backgroundColor: Colors.red);
      return false;
    }

    if (seatsAvailable.isEmpty) {
      Fluttertoast.showToast(
          msg: 'Please provide available seats', backgroundColor: Colors.red);
      return false;
    }

    if (rentPerSeat.isEmpty) {
      Fluttertoast.showToast(
          msg: 'Please provide rent per seat', backgroundColor: Colors.red);
      return false;
    }

    if (totalRooms.isEmpty) {
      Fluttertoast.showToast(
          msg: 'Please provide total rooms', backgroundColor: Colors.red);
      return false;
    }

    RegExp regExp = RegExp(r'[0-9]');
    if (cityName.contains(regExp)) {
      Fluttertoast.showToast(
          msg: 'Invalid City Name', backgroundColor: Colors.red);
      return false;
    }

    if (ownerName.contains(regExp)) {
      Fluttertoast.showToast(
          msg: 'Invalid Owner Name', backgroundColor: Colors.red);
      return false;
    }

    if (contactNum.length < 11) {
      Fluttertoast.showToast(
          msg: 'Invalid contact no', backgroundColor: Colors.red);
      return false;
    }

    // if (imageFile == null) {
    //   Fluttertoast.showToast(
    //       msg: 'Please Select Hostel Photo', backgroundColor: Colors.red);
    //   return false;
    // }

    // if (latitude == 0.0 || longitude == 0.0) {
    //   Fluttertoast.showToast(
    //       msg: 'Hostel Location Not Available, Try Again Later',
    //       backgroundColor: Colors.red);
    //   return false;
    // }

    return true;
  }
}
