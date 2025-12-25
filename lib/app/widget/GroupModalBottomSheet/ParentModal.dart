import 'package:flutter/material.dart';

class BottomSheetComponent extends StatelessWidget {
  final Widget widget;
  const BottomSheetComponent({super.key, required this.widget});

  @override
  Widget build(BuildContext context) {
    return Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color:  Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(10),
                ),
              ),
              padding: EdgeInsets.all(20),
              child: widget
            ),
              Positioned(
                top: -40,
                right: 16,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.grey[300],
                    child: Icon(Icons.close, size: 18, color: Colors.black),
                  ),
                ),
              ),
          ],
        );
  }
}