import 'dart:async';
import 'dart:io';
import 'package:contact/contact_list.dart';
import 'package:contact/user.dart';
import 'package:contact/users_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class Home extends StatefulWidget {
  final User? user;
  const Home({ Key? key,
    this.user}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late int id;
  late String name;
  late String email;
  late String contactNo;
  late String address;

  @override
  void initState() {
    super.initState();

    id = widget.user?.id ?? 0;
    name = widget.user?.name ?? '';
    email = widget.user?.email ?? '';
    contactNo = widget.user?.contactNo ?? '';
    address = widget.user?.address ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final isFormValid = name.isNotEmpty || email.isNotEmpty || contactNo.isNotEmpty;
    // final imagePicker = ImagePicker();
    // File imageFile;
    return Scaffold(
      appBar: AppBar(
        title: Text(name.isNotEmpty ? name : 'User'),
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child:  Wrap(
          direction: Axis.horizontal,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 00),
              child: TextFormField(
                maxLines: 1,
                initialValue: name,
                cursorColor: const Color(0x00000000),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.account_circle_sharp),
                  hintText: 'Name',
                  hintStyle: TextStyle(
                      fontFamily: 'Arial',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.black45
                  ),
                ),
                validator: (name) =>
                name != null && name.isEmpty ? 'Name cannot be empty' : null,
                onChanged: (name) => setState(() => this.name = name),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 00),
              child: TextFormField(
                maxLines: 1,
                initialValue: email,
                cursorColor: const Color(0x00000000),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.mail),
                  hintText: 'Email',
                  hintStyle: TextStyle(
                      fontFamily: 'Arial',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.black45
                  ),
                ),
                validator: (email) =>
                email != null && email.isEmpty ? 'Email cannot be empty' : null,
                onChanged: (email) => setState(() => this.email = email),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 00),
              child: TextFormField(
                maxLines: 1,
                initialValue: contactNo,
                cursorColor: const Color(0x00000000),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.contact_phone),
                  hintText: 'Contact No',
                  hintStyle: TextStyle(
                      fontFamily: 'Arial',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.black45
                  ),
                ),
                validator: (contactNo) =>
                contactNo != null && contactNo.isEmpty ? 'Contact No cannot be empty' : null,
                onChanged: (contactNo) => setState(() => this.contactNo = contactNo),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 00),
              child: TextFormField(
                maxLines: 1,
                initialValue: address,
                cursorColor: const Color(0x00000000),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.contact_page),
                  hintText: 'Address',
                  hintStyle: TextStyle(
                      fontFamily: 'Arial',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.black45
                  ),
                ),
                validator: (address) =>
                address != null && address.isEmpty ? 'Address cannot be empty' : null,
                onChanged: (address) => setState(() => this.address = address),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 00),
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  onPrimary: Colors.white,
                  primary: isFormValid ? null : Colors.grey.shade700,
                ),
                onPressed: () async {
                  final isValid = _formKey.currentState!.validate();

                  if (isValid) {
                    final isUpdating = widget.user != null;

                    if (isUpdating) {
                      await updateUser();
                    } else {
                      await addUser();
                    }
                  }
                },
                child: widget.user != null
                    ? const Text('Update Contact')
                    : const Text('Add New Contact'),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future updateUser() async {
    final updateUser = widget.user!.copy(
      name: name,
      email: email,
      contactNo: contactNo,
      address: address,
    );
    final update = await UsersDatabase.instance.update(updateUser);

    if(update == 1) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Success!'),
              content: const Text('Contact has been updated successfully!'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const ContactList()),
                    );
                  },
                ),
              ],
            );
          }
      );
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Something went wrong!'),
              content: const Text('Please Try Again Later!'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Ok'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          }
       );
    }

  }

  Future addUser() async {
    final addUser = User(
      name: name,
      email: email,
      contactNo: contactNo,
      address: address,
    );
    await UsersDatabase.instance.create(addUser);

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Success!'),
            content: const Text('Contact has been added successfully!'),
            actions: <Widget>[
              TextButton(
                child: const Text('Ok'),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const ContactList()),
                  );
                },
              ),
            ],
          );
        }
    );
  }
}


