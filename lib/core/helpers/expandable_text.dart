import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExpandableText extends StatefulWidget {
  final String content;
  final TextStyle style;

  const ExpandableText({
    Key? key,
    required this.content,
    required this.style,
  }) : super(key: key);

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.content,
            style: widget.style,
            maxLines: isExpanded ? null : 2,
            overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
          ),
          if (_isTextExceeding(widget.content))
            GestureDetector(
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              child: Text(
                isExpanded ? "Read Less" : "Read More",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.red.shade300,
                  fontWeight: FontWeight.w900,
                  fontSize: 19.sp,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Check if the text exceeds two lines
  bool _isTextExceeding(String text) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: widget.style),
      maxLines: 2,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(
      maxWidth: MediaQuery.of(context).size.width,
    );

    return textPainter.didExceedMaxLines;
  }
}
