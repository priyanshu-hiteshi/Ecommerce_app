class User {
  final int id;
  final String email;
  final String username;
  final String password;
  final String firstname;
  final String lastname;
  final String city;
  final String street;
  final int streetNumber;
  final String zipcode;
  final String lat;
  final String long;
  final String phone;

  User({
    required this.id,
    required this.email,
    required this.username,
    required this.password,
    required this.firstname,
    required this.lastname,
    required this.city,
    required this.street,
    required this.streetNumber,
    required this.zipcode,
    required this.lat,
    required this.long,
    required this.phone,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      password: json['password'],
      firstname: json['name']['firstname'],
      lastname: json['name']['lastname'],
      city: json['address']['city'],
      street: json['address']['street'],
      streetNumber: json['address']['number'],
      zipcode: json['address']['zipcode'],
      lat: json['address']['geolocation']['lat'],
      long: json['address']['geolocation']['long'],
      phone: json['phone'],
    );
  }
}
