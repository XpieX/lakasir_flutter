import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:get/get.dart';
import 'package:lakasir/Exceptions/validation.dart';
import 'package:lakasir/api/requests/product_request.dart';
import 'package:lakasir/api/responses/error_response.dart';
import 'package:lakasir/api/responses/products/product_response.dart';
import 'package:lakasir/api/responses/products/produect_error_response.dart';
import 'package:lakasir/controllers/products/product_controller.dart';
import 'package:lakasir/controllers/products/product_detail_controller.dart';
import 'package:lakasir/services/product_service.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/utils/utils.dart';
import 'package:lakasir/widgets/select_input_feld.dart';

class ProductAddEditController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ProductService _productService = ProductService();
  final SelectInputWidgetController categoryController =
      SelectInputWidgetController();
  final SelectInputWidgetController typeController =
      SelectInputWidgetController();
  final TextEditingController nameInputController = TextEditingController();
  final TextEditingController stockInputController = TextEditingController();
  final MoneyMaskedTextController initialPriceInputController =
      MoneyMaskedTextController(thousandSeparator: '.', decimalSeparator: ',');
  final MoneyMaskedTextController sellingPriceInputController =
      MoneyMaskedTextController();
  final TextEditingController unitInputController = TextEditingController();
  String? photoUrl = '';
  Rx<ProductErrorResponse> productErrorResponse = ProductErrorResponse().obs;
  final RxBool isLoading = false.obs;
  final ProductController _productController = Get.find();
  final ProductDetailController _productDetailController =
      Get.put(ProductDetailController());
  // final CategoryController _categoryController = Get.find();

  void create() async {
    try {
      clearError();
      isLoading(true);
      if (!formKey.currentState!.validate()) {
        debugPrint('error');
        isLoading(false);
        return;
      }
      await _productService.create(ProductRequest(
        name: nameInputController.text,
        categoryId: categoryController.selectedOption,
        stock: stockInputController.text != ''
            ? double.parse(stockInputController.text)
            : 0,
        initialPrice: initialPriceInputController.numberValue,
        sellingPrice: sellingPriceInputController.numberValue,
        type: typeController.selectedOption,
        unit: unitInputController.text,
        photoUrl: photoUrl,
      ));
      isLoading(false);
      _productController.getProducts();
      clearInput();
      Get.back();
      Get.rawSnackbar(message: 'Product Created', backgroundColor: success);
    } catch (e) {
      isLoading(false);
      if (e is ValidationException) {
        ErrorResponse<ProductErrorResponse> errorResponse =
            ErrorResponse.fromJson(
          jsonDecode(
            e.toString(),
          ),
          (json) => ProductErrorResponse.fromJson(json),
        );
        productErrorResponse(errorResponse.errors);
      }
    }
  }

  void edit() async {
    try {
      clearError();
      isLoading(true);
      if (!formKey.currentState!.validate()) {
        isLoading(false);
        return;
      }
      await _productService.update(
        (Get.arguments as ProductResponse).id,
        ProductRequest(
          name: nameInputController.text,
          categoryId: categoryController.selectedOption,
          stock: stockInputController.text != ''
              ? double.parse(stockInputController.text)
              : 0,
          initialPrice: initialPriceInputController.text != ''
              ? double.parse(initialPriceInputController.text)
              : 0,
          sellingPrice: sellingPriceInputController.text != ''
              ? double.parse(sellingPriceInputController.text)
              : 0,
          type: typeController.selectedOption,
          unit: unitInputController.text,
          photoUrl: photoUrl ?? '',
        ),
      );
      isLoading(false);
      _productController.getProducts();
      await _productDetailController.get(Get.arguments.id);
      clearInput();
      Get.back();
      Get.offAndToNamed('/menu/product/detail',
          arguments: _productDetailController.product.value);
      Get.rawSnackbar(message: 'Product Updated', backgroundColor: success);
    } catch (e) {
      isLoading(false);
      if (e is ValidationException) {
        ErrorResponse<ProductErrorResponse> errorResponse =
            ErrorResponse.fromJson(
          jsonDecode(
            e.toString(),
          ),
          (json) => ProductErrorResponse.fromJson(json),
        );
        productErrorResponse(errorResponse.errors);
      }
    }
  }

  void clearInput() {
    nameInputController.clear();
    stockInputController.clear();
    initialPriceInputController.clear();
    sellingPriceInputController.clear();
    unitInputController.clear();
    photoUrl = '';
    categoryController.selectedOption = null;
  }

  void clearError() {
    productErrorResponse(ProductErrorResponse());
  }

  @override
  void onInit() {
    super.onInit();
    typeController.selectedOption = 'product';
  }

  void setData() {
    if (Get.arguments != null) {
      final products = Get.arguments as ProductResponse;
      nameInputController.text = products.name;
      categoryController.selectedOption = products.categoryId.toString();
      stockInputController.text = products.stock.toString();
      initialPriceInputController.updateValue(products.initialPrice ?? 0);
      sellingPriceInputController.updateValue(products.sellingPrice ?? 0);
      unitInputController.text = products.unit;
      photoUrl = products.image;
    }
  }
}
