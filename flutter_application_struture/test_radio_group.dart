import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: RadioTest()));
}

class RadioTest extends StatefulWidget {
  const RadioTest({super.key});

  @override
  State<RadioTest> createState() => _RadioTestState();
}

class _RadioTestState extends State<RadioTest> {
  String _selectedValue = 'option1';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Radio Test')),
      body: Column(
        children: [
          // Try to find RadioGroup in Flutter 3.38.5
          // RadioGroup(
          //   value: _selectedValue,
          //   onChanged: (value) {
          //     setState(() {
          //       _selectedValue = value!;
          //     });
          //   },
          //   children: const [
          //     RadioListTile(value: 'option1', title: Text('Option 1')),
          //     RadioListTile(value: 'option2', title: Text('Option 2')),
          //     RadioListTile(value: 'option3', title: Text('Option 3')),
          //   ],
          // ),
          
          // Fallback to deprecated API
          RadioListTile(
            value: 'option1',
            groupValue: _selectedValue,
            onChanged: (value) {
              setState(() {
                _selectedValue = value!;
              });
            },
            title: const Text('Option 1'),
          ),
          RadioListTile(
            value: 'option2',
            groupValue: _selectedValue,
            onChanged: (value) {
              setState(() {
                _selectedValue = value!;
              });
            },
            title: const Text('Option 2'),
          ),
          RadioListTile(
            value: 'option3',
            groupValue: _selectedValue,
            onChanged: (value) {
              setState(() {
                _selectedValue = value!;
              });
            },
            title: const Text('Option 3'),
          ),
        ],
      ),
    );
  }
}