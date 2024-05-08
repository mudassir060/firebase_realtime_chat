import 'package:flutter/material.dart';

class Textfield extends StatefulWidget {
  final Widget? sufixIcon;
  final bool? obscureText;
  final String? title;
  final String? borderTitle;
  final Color borderColor;
  final int? maxLines;
  final TextEditingController? ctrl;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  const Textfield({
    Key? key,
    this.title,
    this.ctrl,
    this.obscureText,
    this.sufixIcon,
    this.borderColor = Colors.blue,
    this.borderTitle,
    this.maxLines,
    this.keyboardType,
    this.onChanged,
  }) : super(key: key);

  @override
  State<Textfield> createState() => _TextfieldState();
}

class _TextfieldState extends State<Textfield> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: widget.borderTitle == null ? Colors.white : null,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(width: 1, color: widget.borderColor)),
      child: widget.ctrl != null
          ? TextFormField(
              obscureText: widget.obscureText ?? false,
              controller: widget.ctrl,
              maxLines: widget.maxLines ?? 1,
              keyboardType: widget.keyboardType,
              onChanged: (value) {
                if (widget.onChanged != null) {
                  widget.onChanged!(value);
                }
              },
              decoration: InputDecoration(
                hintText: widget.title,
                labelText: widget.borderTitle,
                hintStyle: const TextStyle(fontSize: 14),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12.0, vertical: 10.0),
                border: InputBorder.none,
                alignLabelWithHint: true,
                suffixIcon: widget.sufixIcon,
              ),
            )
          : Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget.title ?? ""),
                )
              ],
            ),
    );
  }
}
