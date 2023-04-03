import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hostel_finder_noor_rehman/models/hostel.dart';

class SingleHostelLocationScreen extends StatefulWidget {
  final Hostel hostel;

  const SingleHostelLocationScreen({Key? key, required this.hostel})
      : super(key: key);

  @override
  State<SingleHostelLocationScreen> createState() =>
      _SingleHostelLocationScreenState();
}

class _SingleHostelLocationScreenState
    extends State<SingleHostelLocationScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  LatLng hostelLatLng = const LatLng(34.0151, 71.5249);

  static CameraPosition hostelCameraPosition = const CameraPosition(
    target: LatLng(34.0151, 71.5249),
    zoom: 14.4746,
  );


  @override
  void initState() {
    super.initState();
    hostelLatLng = LatLng(widget.hostel.latitude, widget.hostel.longitude);
    hostelCameraPosition = CameraPosition(target: hostelLatLng, zoom: 14.4746);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.hostel.hostelName),
      ),
      body: GoogleMap(
        initialCameraPosition: hostelCameraPosition,
        markers: {
          Marker(
              markerId: MarkerId(widget.hostel.hostelId),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
              position: hostelLatLng,
              infoWindow: InfoWindow(
                  title: widget.hostel.hostelName,
                  snippet: widget.hostel.cityName)),
        },
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }


}
