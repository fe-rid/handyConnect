import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../theme.dart';
import '../../core/models/enums.dart';
import 'bloc/auth_cubit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _email = TextEditingController(text: 'demo@customer.com');
  final _password = TextEditingController(text: 'password');
  final _name = TextEditingController(text: 'Demo User');
  UserType _type = UserType.customer;
  bool _signup = false;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('HandyConnect',
                          style: Theme.of(context).textTheme.headlineLarge),
                      const SizedBox(height: AppSpacing.md),
                      Text('Find trusted handymen quickly 🔧',
                          style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: AppSpacing.lg),
                      if (_signup)
                        TextField(
                          controller: _name,
                          decoration:
                              const InputDecoration(labelText: 'Full name'),
                        ),
                      const SizedBox(height: AppSpacing.md),
                      TextField(
                        controller: _email,
                        decoration: const InputDecoration(labelText: 'Email'),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      TextField(
                        controller: _password,
                        obscureText: true,
                        decoration:
                            const InputDecoration(labelText: 'Password'),
                      ),
                      if (_signup) ...[
                        const SizedBox(height: AppSpacing.md),
                        DropdownButtonFormField<UserType>(
                          value: _type,
                          items: const [
                            DropdownMenuItem(
                                value: UserType.customer,
                                child: Text('Customer')),
                            DropdownMenuItem(
                                value: UserType.handyman,
                                child: Text('Handyman')),
                          ],
                          onChanged: (v) =>
                              setState(() => _type = v ?? UserType.customer),
                          decoration:
                              const InputDecoration(labelText: 'Account type'),
                        ),
                      ],
                      const SizedBox(height: AppSpacing.lg),
                      BlocConsumer<AuthCubit, AuthState>(
                        listener: (context, state) {
                          if (state.user != null) {
                            if (state.user!.userType == UserType.customer) {
                              context.go('/home');
                            } else {
                              context.go('/handyman/profile');
                            }
                          }
                        },
                        builder: (context, state) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (state.error != null)
                                Text(state.error!,
                                    style: TextStyle(color: color.error)),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.login,
                                    color: Colors.white),
                                label: Text(
                                    _signup ? 'Create account' : 'Login',
                                    style:
                                        const TextStyle(color: Colors.white)),
                                onPressed: state.loading
                                    ? null
                                    : () {
                                        final cubit = context.read<AuthCubit>();
                                        if (_signup) {
                                          cubit.signUp(_name.text, _email.text,
                                              _password.text, _type);
                                        } else {
                                          cubit.signIn(
                                              _email.text, _password.text);
                                        }
                                      },
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              OutlinedButton(
                                onPressed: state.loading
                                    ? null
                                    : () => setState(() => _signup = !_signup),
                                child: Text(_signup
                                    ? 'Have an account? Login'
                                    : 'Create new account'),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
