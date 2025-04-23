
// class RegisterUserData {
//   final String name;
//   final String email_id;
//   final String address;
//   final String contact_number;
//   final String password;
//   final CityDatum cityData;

//   RegisterUserData(
//       {required this.name,
//       required this.email_id,
//       required this.address,
//       required this.contact_number,
//       required this.cityData,
//       required this.password});
// }

class UserData {
  final String name;
  final String school;
  final String medium;
  final String address;
  final String city;
  final String whatsapp;
  final String contact;
  final String role;
  final String subject;
  final String std;
  final String exam;
  final String? password;
  final String? profilePic;

  UserData({
    this.profilePic,
    required this.name,
    required this.school,
    required this.medium,
    required this.address,
    required this.city,
    required this.whatsapp,
    required this.contact,
    required this.role,
    required this.subject,
    required this.std,
    required this.exam,
    this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'Name': name,
      'School': school,
      'Medium': medium,
      'Address': address,
      'City': city,
      'Whatsapp': whatsapp,
      'Number': contact,
      'Role': role,
      'Subject': subject,
      'Std': std,
      'Exam': exam,
      'Password': password,
      'ProfilePic': profilePic
    };
  }

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      name: json['Name'] ?? '',
      school: json['School'] ?? '',
      medium: json['Medium'] ?? '',
      address: json['Address'] ?? '',
      city: json['City'] ?? '',
      whatsapp: json['Whatsapp'] ?? '',
      contact: json['Number'] ?? '',
      role: json['Role'] ?? '',
      subject: json['Subject'] ?? '',
      std: json['Std'] ?? '',
      exam: json['Exam'] ?? '',
      password: json['Password'] ?? '',
      profilePic: json['ProfilePic'] ?? '',
    );
  }
}
