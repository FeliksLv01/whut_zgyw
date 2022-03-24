import 'package:flutter/material.dart';

class RoundedInputField extends StatefulWidget {
  final String? hintText;
  final IconData icon;
  final TextEditingController? controller;
  final void Function(String)? onSubmitted;
  final bool obscureText;
  const RoundedInputField({
    Key? key,
    this.hintText,
    this.icon = Icons.person,
    this.obscureText = false,
    this.controller,
    this.onSubmitted,
  }) : super(key: key);

  @override
  State<RoundedInputField> createState() => _RoundedInputFieldState();
}

class _RoundedInputFieldState extends State<RoundedInputField> {
  bool isObscureText = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isObscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: size.width * 0.8,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(29),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(76),
            blurRadius: 5.0,
          ),
        ],
      ),
      child: TextField(
        controller: widget.controller,
        cursorColor: Colors.grey,
        onSubmitted: widget.onSubmitted,
        obscureText: isObscureText,
        decoration: InputDecoration(
          icon: Icon(widget.icon, color: Colors.grey),
          suffixIcon: widget.obscureText
              ? GestureDetector(
                  onTap: () {
                    setState(() => isObscureText = !isObscureText);
                  },
                  child: Icon(isObscureText ? Icons.visibility : Icons.visibility_off, color: Colors.grey),
                )
              : null,
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
