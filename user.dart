
const String tableUsers = 'contacts';

class UserFields {
  static final List<String> values = [
    id, name, email, contactNo, address];

  static final String id ='id';
  static final String name ='name';
  static final String email ='email';
  static final String contactNo ='contactNo';
  static final String address ='address';
}

class User {
  final int? id;
  final String name;
  final String email;
  final String contactNo;
  final String address;

  const User({
    this.id,
    required this.name,
    required this.email,
    required this.contactNo,
    required this.address
  });

  User copy({
    int? id,
    String? name,
    String? email,
    String? contactNo,
    String? address,
  }) =>
      User(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        contactNo: contactNo ?? this.contactNo,
        address: address ?? this.address
      );

  static User fromJson(Map<String, Object?> json) => User(
    id: json[UserFields.id] as int?,
    name: json[UserFields.name] as String,
    email: json[UserFields.email] as String,
    contactNo: json[UserFields.contactNo] as String,
    address: json[UserFields.address] as String,
  );

  Map<String, Object?> toJson() => {
    UserFields.id: id,
    UserFields.name: name,
    UserFields.email: email,
    UserFields.contactNo: contactNo,
    UserFields.address: address,
  };
}