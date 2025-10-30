import 'package:flutter/material.dart';

class EcliniqText extends StatelessWidget {
  const EcliniqText(
    this.data, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.isSelectable = false,
    this.overflow,
  });

  final String data;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final bool isSelectable;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return isSelectable
        ? SelectionArea(
            child: Text(
              data,
              style: style,
              textAlign: textAlign,
              maxLines: maxLines,
              overflow: overflow,
            ),
          )
        : Text(
            data,
            style: style,
            textAlign: textAlign,
            maxLines: maxLines,
            overflow: overflow,
          );
  }
}
