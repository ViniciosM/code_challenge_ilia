import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ilia_users/core/di/injector.dart';
import 'package:ilia_users/features/users/view/create_user_view.dart';
import 'package:ilia_users/features/users/viewmodel/user_bloc.dart';
import 'package:ilia_users/features/users/viewmodel/user_event.dart';
import 'package:ilia_users/features/users/viewmodel/user_state.dart';

class UsersView extends StatefulWidget {
  const UsersView({super.key});

  @override
  State<UsersView> createState() => _UsersViewState();
}

class _UsersViewState extends State<UsersView> {
  late final UserBloc _bloc;

  @override
  void initState() {
    _bloc = getIt<UserBloc>();
    super.initState();
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<UserBloc>()..add(GetUsers()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Users')),
        body: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            switch (state.status) {
              case UserStatus.loading:
                return const Center(child: CircularProgressIndicator());

              case UserStatus.failed:
                return Center(
                  child: Text(
                    state.errorMessage ?? 'Erro ao carregar usuários',
                  ),
                );

              case UserStatus.success:
                if (state.users.isEmpty) {
                  return const Center(child: Text('Nenhum usuário cadastrado'));
                }

                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.users.length,
                        itemBuilder: (context, index) {
                          final user = state.users[index];
                          return ListTile(
                            title: Text(user.name),
                            subtitle: Text(user.email),
                          );
                        },
                      ),
                    ),
                  ],
                );

              case UserStatus.initial:
                return const SizedBox();
            }
          },
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(16),
          child: TextButton(
            onPressed: () async {
              final result = await showModalBottomSheet(
                context: context,
                useSafeArea: true,
                showDragHandle: true,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const CreateUserView(),
              );

              if (result == true) {
                _bloc.add(GetUsers());
              }
            },
            child: const Text('Novo usuário'),
          ),
        ),
      ),
    );
  }
}
