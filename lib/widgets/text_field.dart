import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/utils/colors.dart';

typedef MyCallback = void Function(String);
typedef ValidatorCallback = String? Function(String?);

class MyTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? label;
  final String? info;
  final String? hintText;
  final bool mandatory;
  final String? errorText;
  final String? prefixText;
  final String? suffixText;
  final bool obscureText;
  final int? maxLines;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final TextCapitalization? textCapitalization;
  final Widget? rightIcon;
  final Function(String)? onSubmitted;
  final Function()? onEditingComplete;
  final Function(String)? onChanged;
  final Function(PointerDownEvent)? onTapOutside;
  final ValidatorCallback? validator;
  final bool autofocus;
  final bool readOnly;
  final Function()? onTap;
  final String? initialValue;

  final int debounce;

  const MyTextField({
    super.key,
    this.label,
    this.info,
    this.mandatory = false,
    this.controller,
    this.hintText,
    this.obscureText = false,
    this.prefixText,
    this.suffixText,
    this.errorText = "",
    this.maxLines = 1,
    this.textInputAction = TextInputAction.next,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.rightIcon,
    this.onSubmitted,
    this.onChanged,
    this.onTapOutside,
    this.onEditingComplete,
    this.autofocus = false,
    this.validator,
    this.readOnly = false,
    this.onTap,
    this.initialValue,
    this.debounce = 0,
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool showPassword = false;
  bool securedText = false;
  final FocusNode _focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    securedText = widget.obscureText;
    if (widget.autofocus) {
      _focusNode.requestFocus();
    }
  }

  Timer? _debounce;

  _onDebounceUpdate(String? value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(Duration(milliseconds: widget.debounce), () {
      if (widget.onChanged != null) {
        widget.onChanged!(value!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null || widget.info != null)
          Container(
            margin: const EdgeInsets.only(bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.label != null)
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: secondary,
                      ),
                      children: [
                        TextSpan(text: widget.label),
                        if (widget.mandatory)
                          const TextSpan(
                            text: "*",
                            style: TextStyle(color: error),
                          ),
                      ],
                    ),
                  ),
                const SizedBox(width: 20),
                if (widget.info != null)
                  Flexible(
                    child: Text(widget.info!,
                        style: const TextStyle(fontSize: 12)),
                  ),
              ],
            ),
          ),
        TextFormField(
          focusNode: _focusNode,
          onTap: widget.onTap,
          readOnly: widget.readOnly,
          initialValue: widget.initialValue,
          textInputAction: widget.textInputAction,
          keyboardType: widget.keyboardType,
          // inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))]
          textCapitalization: widget.textCapitalization!,
          onEditingComplete: widget.onEditingComplete,
          onTapOutside: (value) {
            widget.onTapOutside != null ? widget.onTapOutside!(value) : null;
            _focusNode.unfocus();
          },
          maxLines: widget.maxLines,
          controller: widget.controller,
          obscureText: securedText,
          validator: (value) {
            if (widget.validator != null) {
              return widget.validator!(value);
            }
            if (widget.mandatory && value!.isEmpty) {
              return "validation_required".trParams(
                {"field": widget.label!},
              );
            }
            return null;
          },
          onFieldSubmitted: widget.onSubmitted,
          onChanged:
              widget.debounce == 0 ? widget.onChanged : _onDebounceUpdate,
          // onSubmitted: widget.onSubmitted,
          decoration: InputDecoration(
            prefixText: widget.prefixText,
            suffixText: widget.suffixText,
            prefixStyle: const TextStyle(color: secondary),
            suffixIcon: widget.obscureText
                ? InkWell(
                    onTap: () {
                      setState(() {
                        showPassword = !showPassword;
                        securedText = !securedText;
                      });
                    },
                    child: Icon(
                      showPassword
                          ? Icons.remove_red_eye
                          : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                  )
                : widget.rightIcon,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 12.0,
            ), // Adjust the padding as needed
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: secondary),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12), // Border radius
              borderSide: const BorderSide(color: primary),
            ),
            fillColor: widget.readOnly ? Colors.grey[200] : Colors.white,
            filled: true,
            hintText: widget.hintText,
            hintStyle: TextStyle(color: Colors.grey[500]),
            errorText: widget.errorText == "" ? null : widget.errorText,
            errorStyle: const TextStyle(color: error, fontSize: 12),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12), // Border radius
              borderSide: const BorderSide(color: error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12), // Border radius
            ),
          ),
        )
      ],
    );
  }
}
