import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'users_database.dart';
import 'user.dart';
import 'home.dart';

class UserInfoPage extends StatefulWidget {
  final int userId;

  const UserInfoPage({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  late User user;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshUser();
  }

  Future refreshUser() async {
    setState(() => isLoading = true);

    this.user = await UsersDatabase.instance.readUser(widget.userId);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(

    appBar: AppBar(
      actions: [editButton(), deleteButton()],
      backgroundColor: Colors.blue,
    ),
    backgroundColor: Colors.white,
    body: isLoading
        ? const Center(child: CircularProgressIndicator())
        : Padding(
      padding: const EdgeInsets.all(12),
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          Text(
            user.name,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            user.email,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            user.contactNo,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            user.address,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    ),
  );

  Widget editButton() => IconButton(
      icon: Icon(Icons.edit_outlined),
      onPressed: () async {
        if (isLoading) return;

        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Home(user: user),
        ));

        refreshUser();
      });

  Widget deleteButton() => IconButton(
    icon: Icon(Icons.delete),
    onPressed: () async {
      await UsersDatabase.instance.delete(widget.userId);

      Navigator.of(context).pop();
    },
  );
}