import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ilia_users/core/di/injector.dart';
import 'package:ilia_users/features/users/view/create_user_view.dart';
import 'package:ilia_users/features/users/viewmodel/create_user_bloc.dart';
import 'package:ilia_users/features/users/viewmodel/user_bloc.dart';
import 'package:ilia_users/features/users/viewmodel/user_event.dart';
import 'package:ilia_users/features/users/viewmodel/user_state.dart';

class UsersView extends StatefulWidget {
  const UsersView({super.key});

  @override
  State<UsersView> createState() => _UsersViewState();
}

class _UsersViewState extends State<UsersView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<UserBloc>()..add(GetUsers()),
      child: _UsersViewContent(),
    );
  }
}

class _UsersViewContent extends StatelessWidget {
  const _UsersViewContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text('Usuários')),
      body: Container(
        color: Colors.white,
        child: BlocConsumer<UserBloc, UserState>(
          listener: (context, state) {
            if (state.errorMessage != null &&
                state.status != UserStatus.failed) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
            }
          },
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
              default:
                if (state.users.isEmpty) {
                  return const Center(child: Text('Nenhum usuário cadastrado'));
                }

                return ListView.builder(
                  itemCount: state.users.length,
                  itemBuilder: (_, index) {
                    final user = state.users[index];
                    return ListTile(
                      title: Text(user.name),
                      subtitle: Text(user.email),
                    );
                  },
                );
            }
          },
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16),
        child: TextButton(
          onPressed: () async {
            final wasCreated = await showModalBottomSheet<bool>(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => BlocProvider(
                create: (_) => getIt<CreateUserBloc>(),
                child: const CreateUserView(),
              ),
            );

            if (wasCreated == true && context.mounted) {
              context.read<UserBloc>().add(GetUsers());
            }
          },
          child: const Icon(Icons.person_add_outlined, size: 30),
        ),
      ),
    );
  }
}
