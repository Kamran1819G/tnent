import 'package:flutter/material.dart';
import 'package:tnennt/helpers/color_utils.dart';

class CustomCheckboxListTile extends StatelessWidget {
  final String title;
  final bool value;
  final bool selectedStyle;
  final ValueChanged<bool> onChanged;

  const CustomCheckboxListTile({
    Key? key,
    required this.title,
    required this.value,
    this.selectedStyle = false,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      selectedTileColor: Theme.of(context).primaryColor,
      activeColor: Colors.white,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      checkboxShape: CircleBorder(
        side: BorderSide(
          color: Colors.white,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: hexToColor('#848484'),
          width: 1,
        ),
      ),
      checkColor: Theme.of(context).primaryColor,
      selected: selectedStyle ? value : false,
      value: value,
      onChanged: (newValue) {
        onChanged(newValue ?? false);
      },
    );
  }
}