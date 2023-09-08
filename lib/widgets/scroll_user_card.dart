import 'package:flutter/material.dart';
import 'package:freevid/utils/colors.dart';

class ScrollUserCard extends StatefulWidget {
  final Size size;
  final String image;
  final String text;
  final String date;

  const ScrollUserCard(
      {super.key,
      required this.size,
      required this.image,
      required this.text,
      required this.date});

  @override
  State<ScrollUserCard> createState() => _ScrollUserCardState();
}

class _ScrollUserCardState extends State<ScrollUserCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.size.width * 0.6,
      width: widget.size.width * 0.4,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [CustomColor().appBar, CustomColor().darkCode],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft),
          borderRadius: BorderRadius.circular(22)),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: ListView(
          children: [
            Column(
              children: [
                Image.asset(
                  widget.image,
                  width: widget.size.width * 0.25,
                  height: widget.size.height * 0.1,
                ),
                Text(widget.text),
                Text(
                  widget.date,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
