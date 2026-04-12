import 'package:chatapp/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomIntputItem extends StatefulWidget {
  const CustomIntputItem({super.key, required this.onSave});

  final void Function(String?) onSave;

  @override
  State<CustomIntputItem> createState() => _CustomIntputItemState();
}

class _CustomIntputItemState extends State<CustomIntputItem> {
  bool _colored = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 60,
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
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: TextFormField(
          textAlign: TextAlign.center,
          cursorHeight: 30,
          cursorColor: _colored ? Colors.white : AppColors.primary,
          textAlignVertical: TextAlignVertical.center,
          validator: (value) {
            if (value!.isEmpty) {
              return '';
            }
            return null;
          },
          onSaved: widget.onSave,
          inputFormatters: [
            LengthLimitingTextInputFormatter(1),
            FilteringTextInputFormatter.digitsOnly,
          ],
          onChanged: (value) {
            if (value.length == 1) {
              FocusScope.of(context).nextFocus();
            }
            setState(() {
              _colored = !_colored;
            });
          },
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.w400,
          ),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            fillColor: _colored ? AppColors.primary : Color(0xffF9FAFB),
            contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            constraints: BoxConstraints(minHeight: 100, maxWidth: 50),
            filled: true,
            isDense: true,
            errorMaxLines: 1,
            errorStyle: const TextStyle(height: 0, fontSize: 0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
            enabledBorder: outlineBorder(Colors.grey.shade200),
            focusedBorder: outlineBorder(AppColors.primary),
            errorBorder: outlineBorder(Colors.red),
            focusedErrorBorder: outlineBorder(AppColors.primary),
          ),
        ),
      ),
    );
  }

  OutlineInputBorder outlineBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: color, width: 1.5),
    );
  }
}
