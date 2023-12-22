import 'package:flutter/material.dart';
import 'package:lakasir/utils/colors.dart';

typedef MyCallback = void Function(String);
typedef ValidatorCallback = String? Function(String?);

class MyTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? label;
  final String hintText;
  final bool mandatory;
  final String errorText;
  final String prefixText;
  final bool obscureText;
  final int? maxLines;
  final Widget? rightIcon;
  final Function(String)? onSubmitted;
  final Function(String)? onChanged;
  final Function(PointerDownEvent)? onTapOutside;
  final ValidatorCallback? validator;
  final bool autofocus;

  const MyTextField({
    super.key,
    this.label,
    this.mandatory = false,
    required this.controller,
    this.hintText = "",
    this.obscureText = false,
    this.prefixText = "",
    this.errorText = "",
    this.maxLines = 1,
    this.rightIcon,
    this.onSubmitted,
    this.onChanged,
    this.onTapOutside,
    this.autofocus = false,
    this.validator,
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Container(
            margin: const EdgeInsets.only(bottom: 5),
            child: RichText(
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
          ),
        TextFormField(
          focusNode: _focusNode,
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
              return "Field is required";
            }
            return null;
          },
          onFieldSubmitted: widget.onSubmitted,
          onChanged: widget.onChanged,
          // onSubmitted: widget.onSubmitted,
          decoration: InputDecoration(
            prefixText: widget.prefixText,
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
            fillColor: Colors.white,
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
