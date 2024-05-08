import 'package:flutter/material.dart';
import 'package:tnennt/screens/story_screen.dart';

class StoreUpdateTile extends StatelessWidget {
  final String name;
  final String image;

  StoreUpdateTile({
    required this.name,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => StoryScreen(
          storeName: name,
          storeImage: Image.asset(image),
        )));
      },
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[200]!),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Image.asset(image, height: 48.0)),
            SizedBox(height: 8.0),
            Text(name,
                style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0)),
          ],
        ),
      ),
    );
  }
}
