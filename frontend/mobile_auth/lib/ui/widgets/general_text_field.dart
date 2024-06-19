import 'package:flutter/material.dart';
import 'package:mobile_auth/ui/util/extensions.dart';

class GeneralTextField extends StatefulWidget {
  const GeneralTextField({
    super.key,
    this.isPasswordField = false,
    required this.controller,
    required this.label,
  });

  final TextEditingController controller;
  final bool isPasswordField;
  final String label;

  @override
  State<GeneralTextField> createState() => _GeneralTextFieldState();
}

class _GeneralTextFieldState extends State<GeneralTextField> {
  bool isHide = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isHide = widget.isPasswordField;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.label),
          TextFormField(
            controller: widget.controller,
            obscureText: isHide,
            decoration: InputDecoration(
                suffixIcon: widget.isPasswordField
                    ? SizedBox(
                  width: 50,
                  height: 50,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isHide = !isHide;
                      });
                    },
                    child: Icon(isHide
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined),
                  ),
                )
                    : const SizedBox.shrink(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Colors.grey, width: 0.5),
                )),
          ),
        ],
      ),
    );
  }
}
