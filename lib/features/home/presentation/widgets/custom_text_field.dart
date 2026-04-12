import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.hint,
    this.preIcon,
    this.onSave,
    this.validator,
    this.inputAction = TextInputAction.done,
    this.helper,
    this.onChange,
  });
  final String? hint;
  final IconData? preIcon;
  final void Function(String?)? onSave;
  final String? Function(String?)? validator;
  final void Function(String)? onChange;
  final TextInputAction inputAction;
  final String? helper;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: TextFormField(
        onSaved: onSave,
        onChanged: onChange,
        textInputAction: inputAction,
        validator: validator,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          floatingLabelStyle: TextStyle(color: Colors.black, fontSize: 16),
          labelText: hint,
          helperText: helper,
          labelStyle: TextStyle(
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
          prefixIcon: Icon(preIcon, color: Colors.grey.shade600),
          enabledBorder: outline(Colors.grey.shade300),
          focusedBorder: outline(Colors.blue),
          errorBorder: outline(Colors.red),
          focusedErrorBorder: outline(Colors.red),
        ),
      ),
    );
  }

  OutlineInputBorder outline(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(color: color, width: 1.4),
    );
  }
}
