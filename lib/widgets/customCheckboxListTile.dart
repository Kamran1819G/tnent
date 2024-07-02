import 'package:flutter/material.dart';
import 'package:tnennt/helpers/color_utils.dart';

class CustomCheckboxListTile extends StatefulWidget {
  final String title;
  final bool value;
  final bool selectedStyle;
  final ValueChanged<bool> onChanged;

  const CustomCheckboxListTile({
    super.key,
    required this.title,
    this.value = false,
    this.selectedStyle = false,
    required this.onChanged,
  });

  @override
  State<CustomCheckboxListTile> createState() => _CustomCheckboxListTileState();
}

class _CustomCheckboxListTileState extends State<CustomCheckboxListTile> {
  late bool _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.value;
  }

  void _toggleCheckbox() {
    setState(() {
      _isChecked = !_isChecked;
      widget.onChanged(_isChecked); // Notify parent about the change
    });
  }

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      selectedTileColor: Theme.of(context).primaryColor,
      activeColor: Colors.white,
      title: Text(
        widget.title,
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
      selected: widget.selectedStyle ? _isChecked : false,
      value: _isChecked,
      onChanged: (value) {
        _toggleCheckbox();
      },
    );
  }
}
