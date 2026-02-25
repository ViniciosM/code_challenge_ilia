import 'package:flutter/material.dart';

class UsersView extends StatefulWidget {
  const UsersView({super.key});

  @override
  State<UsersView> createState() => _UsersViewState();
}

class _UsersViewState extends State<UsersView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('User $index'),
                  subtitle: Text('$index@email.com'),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsetsGeometry.all(8.0),
            child: TextButton(onPressed: () {}, child: Text('Novo usuário')),
          ),
        ],
      ),
    );
  }
}
