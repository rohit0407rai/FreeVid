import 'package:flutter/material.dart';
import 'package:freevid/utils/colors.dart';

class NamedCard extends StatefulWidget {
  final Size size;
  final String image;
  final String text;

  const NamedCard(
      {super.key, required this.size, required this.image, required this.text});

  @override
  State<NamedCard> createState() => _NamedCardState();
}

class _NamedCardState extends State<NamedCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.size.width * 0.4,
      width: widget.size.width * 0.4,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [CustomColor().appBar, CustomColor().darkCode],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft),
          borderRadius: BorderRadius.circular(22)),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              widget.image,
              width: widget.size.width * 0.25,
            ),
            SizedBox(
              height: 2,
            ),
            Text(widget.text)
          ],
        ),
      ),
    );
  }
}
