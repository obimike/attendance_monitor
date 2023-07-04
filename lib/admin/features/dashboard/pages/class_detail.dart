import 'package:flutter/material.dart';

class ClassDetail extends StatelessWidget {
  const ClassDetail({super.key});

  @override
  Widget build(BuildContext context) {

    var dynamicWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Class detail",
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.start,
        ),
      ),
      body:  Padding(
        padding:  const EdgeInsets.all(16.0),
        child:  Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Class Name",
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.start,
            ),Text(
              "NUC Student",
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 12),
            Text(
              "Class ID",
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.start,
            ),Text(
              "aI974e842D2pE20EDqR",
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 12),
            Text(
              "Class CheckIn Time",
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.start,
            ),Text(
              "8:45am",
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 12),
            Text(
              "Class CheckOut Time",
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.start,
            ),Text(
              "6:03pm",
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 12),
            Text(
              "Days of the week",
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.start,
            ),Wrap(
              children: [
                Text(
                "Monday, Tuesday, Thursday, Saturday, Sunday",
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.start,
              ),],
            ),
        ],),
      ),
    );
  }
}
