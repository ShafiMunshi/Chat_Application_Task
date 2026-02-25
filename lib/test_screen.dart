import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
const platform = MethodChannel('com.example.chat/channel');
class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text(
              'Test Screen',
              style: Theme.of(context).textTheme.headlineMedium,
            ),

            ElevatedButton(
              onPressed: () async {
                final res = await platform.invokeMethod('saveData', {
                  'collection': 'testCollection',
                  'docId': 'testDoc',
                  'data': {'field1': 'value1', 'field2323424': 42},
                });

                log(res.toString());
              },
              child: const Text('Set Data'),
            ),
            ElevatedButton(
              onPressed: () async {
                final data = await platform.invokeMethod('getData', {
                  'collection': 'testCollection',
                  'docId': 'testDoc',
                });

                log(data.toString());
              },
              child: const Text('Get Data'),
            ),
          ],
        ),
      ),
    );
  }
}
