import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/api/responses/products/product_response.dart';
import 'package:lakasir/controllers/products/product_detail_controller.dart';
import 'package:lakasir/controllers/setting_controller.dart';
import 'package:lakasir/screens/products/product_detail_widget.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/utils/utils.dart';
import 'package:lakasir/widgets/dialog.dart';
import 'package:lakasir/widgets/layout.dart';
import 'package:lakasir/widgets/my_bottom_bar.dart';
import 'package:lakasir/widgets/my_bottom_bar_actions.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreen();
}

class _DetailScreen extends State<DetailScreen> {
  bool isBottomSheetOpen = false;
  final _productDetailController = Get.put(ProductDetailController());
  final _settingController = Get.put(SettingController());

  final Duration initialDuration = const Duration(milliseconds: 300);

  void openBottomSheet() {
    setState(() {
      isBottomSheetOpen = true;
    });
  }

  @override
  void initState() {
    final product = Get.arguments as ProductResponse;
    _productDetailController.get(product.id);
    Timer(initialDuration, openBottomSheet);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Timer(initialDuration, openBottomSheet);
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Obx(
      () {
        final products = _productDetailController.product.value;
        return Layout(
          baseHeight: double.infinity,
          noAppBar: true,
          noPadding: true,
          bottomNavigationBar: MyBottomBar(
            label: Text('product_edit'.tr),
            onPressed: () {
              Get.toNamed('/menu/product/edit', arguments: products);
            },
            actions: [
              if (!products.isNonStock)
                MyBottomBarActions(
                  label: 'field_stock'.tr,
                  onPressed: () {
                    setState(() {
                      isBottomSheetOpen = false;
                    });
                    Timer(initialDuration, () {
                      Get.toNamed(
                        '/menu/product/stock',
                        arguments: products,
                      )!
                          .then((value) {
                        Timer(initialDuration, () {
                          setState(() {
                            isBottomSheetOpen = true;
                          });
                        });
                      });
                    });
                  },
                  icon: const Icon(Icons.inventory, color: Colors.white),
                ),
              MyBottomBarActions(
                label: 'global_delete'.tr,
                onPressed: () {
                  _productDetailController.showDeleteDialog(
                    products.id,
                  );
                },
                icon: const Icon(Icons.delete_rounded, color: Colors.white),
              ),
            ],
          ),
          child: Column(
            children: [
              Hero(
                tag: 'product-${products.id}',
                child: ClipRRect(
                  child: Image.network(
                    products.image ?? '',
                    fit: BoxFit.cover,
                    height: 300,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return const Image(
                        image: AssetImage('assets/no-image-100.png'),
                        fit: BoxFit.cover,
                        height: 300,
                        width: double.infinity,
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: ProductDetailWidget(
                  isLoading: _productDetailController.isLoading.value,
                  width: width,
                  products: products,
                  settingController: _settingController,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
