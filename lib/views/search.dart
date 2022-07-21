import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);
  @override
  State<SearchPage> createState() => _SearchPageState();
}

enum Condition { ignore, option1, option2, option3, option4 }

class _SearchPageState extends State<SearchPage> {
  Condition? _group = Condition.ignore;
  @override
  Widget build(BuildContext context) {
    var configs = [
      RadioControlConfig<Condition>(label: 'ignore', value: Condition.ignore),
      RadioControlConfig<Condition>(label: 'option1', value: Condition.option1),
      RadioControlConfig<Condition>(label: 'option2', value: Condition.option2),
      RadioControlConfig<Condition>(label: 'option3', value: Condition.option3),
      RadioControlConfig<Condition>(label: 'option4', value: Condition.option4),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('搜尋'),
      ),
      body: Column(
        children: [
          for (var i = 0; i < 2; i++)
            Column(
              children: [
                for (var config in configs)
                  MergeSemantics(
                    child: Row(
                      children: [
                        Radio<Condition>(
                          groupValue: _group,
                          value: config.value,
                          onChanged: (Condition? value) {
                            setState(() {
                              _group = value;
                            });
                          },
                        ),
                        Text(config.label),
                      ],
                    ),
                  )
              ],
            )
        ],
      ),
    );
  }
}

class RadioControlConfig<T> {
  String label;
  T value;
  RadioControlConfig({required this.label, required this.value});
}
