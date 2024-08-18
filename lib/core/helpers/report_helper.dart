import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tnent/core/helpers/snackbar_utils.dart';

class ReportHelperWidget extends StatefulWidget {
  const ReportHelperWidget({super.key});

  @override
  _ReportDialogState createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportHelperWidget> {
  bool inappropriateContent = false;
  bool spamContent = false;
  bool offensiveContent = false;
  bool otherContent = false;

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
          CheckboxListTile(
            title: const Text(
              'Inappropriate Content',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w100,
              ),
            ),
            value: inappropriateContent,
            onChanged: (bool? value) {
              setState(() {
                inappropriateContent = value!;
              });
            },
          ),
          CheckboxListTile(
            title: const Text(
              'Spam Content',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w100,
              ),
            ),
            value: spamContent,
            onChanged: (bool? value) {
              setState(() {
                spamContent = value!;
              });
            },
          ),
          CheckboxListTile(
            title: const Text(
              'Offensive Content',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w100,
              ),
            ),
            value: offensiveContent,
            onChanged: (bool? value) {
              setState(() {
                offensiveContent = value!;
              });
            },
          ),
          CheckboxListTile(
            title: const Text(
              'Other Content',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w100,
              ),
            ),
            value: otherContent,
            onChanged: (bool? value) {
              setState(() {
                otherContent = value!;
              });
            },
          ),
          if (otherContent)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                controller: otherContentController,
                onChanged: (value) {
                  setState(() {});
                },
                // ignore: prefer_const_constructors
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
                    backgroundColor: otherContent
                        ? otherContentController.text.isEmpty
                            ? Colors.grey
                            : Colors.red
                        : Colors.red,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5))),
                onPressed: () {
                  if (otherContent) {
                    if (otherContentController.text.isEmpty) {
                      return;
                    }
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
