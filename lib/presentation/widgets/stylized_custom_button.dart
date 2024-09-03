import 'package:flutter/material.dart';

class StylizedCustomButton extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onPressed;

  const StylizedCustomButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

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
              color: Colors.grey[200],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: icon != ""
                      ? Image.asset(
                          icon,
                          scale: 2,
                        )
                      : const Icon(Icons.more_horiz_outlined,
                          color: Colors.black26, size: 32),
                ),
                const SizedBox(
                    width: 10), // Space between the icon and the label
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
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
