enum Location { home, work, others }

class UserAddressModel {
  String id;
  String zipCode;
  String country;
  String state;
  String district;
  String city;
  String street;
  String platNo;
  String? landmark;
  Location location;
  String contactNo;

  UserAddressModel({
    required this.id,
    required this.zipCode,
    required this.country,
    required this.state,
    required this.district,
    required this.city,
    required this.street,
    this.landmark,
    required this.platNo,
    required this.location,
    required this.contactNo,
  });

  // Convert UserAddressModel to map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'zipCode': zipCode,
      'country': country,
      'state': state,
      'district': district,
      'city': city,
      'street': street,
      'landmark': landmark,
      'platNo': platNo,
      'location': location.name, // Convert enum to string
      'contactNo': contactNo
    };
  }

  // Convert Firestore map to UserAddressModel
  factory UserAddressModel.fromMap(Map<String, dynamic> map) {
    return UserAddressModel(
        id: map['id'] ?? '',
        zipCode: map['zipCode'] ?? '',
        country: map['country'] ?? '',
        state: map['state'] ?? '',
        district: map['district'] ?? '',
        city: map['city'] ?? '',
        street: map['street'] ?? '',
        landmark: map['landmark'],
        platNo: map['platNo'] ?? '',
        location: Location.values.firstWhere(
            (e) => e.name == map['location'], // Convert string to enum
            orElse: () => Location.others),
        contactNo: map['contactNo'] ?? "");
  }
}
