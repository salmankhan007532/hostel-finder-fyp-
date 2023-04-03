class Hostel {
  late String hostelId;
  late String cityName;
  late String hostelName;
  late String ownerName;
  late String ownerId;
  late String contactNum;
  late String availableSeats;
  late String seatRent;
  late String facilities;
  late String totalRooms;
  late List<Object?> photos;
  late double latitude;
  late double longitude;

  Hostel({
    required this.hostelId,
    required this.cityName,
    required this.hostelName,
    required this.ownerName,
    required this.ownerId,
    required this.contactNum,
    required this.availableSeats,
    required this.seatRent,
    required this.facilities,
    required this.totalRooms,
    required this.photos,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'hostelId': hostelId,
      'cityName': cityName,
      'hostelName': hostelName,
      'ownerName': ownerName,
      'ownerId': ownerId,
      'contactNum': contactNum,
      'availableSeats': availableSeats,
      'seatRent': seatRent,
      'facilities': facilities,
      'totalRooms': totalRooms,
      'photos': photos,
      'latitude': latitude,
      'longitude': longitude,
    };

    return map;
  }

  factory Hostel.fromMap(Map<String, dynamic> map) {
    return Hostel(
      hostelId: map['hostelId'],
      cityName: map['cityName'],
      hostelName: map['hostelName'],
      ownerName: map['ownerName'],
      ownerId: map['ownerId'],
      contactNum: map['contactNum'],
      availableSeats: map['availableSeats'],
      seatRent: map['seatRent'],
      facilities: map['facilities'],
      totalRooms: map['totalRooms'],
      photos: map['photos'],
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }
}
