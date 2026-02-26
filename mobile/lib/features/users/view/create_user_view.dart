import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ilia_users/core/design_system/widgets/ui_button.dart';
import 'package:ilia_users/features/users/viewmodel/create_user_bloc.dart';
import 'package:ilia_users/features/users/viewmodel/create_user_event.dart';
import 'package:ilia_users/features/users/viewmodel/create_user_state.dart';
import '../data/models/user_model.dart';

class CreateUserView extends StatefulWidget {
  const CreateUserView({super.key});

  @override
  State<CreateUserView> createState() => _CreateUserViewState();
}

class _CreateUserViewState extends State<CreateUserView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final user = UserModel(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
      );
      context.read<CreateUserBloc>().add(SubmitUser(user));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: BlocListener<CreateUserBloc, CreateUserState>(
          listener: (context, state) {
            if (state.status == CreateUserStatus.success) {
              Navigator.pop(context, true);
            }
          },
          child: _buildForm(),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return BlocBuilder<CreateUserBloc, CreateUserState>(
      builder: (context, state) {
        final submitting = state.status == CreateUserStatus.loading;

        return Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Novo Usuário',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Nome é obrigatório'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email é obrigatório';
                  }
                  if (!value.contains('@')) {
                    return 'Email inválido';
                  }
                  return null;
                },
              ),

              if (state.status == CreateUserStatus.failed)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    state.errorMessage ?? 'Não foi possível salvar',
                    style: const TextStyle(color: Colors.red, fontSize: 13),
                  ),
                ),

              const SizedBox(height: 24),

              UIButton(
                label: 'Salvar Usuário',
                onPressed: _submit,
                isLoading: submitting,
              ),
            ],
          ),
        );
      },
    );
  }
}
