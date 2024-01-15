import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/controllers/abouts/about_edit_controller.dart';
import 'package:lakasir/widgets/image_picker.dart';
import 'package:lakasir/widgets/filled_button.dart';
import 'package:lakasir/widgets/layout.dart';
import 'package:lakasir/widgets/select_input_feld.dart';
import 'package:lakasir/widgets/text_field.dart';
import 'package:image_picker/image_picker.dart';

class EditAboutScreen extends StatefulWidget {
  const EditAboutScreen({super.key});

  @override
  State<EditAboutScreen> createState() => _EditAboutScreenState();
}

class _EditAboutScreenState extends State<EditAboutScreen> {
  final AboutEditController _aboutEditController =
      Get.put(AboutEditController());

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Layout(
      title: 'global_edit_item'.trParams({
        'item': 'menu_about'.tr,
      }),
      resizeToAvoidBottomInset: true,
      child: Form(
        key: _aboutEditController.formKey,
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(
                  () => SizedBox(
                    width: 100,
                    child: MyImagePicker(
                      usingDynamicSource: true,
                      onImageSelected: (file) {
                        _aboutEditController.about.value.photo = file;
                      },
                      defaultImage: _aboutEditController.about.value.photo
                              ?.replaceFirst("https", "http") ??
                          '',
                    ),
                  ),
                ),
                SizedBox(
                  width: width * 60 / 100,
                  child: MyTextField(
                    controller: _aboutEditController.nameInputController,
                    label: 'field_shop_name'.tr,
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: SelectInputWidget(
                options: [
                  Option(name: "Retail", value: "retail"),
                  Option(name: "Wholesale", value: "wholesale"),
                ],
                controller: _aboutEditController.businessTypeInputController,
                label: 'field_business_type'.tr,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: MyTextField(
                controller: _aboutEditController.ownerNameInputController,
                label: 'field_owner_name'.tr
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: MyTextField(
                maxLines: 4,
                controller: _aboutEditController.locationInputController,
                label: 'field_location'.tr,
                keyboardType: TextInputType.multiline,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: SelectInputWidget(
                options: [
                  Option(name: "IDR", value: "IDR"),
                ],
                controller: _aboutEditController.currencyInputController,
                label: 'field_currency'.tr,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Obx(
                () => MyFilledButton(
                  onPressed: _aboutEditController.updateAbout,
                  isLoading: _aboutEditController.isLoading.value,
                  child: Text('global_save'.tr),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
