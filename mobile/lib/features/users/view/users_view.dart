import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ilia_users/core/design_system/theme/app_colors.dart';
import 'package:ilia_users/core/design_system/widgets/ui_text.dart';
import 'package:ilia_users/core/design_system/widgets/ui_user_card.dart';
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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const UIText.header('Usuários'),
        centerTitle: false,
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
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
                  return _buildEmptyState();
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(top: 8, bottom: 80),
                  itemCount: state.users.length,
                  itemBuilder: (_, index) {
                    final user = state.users[index];
                    return UserCard(name: user.name, email: user.email);
                  },
                );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        onPressed: () => _openCreateUserModal(context),
        label: const Text(
          'Novo Usuário',
          style: TextStyle(color: Colors.white),
        ),
        icon: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.group_outlined,
            size: 64,
            color: AppColors.secondary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          const UIText.body(
            'Nenhum usuário por aqui...',
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }

  Future<void> _openCreateUserModal(BuildContext context) async {
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

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Usuário cadastrado!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
