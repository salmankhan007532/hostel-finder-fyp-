import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:hostel_finder_noor_rehman/models/hostel.dart';
import 'package:hostel_finder_noor_rehman/screens/hostel_rating_screen.dart';
import 'package:hostel_finder_noor_rehman/screens/single_hostel_location_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class HostelDetailsScreen extends StatefulWidget {
  final Hostel hostel;

  const HostelDetailsScreen({Key? key, required this.hostel}) : super(key: key);

  @override
  State<HostelDetailsScreen> createState() => _HostelDetailsScreenState();
}

class _HostelDetailsScreenState extends State<HostelDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hostel Details'),
      ),
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ImageSlideshow(
            width: double.infinity,
            height: 300,
            initialPage: 0,
            indicatorColor: Colors.white,
            indicatorBackgroundColor: Colors.grey,
            autoPlayInterval: 5000,
            isLoop: true,
            children: widget.hostel.photos
                .map(
                  (e) => GestureDetector(
                    onTap: () {
                      print(e);
                    },
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: e as String,
                      placeholder: (context, url) => const SizedBox.shrink(),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                  ),
                )
                .toList(),
          ),
          // ClipRRect(
          //     borderRadius: const BorderRadius.only(
          //         topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          //     child: Image.network(
          //       widget.hostel.photos[0] as String,
          //       width: double.infinity,
          //       height: 250,
          //       fit: BoxFit.cover,
          //     )),
          const SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
            child: Text(
              widget.hostel.hostelName,
              style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(children: [
                const Icon(
                  Icons.location_city,
                  color: Colors.grey,
                ),
                const Text(' City: '),
                Text(widget.hostel.cityName,
                    style: const TextStyle(fontWeight: FontWeight.bold))
              ])),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(children: [
                const Icon(
                  Icons.roofing,
                  color: Colors.grey,
                ),
                const Text(' Hostel Name: '),
                Text(widget.hostel.hostelName,
                    style: const TextStyle(fontWeight: FontWeight.bold))
              ])),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(children: [
                const Icon(
                  Icons.person,
                  color: Colors.grey,
                ),
                const Text(' Owner: '),
                Text(widget.hostel.ownerName,
                    style: const TextStyle(fontWeight: FontWeight.bold))
              ])),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(children: [
                const Icon(
                  Icons.phone,
                  color: Colors.grey,
                ),
                const Text(' Contact: '),
                Text(widget.hostel.contactNum,
                    style: const TextStyle(fontWeight: FontWeight.bold))
              ])),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(children: [
                const Icon(
                  Icons.bed,
                  color: Colors.grey,
                ),
                const Text(' Seats Available: '),
                Text(widget.hostel.availableSeats,
                    style: const TextStyle(fontWeight: FontWeight.bold))
              ])),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(children: [
                const Icon(
                  Icons.done_all,
                  color: Colors.grey,
                ),
                const Text(' Seat Rent: '),
                Text(widget.hostel.seatRent,
                    style: const TextStyle(fontWeight: FontWeight.bold))
              ])),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(children: [
                const Icon(
                  Icons.map,
                  color: Colors.grey,
                ),
                const Text(' Facilities: '),
                Expanded(
                  child: Text(widget.hostel.facilities,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ])),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(children: [
                const Icon(
                  Icons.house,
                  color: Colors.grey,
                ),
                const Text(' Total Rooms: '),
                Text(widget.hostel.totalRooms,
                    style: const TextStyle(fontWeight: FontWeight.bold))
              ])),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    await launch('tel:${widget.hostel.contactNum}');
                  },
                  label: const Text('Call'),
                  icon: const Icon(Icons.call),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                    child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return SingleHostelLocationScreen(hostel: widget.hostel);
                    }));
                  },
                  label: const Text('Location'),
                  icon: const Icon(Icons.location_on),
                )),
                const SizedBox(
                  width: 5,
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return HostelRatingScreen(hostel: widget.hostel);
                    }));
                  },
                  label: const Text('Ratings'),
                  icon: const Icon(Icons.star_rate),
                ),
              ],
            ),
          )
        ],
      )),
    );
  }
}
