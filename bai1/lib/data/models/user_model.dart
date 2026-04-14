
class UserModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String website;
  final AddressModel address;
  final CompanyModel company;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.website,
    required this.address,
    required this.company,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id:      json['id'],
      name:    json['name'],
      email:   json['email'],
      phone:   json['phone'],
      website: json['website'],
      address: AddressModel.fromJson(json['address']),
      company: CompanyModel.fromJson(json['company']),
    );
  }

  String get initials => name.isNotEmpty ? name[0].toUpperCase() : '?';
}

class AddressModel {
  final String street;
  final String city;
  final String zipcode;

  AddressModel({required this.street, required this.city, required this.zipcode});

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
    street:  json['street'],
    city:    json['city'],
    zipcode: json['zipcode'],
  );

  String get fullAddress => '$street, $city $zipcode';
}

class CompanyModel {
  final String name;

  CompanyModel({required this.name});

  factory CompanyModel.fromJson(Map<String, dynamic> json) =>
      CompanyModel(name: json['name']);
}