import 'package:contact/contact_card_widget.dart';
import 'package:contact/home.dart';
import 'package:contact/user_info_page.dart';
import 'package:flutter/material.dart';
import 'user.dart';
import 'users_database.dart';

class ContactList extends StatefulWidget {
  const ContactList({super.key});

  @override
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  late List<User> users;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshUsers();
  }

  @override
  void dispose() {
    UsersDatabase.instance.close();

    super.dispose();
  }

  Future refreshUsers() async {
    setState(() => isLoading = true);

    users = await UsersDatabase.instance.readAllUsers();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Users',
          style: TextStyle(fontSize: 24),
        ),
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : users.isEmpty
            ? const Text(
          'No Contacts',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ) : Container(
          child: Flexible(
            child: ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];

                return GestureDetector(
                  onTap: () async {
                    await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => UserInfoPage(userId: user.id!),
                    ));
                    refreshUsers();
                  },
                  child: ContactCardWidget(user: user, index: index),
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => Home()),
          );

          refreshUsers();
        },
      ),
    );
  }

  Widget buildUsers() {
    return Container(
      child: Flexible(
        child: ListView.builder(
          padding: EdgeInsets.all(8),
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];

            return GestureDetector(
              onTap: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => UserInfoPage(userId: user.id!),
                ));

                refreshUsers();
              },
              child: ContactCardWidget(user: user, index: index),
            );
          },
        ),
      ),
    );
  }

}

