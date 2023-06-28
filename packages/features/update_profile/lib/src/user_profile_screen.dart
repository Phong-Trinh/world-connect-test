import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';
import 'package:image_picker/image_picker.dart';

import 'user_profile_cubit.dart';
import 'user_profile_state.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  static const String routeName = 'UserProfileScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update User Profile'),
      ),
      body: BlocProvider(
        create: (context) => UserProfileCubit(
            userRepository: RepositoryProvider.of<UserRepository>(context)),
        child: const UserProfileForm(),
      ),
    );
  }
}

class UserProfileForm extends StatefulWidget {
  const UserProfileForm({super.key});

  @override
  State<UserProfileForm> createState() => _UserProfileFormState();
}

class _UserProfileFormState extends State<UserProfileForm> {
  late UserProfileCubit cubit;
  final _picker = ImagePicker();

  void _pickImageFromGallery(UserProfileCubit cubit) async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      cubit.updatePhotoURL(File(pickedImage.path));
    }
  }

  @override
  void initState() {
    super.initState();
    cubit = context.read<UserProfileCubit>();
    cubit.getUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          cubit.emailController.text != ""
              ? TextField(
                  controller: cubit.emailController,
                  enabled: false,
                  decoration: const InputDecoration(
                    labelText: 'Display Email',
                  ),
                )
              : const SizedBox(height: 16.0),
          TextField(
            controller: cubit.displayNameController,
            decoration: const InputDecoration(
              labelText: 'Display Name',
            ),
          ),
          const SizedBox(height: 16.0),
          cubit.passwordController != null
              ? TextField(
                  controller: cubit.passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                  obscureText: true,
                )
              : Container(),
          const SizedBox(height: 16.0),
          Row(
            children: [
              ValueListenableBuilder(
                  valueListenable: cubit.photoURLController,
                  builder: (context, photoURL, _) {
                    return Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: cubit.photoURLController.text.isNotEmpty
                              ? NetworkImage(cubit.photoURLController.text)
                              : const NetworkImage(
                                  'https://st3.depositphotos.com/6672868/13701/v/450/depositphotos_137014128-stock-illustration-user-profile-icon.jpg'),
                        ),
                      ),
                    );
                  }),
              const Spacer(),
              InkWell(
                onTap: () => _pickImageFromGallery(cubit),
                child: Container(
                  height: 40,
                  width: 120,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 145, 145, 145),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Text(
                      'Upload Image',
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              cubit.updateUserProfile();
            },
            child: const Text('Update'),
          ),
          const SizedBox(height: 16.0),
          BlocBuilder<UserProfileCubit, UserProfileState>(
            builder: (context, state) {
              if (state is UserProfileLoading) {
                return const CircularProgressIndicator();
              } else if (state is UserProfileUpdated) {
                return const Text('User profile updated!');
              } else if (state is UserProfileError) {
                return Text(
                    'Error updating user profile: ${state.errorMessage}');
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }
}
