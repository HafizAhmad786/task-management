
class UserModel {
  final String? displayName;
  final String? email;
  final String? address;
  final String? phoneNumber;
  final String? photoURL;
  final String? uid;
  final String? dob;
  final String? pickAddress;
  final String? deliveryAddress;

  UserModel({
    this.email,
    this.uid,
    this.displayName,
    this.phoneNumber,
    this.address,
    this.photoURL,
    this.deliveryAddress,
    this.pickAddress,
    this.dob
  });

  factory UserModel.fromJson(Map<String,dynamic> json) {
    return UserModel(
        displayName: json['displayName'],
        email: json['email'],
        phoneNumber: json['phoneNumber'],
        photoURL: json['photoURL'],
        uid: json['userId'],
        address: json['address'],
        pickAddress: json['pickAddress'],
        deliveryAddress: json['deliveryAddress'],
        dob: json['dob']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'displayName': displayName,
      'email': email,
      'phoneNumber': phoneNumber,
      'photoURL': photoURL,
      'userId': uid,
      'address': address,
      "pickAddress":pickAddress,
      "deliveryAddress":deliveryAddress,
      "dob": dob
    };
  }

  static final UserModel empty = UserModel();

  bool get isEmpty => this == UserModel.empty;
}

