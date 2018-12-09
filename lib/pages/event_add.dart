import 'package:fcsp_rad/event.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';
import 'event.dart';

class EventEditor extends StatefulWidget {
  final Function _addEvent;

  EventEditor(this._addEvent);

  @override
  _EventEditorState createState() => new _EventEditorState(_addEvent);
}

class _InputDropdown extends StatelessWidget {
  const _InputDropdown(
      {Key key,
      this.child,
      this.labelText,
      this.valueText,
      this.valueStyle,
      this.onPressed})
      : super(key: key);

  final String labelText;
  final String valueText;
  final TextStyle valueStyle;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
        ),
        baseStyle: valueStyle,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(valueText, style: valueStyle),
            Icon(Icons.arrow_drop_down,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey.shade700
                    : Colors.white70),
          ],
        ),
      ),
    );
  }
}

class _DateTimePicker extends StatelessWidget {
  const _DateTimePicker(
      {Key key,
      this.labelText,
      this.selectedDate,
      this.selectedTime,
      this.selectDate,
      this.selectTime})
      : super(key: key);

  final String labelText;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final ValueChanged<DateTime> selectDate;
  final ValueChanged<TimeOfDay> selectTime;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) selectDate(picked);
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: selectedTime);
    if (picked != null && picked != selectedTime) selectTime(picked);
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle valueStyle = Theme.of(context).textTheme.title;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          flex: 4,
          child: _InputDropdown(
            labelText: labelText,
            valueText: DateFormat.yMMMd().format(selectedDate),
            valueStyle: valueStyle,
            onPressed: () {
              _selectDate(context);
            },
          ),
        ),
        const SizedBox(width: 12.0),
        Expanded(
          flex: 3,
          child: _InputDropdown(
            valueText: selectedTime.format(context),
            valueStyle: valueStyle,
            onPressed: () {
              _selectTime(context);
            },
          ),
        ),
      ],
    );
  }
}

class _EventEditorState extends State<EventEditor> {
  final nameTextEditingController =
      TextEditingController(text: "toller Groupride");
  final startingTimeTextEditingController =
      TextEditingController(text: "is this used?");
  final whereTextEditingController =
      TextEditingController(text: "Billwerder Sperrwerk");
  final descriptionTimeTextEditingController =
      TextEditingController(text: "this is my description");
  final latTextEditingController = TextEditingController(text: "50");
  final lonTextEditingController = TextEditingController(text: "11");
  final disciplineTextEditingController1 = TextEditingController(text: "MTB");
  final distanceTextEditingController1 = TextEditingController(text: "22");
  final intensityTextEditingController1 = TextEditingController(text: "1");
  final plannedAvgTextEditingController1 = TextEditingController(text: "25");
  final kommotTextEditingController1 =
      TextEditingController(text: "https://www.komoot.com/tour/52785355");

  final GlobalKey<FormState> _scaffoldKey = new GlobalKey<FormState>();

  GoogleMapController mapController;

  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();
  final uuid = new Uuid();
  final Function _addEvent;

  _EventEditorState(this._addEvent);

