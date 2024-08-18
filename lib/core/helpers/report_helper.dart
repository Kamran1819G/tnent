import 'package:flutter/material.dart';
import 'package:tnent/core/helpers/snackbar_utils.dart';

class ReportHelperWidget extends StatefulWidget {
  const ReportHelperWidget({super.key});

  @override
  _ReportDialogState createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportHelperWidget> {
  String? selectedOption;

  TextEditingController otherContentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Help us understand the issue',
        style: TextStyle(fontSize: 15),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Your feedback helps keep our community safe and respectful. What\'s wrong with this item?',
            style: TextStyle(
              fontFamily: 'Regular',
              fontSize: 12,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          RadioListTile<String>(
            title: const Text(
              'Inappropriate Content',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w100,
              ),
            ),
            value: 'Inappropriate Content',
            groupValue: selectedOption,
            onChanged: (String? value) {
              setState(() {
                selectedOption = value;
              });
            },
          ),
          RadioListTile<String>(
            title: const Text(
              'Spam Content',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w100,
              ),
            ),
            value: 'Spam Content',
            groupValue: selectedOption,
            onChanged: (String? value) {
              setState(() {
                selectedOption = value;
              });
            },
          ),
          RadioListTile<String>(
            title: const Text(
              'Offensive Content',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w100,
              ),
            ),
            value: 'Offensive Content',
            groupValue: selectedOption,
            onChanged: (String? value) {
              setState(() {
                selectedOption = value;
              });
            },
          ),
          RadioListTile<String>(
            title: const Text(
              'Other Content',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w100,
              ),
            ),
            value: 'Other Content',
            groupValue: selectedOption,
            onChanged: (String? value) {
              setState(() {
                selectedOption = value;
              });
            },
          ),
          if (selectedOption == 'Other Content')
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                controller: otherContentController,
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  hintText: 'Please specify the reason',
                  hintStyle: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w100,
                  ),
                  contentPadding: const EdgeInsets.all(10),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
              ),
            ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: selectedOption == 'Other Content' &&
                            otherContentController.text.isEmpty
                        ? Colors.grey
                        : Colors.red,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5))),
                onPressed: () {
                  if (selectedOption == 'Other Content' &&
                      otherContentController.text.isEmpty) {
                    return;
                  }
                  Navigator.of(context).pop();
                  showSnackBar(
                    context,
                    "Your issue has been reported!",
                    bgColor: Colors.green,
                    leadIcon: const Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                  );
                },
                child: const Text(
                  'Submit Report',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
