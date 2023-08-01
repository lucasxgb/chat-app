/*  Componente que possuirá a lógica para obtenção de um arquivo de imagem */
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File image) onImagePick;
  const UserImagePicker({super.key, required this.onImagePick});

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: Platform.isIOS ? ImageSource.gallery : ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 150,
    );

    /* se a imagem for diferente de nullo, armazenar o componente recebido no pick
    para nossa imagem*/
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });

      /* Notifica ao componente interessado que a imagem está selecionada */
      widget.onImagePick(_image!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Color(0xFF1C1C1C),
          backgroundImage: _image != null ? FileImage(_image!) : null,
        ),
        TextButton(
          onPressed: _pickImage,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.image,
              ),
              SizedBox(
                width: 10,
              ),
              Text('Adicionar Imagem'),
            ],
          ),
        ),
      ],
    );
  }
}
