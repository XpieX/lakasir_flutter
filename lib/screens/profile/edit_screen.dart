// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/controllers/profiles/profile_edit_controller.dart';
import 'package:lakasir/widgets/filled_button.dart';
import 'package:lakasir/widgets/image_picker.dart';
import 'package:lakasir/widgets/layout.dart';
import 'package:lakasir/widgets/select_input_feld.dart';
import 'package:lakasir/widgets/text_field.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  static const routeName = '/menu/profile/edit';

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  ProfileEditController _profileController = Get.put(ProfileEditController());

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Layout(
      title: 'Edit Profile',
      child: Form(
        key: _profileController.formKey,
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: width * 30 / 100,
                  child: MyImagePicker(
                    onImageSelected: (file) {
                      _profileController.profile.value.photoUrl = file;
                    },
                  ),
                ),
                SizedBox(
                  width: width * 50 / 100,
                  child: Obx(
                    () => MyTextField(
                      controller: _profileController.nameInputController,
                      label: 'Name',
                      errorText: _profileController.profileErrorResponse.value.name,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: MyTextField(
                controller: _profileController.emailInputController,
                label: 'Email',
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Obx(
                () => MyTextField(
                  controller: _profileController.phoneInputController,
                  label: 'Phone',
                  errorText: _profileController.profileErrorResponse.value.phone,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: MyTextField(
                maxLines: 4,
                controller: _profileController.addressInputController,
                label: 'Address',
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: SelectInputWidget(
                options: [
                  Option(name: "English", value: "en"),
                ],
                controller: _profileController.languageController,
                label: 'Language',
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: MyFilledButton(
                onPressed: _profileController.updateProfile,
                isLoading: _profileController.isLoading.value,
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
