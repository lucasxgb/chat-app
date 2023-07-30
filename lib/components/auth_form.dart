import 'dart:io';
import 'package:chat/components/user_image_picker.dart';
import 'package:chat/core/models/auth_form_data.dart';
import 'package:flutter/material.dart';

/* Classe responsável por autenticar o formulário */
class AuthForm extends StatefulWidget {
  final void Function(AuthFormData) onSubmit;
  const AuthForm({super.key, required this.onSubmit});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  /* FormKey pois é preciso acessar o formulário através de um a global key, 
  que é uma chave de identificação única para um formulário */
  final _formKey = GlobalKey<FormState>();
  final _formData = AuthFormData();

  void _handleImagePick(File image) {
    _formData.image = image;
  }

  /* Método para exbição da snackBar, barrinha que aparece embaixo */
  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  void _submit() {
    /* Conseguimos saber se o formulário está válido ou não */
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    // if (_formData.image == null && _formData.isSignup) {
    //   return (_showError('Imagem não selecionada!'));
    // }

    widget.onSubmit(_formData);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(
        _formData.isLogin ? 'Login' : 'Cadastro',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      Card(
        margin: const EdgeInsets.all(20),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (_formData.isSignup)
                  UserImagePicker(
                    onImagePick: _handleImagePick,
                  ),
                if (_formData.isSignup)
                  TextFormField(
                    key: const ValueKey('name'),
                    /* Qualquer mudança que ocorra no input ele salva o valor dentro do formData */
                    initialValue: _formData.name,
                    decoration: const InputDecoration(labelText: 'Nome'),
                    onChanged: (name) => _formData.name = name,
                    validator: (_name) {
                      final name = _name ?? '';
                      if (name.trim().length < 5) {
                        return 'O nome conter no mínimo 5 caractéres';
                      }
                      return null;
                    },
                  ),
                TextFormField(
                  key: const ValueKey('email'),
                  initialValue: _formData.email,
                  decoration: const InputDecoration(labelText: 'E-mail'),
                  onChanged: (email) => _formData.email = email,
                  validator: (_email) {
                    final email = _email ?? '';
                    if (!email.contains('@')) {
                      return 'E-mail informado não é válido';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  key: const ValueKey('password'),
                  obscureText: true,
                  initialValue: _formData.password,
                  decoration: const InputDecoration(labelText: 'Senha'),
                  onChanged: (password) => _formData.password = password,
                  validator: (_password) {
                    final password = _password ?? '';
                    if (password.trim().length < 6) {
                      return 'A senha deve conter 6 caractéres';
                    } else if (password.contains(' ') ||
                        password.trim().isEmpty) {
                      return 'A senha não deve conter espaços';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _submit,
                  child: Text(_formData.isLogin ? 'Entrar' : 'Cadastrar'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _formData.toggleAuthMode();
                    });
                  },
                  child: Text(_formData.isLogin
                      ? 'Criar uma nova conta?'
                      : 'Já possui uma conta?'),
                )
              ],
            ),
          ),
        ),
      ),
    ]);
  }
}
