import 'package:eart_quith_app/provider/earthquake_provider.dart';
import 'package:eart_quith_app/utils/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late EarthquakeProvider provider;
  bool isFirst = true;
  String? _chosenValue;
  String? _formDate, _toDate;

  @override
  void didChangeDependencies() {
    if (isFirst) {
      provider = Provider.of<EarthquakeProvider>(context);
      provider.getEarthquakeData();
      isFirst = false;
    }

    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF320d3e),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text('Earthquake Tracker'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: _selectFormDate,
                  child: _formDate == null
                      ? Container(
                          alignment: Alignment.center,
                          width: 100,
                          height: 50,
                          color: Colors.black54,
                          child: const Text(
                            'From',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : Container(
                          alignment: Alignment.center,
                          width: 100,
                          height: 50,
                          color: Colors.black54,
                          child: const Icon(
                            Icons.done,
                            color: Colors.white,
                          )),
                ),
                GestureDetector(
                  onTap: _selectToDate,
                  child: _toDate == null
                      ? Container(
                          alignment: Alignment.center,
                          width: 100,
                          height: 50,
                          color: Colors.black54,
                          child: const Text(
                            'To',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : Container(
                          alignment: Alignment.center,
                          width: 100,
                          height: 50,
                          color: Colors.black54,
                          child: const Icon(
                            Icons.done,
                            color: Colors.white,
                          )),
                ),
                Container(
                  alignment: Alignment.center,
                  width: 80,
                  height: 50,
                  color: Colors.black54,
                  child: DropdownButton<String>(
                    focusColor: Colors.white,
                    value: _chosenValue,
                    //elevation: 5,
                    style: const TextStyle(color: Colors.white),
                    iconEnabledColor: Colors.white,
                    items: <String>[
                      '1',
                      '2',
                      '3',
                      '4',
                      '5',
                      '6',
                      '7',
                      '8',
                      '9',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      );
                    }).toList(),
                    dropdownColor: Colors.black45,
                    hint: const Text(
                      "Choose",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _chosenValue = value;
                      });
                    },
                  ),
                ),
                Container(
                  decoration:const BoxDecoration(
                      color: Colors.black54,
                      borderRadius:  BorderRadius.all(Radius.circular(50))
                  ),
                  alignment: Alignment.center,
                  width: 80,
                  height: 50,

                  child: IconButton(
                    onPressed: () {
                      if (_formDate == null &&
                          _toDate == null &&
                          _chosenValue == null) {
                        showMsg(context, 'Fill every field');
                        return;
                      }
                      provider.setTime(
                          newFrom: _formDate!.toString(),
                          newTo: _toDate!.toString(),
                          minMag: int.parse(_chosenValue!));
                      setState(() {
                        _toDate = null;
                        _formDate = null;
                        _chosenValue = null;
                      });
                    },
                    icon: const Icon(Icons.send, size: 30, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: provider.getData
                ? ListView(
                    padding: const EdgeInsets.all(8),
                    children: provider.earthquakeModel!.features!
                        .map(
                          (e) => Card(
                            elevation: 5,
                            child: ListTile(
                              leading: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Container(
                                  decoration:const BoxDecoration(
                                      color: Colors.black,
                                      borderRadius:  BorderRadius.all(Radius.circular(30))
                                  ),
                                  alignment: Alignment.center,
                                  width: 50,
                                  height: 160,

                                  child: Text(e.properties!.mag.toString(),
                                      style:
                                          const TextStyle(color: Colors.white)),
                                ),
                              ),
                              title: Text(
                                e.properties!.title.toString(),
                              ),
                              subtitle: Text(getFormattedDateTime(
                                  e.properties!.time!, 'yyyy-MM-dd')),
                            ),
                          ),
                        )
                        .toList())
                : const Center(
                    child: Text('Please wait..'),
                  ),
          ),
        ],
      ),
    );
  }

  void _selectFormDate() async {
    final selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1980),
        lastDate: DateTime(2030));

    if (selectedDate != null) {
      setState(() {
        _formDate = DateFormat('yyyy-MM-dd').format(selectedDate);
      });
    }
  }

  void _selectToDate() async {
    final selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1980),
        lastDate: DateTime(2030));

    if (selectedDate != null) {
      setState(() {
        _toDate = DateFormat('yyyy-MM-dd').format(selectedDate);
      });
    }
  }
}
