import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:tabview_reader/models/radio_control_config.dart';
import 'package:tabview_reader/store/search_payload.dart';
import 'package:tabview_reader/store/settings.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  int? _selected1 = 0;
  int? _selected2 = 0;
  int? _selected3 = 0;

  String _keyword = '';

  late final TextEditingController _keywordController = TextEditingController();
  late final TextEditingController _dirController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _keywordController.text = _keyword;
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _dirController.text =
          Provider.of<SettingsStore>(context, listen: false).searchFolder;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _keywordController.dispose();
    _dirController.dispose();
  }

  _pickDirectory() async {
    if (await Permission.storage.isDenied) {
      await Permission.storage.request();
    }

    if (await Permission.storage.isDenied) {
      Fluttertoast.showToast(msg: '請啟用讀取權限以啟用搜尋功能');
    }

    String? dir = await FilePicker.platform.getDirectoryPath();
    if (dir != null) {
      Provider.of<SettingsStore>(context, listen: false).setSearchFolder(dir);
      _dirController.text = dir;
    }
  }

  _search() {
    final settingStore = Provider.of<SettingsStore>(context, listen: false);
    if (settingStore.searchFolder.isEmpty) {
      Fluttertoast.showToast(msg: '未選擇搜尋目錄', gravity: ToastGravity.CENTER);
      return;
    }

    Navigator.of(context).pushNamed('/search/result',
        arguments: SearchPayload(
            dir: settingStore.searchFolder,
            selects: '$_selected1$_selected2$_selected3',
            keyword: _keyword));
  }

  @override
  Widget build(BuildContext context) {
    final labels1 = ['X', '低', '中', '高'];
    final labels2 = ['X', '正常', 'AD', 'GD', '其他'];
    final labels3 = ['X', '演奏', '通俗', '練習'];
    final config1 = RadioControlConfig<int>(
        label: '困難度',
        groupValue: _selected1,
        onChange: (int? val) => setState(() {
              _selected1 = val;
            }),
        units: [
          for (int i = 0; i < 4; i++)
            RadioControlUnitConfig<int>(label: labels1[i], value: i),
        ]);
    final config2 = RadioControlConfig<int>(
        label: '調音',
        groupValue: _selected2,
        onChange: (int? val) => setState(() {
              _selected2 = val;
            }),
        units: [
          for (int i = 0; i < 5; i++)
            RadioControlUnitConfig<int>(label: labels2[i], value: i),
        ]);
    final config3 = RadioControlConfig<int>(
        label: '旋律',
        groupValue: _selected3,
        onChange: (int? val) => setState(() {
              _selected3 = val;
            }),
        units: [
          for (int i = 0; i < 4; i++)
            RadioControlUnitConfig<int>(label: labels3[i], value: i),
        ]);
    final configs = [config1, config2, config3];

    return Scaffold(
        appBar: AppBar(
          title: const Text('搜尋'),
        ),
        body: Column(
          children: [
            Expanded(
                flex: 11,
                child: SingleChildScrollView(
                    child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(children: [
                    ...[
                      for (final config in configs)
                        Column(children: [
                          Text(config.label),
                          for (final unit in config.units)
                            RadioListTile<int>(
                              contentPadding: EdgeInsets.zero,
                              title: Text(unit.label),
                              groupValue: config.groupValue,
                              value: unit.value,
                              onChanged: config.onChange,
                            )
                        ])
                    ],
                    const SizedBox(height: 10),
                    TextField(
                        controller: _keywordController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: '輸入關鍵字',
                        ),
                        onChanged: (val) {
                          setState(() {
                            _keyword = val;
                          });
                        }),
                    const SizedBox(height: 10),
                    TextField(
                      readOnly: true,
                      controller: _dirController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: '點擊選擇搜尋目錄',
                      ),
                      onTap: _pickDirectory,
                    )
                  ]),
                ))),
            Expanded(
                child: Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 20),
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                        ),
                        onPressed: _search,
                        child: const Text('搜尋')))
              ],
            ))
          ],
        ));
  }
}
