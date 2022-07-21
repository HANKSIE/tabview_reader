import 'package:flutter/material.dart';
import 'package:tabview_reader/models/radio_control_config.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);
  @override
  State<SearchPage> createState() => _SearchPageState();
}

enum Cond1 { ignore, option1, option2, option3, option4 }
enum Cond2 { ignore, option1, option2, option3, option4 }
enum Cond3 { ignore, option1, option2, option3, option4 }
enum Cond4 { ignore, option1, option2, option3, option4 }

class _SearchPageState extends State<SearchPage> {
  Cond1? _selected1 = Cond1.ignore;
  Cond2? _selected2 = Cond2.ignore;
  @override
  Widget build(BuildContext context) {
    var configs1 = [
      RadioControlConfig<Cond1>(label: 'ignore', value: Cond1.ignore),
      RadioControlConfig<Cond1>(label: 'option1', value: Cond1.option1),
      RadioControlConfig<Cond1>(label: 'option2', value: Cond1.option2),
      RadioControlConfig<Cond1>(label: 'option3', value: Cond1.option3),
      RadioControlConfig<Cond1>(label: 'option4', value: Cond1.option4),
    ];
    var configs2 = [
      RadioControlConfig<Cond2>(label: 'ignore', value: Cond2.ignore),
      RadioControlConfig<Cond2>(label: 'option1', value: Cond2.option1),
      RadioControlConfig<Cond2>(label: 'option2', value: Cond2.option2),
      RadioControlConfig<Cond2>(label: 'option3', value: Cond2.option3),
      RadioControlConfig<Cond2>(label: 'option4', value: Cond2.option4),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('搜尋'),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Column(
            children: [
              Column(children: [
                for (var config in configs1)
                  RadioListTile<Cond1>(
                    title: Text(config.label),
                    groupValue: _selected1,
                    value: config.value,
                    onChanged: (Cond1? val) => setState(() {
                      _selected1 = val;
                    }),
                  )
              ]),
              Column(children: [
                for (var config in configs2)
                  RadioListTile<Cond2>(
                    title: Text(config.label),
                    groupValue: _selected2,
                    value: config.value,
                    onChanged: (Cond2? val) => setState(() {
                      _selected2 = val;
                    }),
                  )
              ])
            ],
          )
        ]),
      ),
    );
  }
}
