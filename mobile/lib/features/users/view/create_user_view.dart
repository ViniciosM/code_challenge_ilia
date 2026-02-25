import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/injector.dart';
import '../data/models/user_model.dart';
import '../viewmodel/user_bloc.dart';
import '../viewmodel/user_event.dart';
import '../viewmodel/user_state.dart';

class CreateUserView extends StatefulWidget {
  const CreateUserView({super.key});

  @override
  State<CreateUserView> createState() => _CreateUserViewState();
}

class _CreateUserViewState extends State<CreateUserView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  late final UserBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = getIt<UserBloc>();
  }

  @override
  void dispose() {
    _bloc.close();
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

      _bloc.add(AddUser(user));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: BlocListener<UserBloc, UserState>(
            listener: (context, state) {
              if (state.status == UserStatus.success) {
                Navigator.pop(context, true);
              }

              if (state.status == UserStatus.failed) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.errorMessage ?? 'Erro ao salvar usuário',
                    ),
                  ),
                );
              }
            },
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
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
            validator: (value) =>
                value == null || value.isEmpty ? 'Nome é obrigatório' : null,
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
          const SizedBox(height: 24),
          BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if (state.status == UserStatus.loading) {
                return const CircularProgressIndicator();
              }

              return ElevatedButton(
                onPressed: _submit,
                child: const Text('Salvar'),
              );
            },
          ),
        ],
      ),
    );
  }
}
