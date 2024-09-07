import 'package:flutter/material.dart';

class StylizedCustomButton extends StatelessWidget {
  final String icon;
  final String backgground;
  final String label;
  final VoidCallback onPressed;
  final Color textColor;

  const StylizedCustomButton(
      {Key? key,
      required this.icon,
      required this.label,
      required this.onPressed,
      required this.backgground,
      this.textColor = Colors.black})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Colors.grey.shade200,
                image: DecorationImage(
                  image: AssetImage(backgground),
                  fit: BoxFit.cover,
                  repeat: ImageRepeat.repeatX,
                )),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: icon != ""
                      ? Image.asset(
                          icon,
                          scale: 3,
                        )
                      : Image.asset(
                          "assets/catalog_button_images/comin.png",
                          scale: 3,
                        ),
                ),
                const SizedBox(
                    width: 10), // Space between the icon and the label
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                    fontFamily: 'regular',
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