  Future<Null> selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 180)));
    if (picked != null && picked != _date) {
      setState(() {
        _date = picked;
      });
    }
  }

  Future<Null> selectTime(BuildContext context) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: _time);
    if (picked != null && picked != _time) {
      setState(() {
        _time = picked;
      });
    }
  }

  Future<LatLng> locate(String addr) async {
    if (addr != null && addr.length > 5) {
      List<Placemark> placemark = await Geolocator().placemarkFromAddress(addr);
      if (placemark.length > 0) {
        return LatLng(
            placemark[0].position.latitude, placemark[0].position.longitude);
      }
    }
  }

  static String _fourDigits(int n) {
    int absN = n.abs();
    String sign = n < 0 ? "-" : "";
    if (absN >= 1000) return "$n";
    if (absN >= 100) return "${sign}0$absN";
    if (absN >= 10) return "${sign}00$absN";
    return "${sign}000$absN";
  }

  static String _threeDigits(int n) {
    if (n >= 100) return "${n}";
    if (n >= 10) return "0${n}";
    return "00${n}";
  }

  static String _twoDigits(int n) {
    if (n >= 10) return "${n}";
    return "0${n}";
  }

  static String toAWSDateTimeString(DateTime dt) {
    var utc = dt.toUtc();
    String y = _fourDigits(utc.year);
    String m = _twoDigits(utc.month);
    String d = _twoDigits(utc.day);
    String h = _twoDigits(utc.hour);
    String min = _twoDigits(utc.minute);
    String sec = _twoDigits(utc.second);
    String ms = _threeDigits(utc.millisecond);
    if (utc.isUtc) {
      return "$y-$m-${d}T$h:$min:$sec.${ms}Z";
    } else {
      return "$y-$m-${d}T$h:$min:$sec.$ms+1";
    }
  }

  Widget _buildConfigurationSender(BuildContext context) {
    return ListView(
      children: <Widget>[
        Center(
          child: SizedBox(
            width: 300.0,
            height: 200.0,
            child: GoogleMap(
              onMapCreated: _onMapCreated,
            ),
          ),
        ),
        Form(
            key: _scaffoldKey,
            child: new Padding(
              padding: const EdgeInsets.all(32.0),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                      child: const Text('Go to ..'),
                      onPressed: mapController == null
                          ? null
                          : () {
                              locate(whereTextEditingController.text)
                                  .then((dynamic v) {
                                mapController.animateCamera(
                                    CameraUpdate.newCameraPosition(
                                        CameraPosition(
                                  bearing: 270.0,
                                  target: v,
                                  tilt: 30.0,
                                  zoom: 17.0,
                                )));
                              });
                            }),
                  new TextFormField(
                    controller: nameTextEditingController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter event name',
                    ),
                  ),
                  new SizedBox(height: 16.0),
                  _DateTimePicker(
                    labelText: 'Start of event',
                    selectedDate: _date,
                    selectedTime: _time,
                    selectDate: (DateTime date) {
                      setState(() {
                        _date = date;
                      });
                    },
                    selectTime: (TimeOfDay time) {
                      setState(() {
                        _time = time;
                      });
                    },
                  ),
                  new SizedBox(height: 16.0),
                  new TextFormField(
                    controller: whereTextEditingController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter event start location',
                      labelText: 'Start Addr',
                    ),
                  ),
                  new TextFormField(
                    controller: distanceTextEditingController1,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Distance to ride during the event',
                      labelText: 'Distance',
                    ),
                  ),
                  new TextFormField(
                    controller: kommotTextEditingController1,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                    },
                    decoration: InputDecoration(
                        hintText: 'Enter komoot link', labelText: 'Track URL'),
                  ),
                  new SizedBox(height: 16.0),
                  new RaisedButton(child: Text('show map'), onPressed: () {}),
                  new RaisedButton(
                    child: Text("Add new Event"),
                    onPressed: () {
                      if (_scaffoldKey.currentState.validate()) {
                        // If the form is valid, we want to show a Snackbar
                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text('Processing Data')));

                        locate(whereTextEditingController.text)
                            .then((LatLng v) {
                          var event = Event(
                              name: nameTextEditingController.value.text,
                              where: whereTextEditingController.value.text,
                              distance: double.parse(
                                  distanceTextEditingController1.value.text),
                              komoot: kommotTextEditingController1.value.text,
                              plannedAvg: 22,
                              intensity: 1,
                              discipline: 'road',
                              startingTime: toAWSDateTimeString(_date),
                              description: descriptionTimeTextEditingController
                                  .value.text,
                              id: uuid.v1(),
                              lat: v.latitude,
                              lon: v.longitude);
                          _addEvent(event);
                        });
                        Navigator.pop(context);
                      }

//                  setState(() {
//                    if (nameTextEditingController.text.isEmpty) {
//                      final snackBar = SnackBar(
//                          content:
//                              Text('Error, your tour description is empty'));
//                      _scaffoldKey.currentState.showSnackBar(snackBar);
//                      return;
//                    }
////                _sender = nameTextEditingController.text;
////                nameTextEditingController.clear();
//                    Navigator.pop(context);
//                  });
                    },
                  ),
                ],
              ),
            ))
      ],
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Create a new event')),
        body: Builder(
          builder: (BuildContext context) {
            return _buildConfigurationSender(context);
          },
        ));
  }

  _printLatestValue() {
    locate(whereTextEditingController.text).then((ll) {
      print(
          "Second text field: ${whereTextEditingController.text} ${ll.toString()}");
    });
  }

  @override
  void initState() {
    super.initState();

    // Start listening to changes
    whereTextEditingController.addListener(_printLatestValue);
  }
}
