import 'package:flutter/material.dart';

class GoalsView extends StatelessWidget {
  const GoalsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: SafeArea(
        child: Column(
          children: <Row>[
            Row(
              children: [
                Icon(
                  Icons.settings,
                  size: 48,
                ),
              ],
            ),
            Row(
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          color: Colors.green,
                          child: Text(
                            'Hydration',
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Text('vesi'),
                        Text('vesi'),
                        Text('vesi'),
                        Text('vesi'),
                        Text('vesi'),
                      ],
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
