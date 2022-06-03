import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? textEditingController;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final String label;
  final String hintText;
  final Color borderColor;
  final bool obscureText;

  const CustomTextFormField(
      {Key? key,
      this.textEditingController,
      this.focusNode,
      this.keyboardType,
      this.textInputAction,
      this.validator,
      required this.label,
      required this.hintText,
      this.borderColor = Colors.transparent,
      this.obscureText = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: borderColor, width: 2)
        ),
        child: TextFormField(
          controller: textEditingController,
          focusNode: focusNode,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            label: Text(label),
            hintText: hintText,
          ),
          textInputAction: textInputAction,
          validator: validator,
          obscureText: obscureText,
        ),
      ),
    );
  }
}

class SearchField extends StatelessWidget {
  final TextEditingController? textEditingController;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final String hintText;
  final Color borderColor;
  final bool obscureText;

  const SearchField(
      {Key? key,
        this.textEditingController,
        this.focusNode,
        this.keyboardType,
        this.textInputAction,
        this.validator,
        required this.hintText,
        this.borderColor = Colors.transparent,
        this.obscureText = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.r),
          color: const Color(0xFFF0F1F5),
      ),
      child: TextFormField(
        controller: textEditingController,
        focusNode: focusNode,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(top: 14.h),
          hintText: hintText,
          prefixIcon: const Icon(Icons.search),
          prefixIconColor: const Color(0xFFC4C6CC),
          fillColor: const Color(0xFFF0F1F5),
          filled: true,
        ),
        textInputAction: textInputAction,
        validator: validator,
        obscureText: obscureText,
      ),
    );
  }
}
