class Doctor {
  final String imageLink;
  final String name;
  final String reviews;
  final String rating;
  final String specialty;
  final String uid;
  final List<dynamic> hoursOfDays;

  const Doctor({
   required this.imageLink,
    required this.name,
    required this.reviews,
    required this.rating,
    required this.specialty,
    required this.uid,
    required this.hoursOfDays,
  });


static Doctor fromJson(json) => Doctor(
  imageLink: json['imageLink'],
  name: json['name'],
  rating: json['rating'],
  reviews: json['reviews'],
  specialty: json['specialty'],
  uid: json['uid'],
  hoursOfDays: json['hoursOfDays'],
);


  Map<String, dynamic> toJSON() {
    return <String, dynamic>{
      'imageLink': imageLink,
      'name': name,
      'reviews': reviews,
      'rating': rating,
      'specialty': specialty,
      'uid': uid,
      'hoursOfDays': hoursOfDays.toList(growable: false),
    };
  }

}