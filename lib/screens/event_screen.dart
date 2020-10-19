import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:eventapp/services/event_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventScreen extends StatefulWidget {
  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  var _saveEvent = EventService();
  final format = DateFormat("yyyy-MM-dd HH:mm");
  final formKey = GlobalKey<FormState>();
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(Duration(days: 1));
  TextEditingController _eventNameController = TextEditingController();
  TextEditingController _eventLocationController = TextEditingController();
  TextEditingController _eventStartDateController = TextEditingController();
  TextEditingController _eventEndDateController = TextEditingController();
  TextEditingController _eventDiscriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Add An Event"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: _eventNameController,
                  keyboardType: TextInputType.text,
                  validator: (String val) {
                    if (val.isEmpty) {
                      return "Name can not be Empty";
                    } else if (val.length < 4) {
                      return ("Enter a Valid Name");
                    } else if (val.length > 20) {
                      return ("Should be less than 30 characters");
                    }
                  },
                  decoration: InputDecoration(
                      hintText: 'Event Title',
                      labelText: 'Title',
                      border: InputBorder.none,
                      icon: Icon(Icons.event)),
                ),
                TextFormField(
                  controller: _eventLocationController,
                  keyboardType: TextInputType.text,
                  validator: (String val) {
                    if (val.isEmpty) {
                      return "Location can not be Empty";
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Event Location',
                    labelText: 'Location',
                    border: InputBorder.none,
                    icon: Icon(Icons.location_on),
                  ),
                ),
                Text(
                  'Start Date & Time',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.blue),
                ),
                Container(
                  width: size.width * 0.8,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(29)),
                  child: DateTimeField(
                    keyboardType: TextInputType.datetime,
                    format: format,
                    controller: _eventStartDateController,
                    onShowPicker: (context, currentValue) async {
                      final date = await showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          initialDate: currentValue ?? DateTime.now(),
                          lastDate: DateTime(2100));
                      if (date != null) {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(
                              currentValue ?? DateTime.now()),
                        );
                        startDate = DateTimeField.combine(date, time);
                        return DateTimeField.combine(date, time);
                      } else {
                        return currentValue;
                      }
                    },
                  ),
                ),
                Text(
                  'End Date & Time',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.blue),
                ),
                Container(
                  width: size.width * 0.8,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(29)),
                  child: DateTimeField(
                    keyboardType: TextInputType.datetime,
                    controller: _eventEndDateController,
                    format: format,
                    onShowPicker: (context, currentValue) async {
                      final date = await showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          initialDate: currentValue ?? DateTime.now(),
                          lastDate: DateTime(2100));
                      if (date != null) {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(
                              currentValue ?? DateTime.now()),
                        );
                        endDate = DateTimeField.combine(date, time);
                        return DateTimeField.combine(date, time);
                      } else {
                        return currentValue;
                      }
                    },
                  ),
                ),
                TextFormField(
                  controller: _eventDiscriptionController,
                  keyboardType: TextInputType.multiline,
                  validator: (String val) {
                    if (val.isEmpty) {
                      return "Description can not be Empty";
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Event Discription',
                    labelText: 'Discription',
                    border: InputBorder.none,
                    icon: Icon(Icons.info),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  width: size.width * 0.8,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(29),
                    child: FlatButton(
                      color: Colors.blue,
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                      child: Text(
                        "Add Event",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        if (formKey.currentState.validate()) {
                          _saveEvent.insert(
                              _eventNameController.text,
                              startDate,
                              endDate,
                              _eventDiscriptionController.text,
                              _eventLocationController.text);
                        }
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
