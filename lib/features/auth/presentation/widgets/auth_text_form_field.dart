import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';

class AuthTextFormField extends StatefulWidget {
  const AuthTextFormField({
    super.key,
    this.hint,
    this.preIcon,
    this.onSave,
    this.validator,
    this.visibility = false,
    this.keyboardType = TextInputType.text,
    this.onChange,
    this.inputAction = TextInputAction.done,
    this.autofocus = false,
    this.onSubmit,
  });
  final String? hint;
  final IconData? preIcon;
  final void Function(String?)? onSave;
  final String? Function(String?)? validator;
  final bool visibility;
  final TextInputType keyboardType;
  final void Function(String)? onChange;
  final TextInputAction inputAction;
  final bool autofocus;
  final Function()? onSubmit;
  @override
  State<AuthTextFormField> createState() => _AuthTextFormFieldState();
}

class _AuthTextFormFieldState extends State<AuthTextFormField> {
  bool isVisibile = false;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 5,
              spreadRadius: 1,
              offset: Offset(1, 2),
            ),
          ],
        ),
        child: TextFormField(
          obscureText: widget.visibility ? !isVisibile : false,
          onSaved: widget.onSave,
          autofocus: widget.autofocus,
          onChanged: widget.onChange,
          textInputAction: widget.inputAction,
          onEditingComplete: widget.onSubmit,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          decoration: InputDecoration(
            fillColor: Color(0xffF9FAFB),
            filled: true,
            hintText: widget.hint,
            hintStyle: const TextStyle(color: AppColors.grey, fontSize: 14),
            prefixIcon: Icon(widget.preIcon, color: AppColors.grey, size: 22),
            suffixIcon: Visibility(
              visible: widget.visibility,
              child: IconButton(
                onPressed: () {
                  isVisibile = !isVisibile;
                  setState(() {});
                },
                icon: Icon(
                  isVisibile ? Icons.visibility : Icons.visibility_off,
                  color: AppColors.grey,
                  size: 22,
                ),
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}
