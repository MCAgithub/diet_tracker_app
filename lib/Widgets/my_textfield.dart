import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final String labelText;
  final String helperText;
  final TextEditingController controller;
  final Color borderColor;
  final bool obscure;
  final double borderCircular;

  const MyTextField(
      {Key? key,
      required this.labelText,
      required this.helperText,
      required this.controller,
      required this.borderColor,
      required this.obscure,
      required this. borderCircular})
      : super(key: key);

  @override
  State<MyTextField> createState() => _MyTextField();
}

class _MyTextField extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SizedBox(
        width: 365,
        child: TextField(
          style: TextStyle(color: widget.borderColor),
          controller: widget.controller,
          obscureText: widget.obscure,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: widget.borderColor, width: 2),
                borderRadius: BorderRadius.circular(widget.borderCircular)),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: widget.borderColor, width: 2),
                borderRadius: BorderRadius.circular(widget.borderCircular)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: widget.borderColor, width: 2),
                borderRadius: BorderRadius.circular(widget.borderCircular)),
            errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    width: 2, color: Theme.of(context).colorScheme.primary),
                borderRadius: BorderRadius.circular(widget.borderCircular)),
            focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    width: 2, color: Theme.of(context).colorScheme.primary),
                borderRadius: BorderRadius.circular(widget.borderCircular)),
            labelText: widget.labelText,
            labelStyle: TextStyle(color: widget.borderColor),
            hintText: '',
            helperText: widget.helperText,
            helperStyle: const TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }
}
