import 'dart:developer';
import 'package:googleapis/bigquery/v2.dart';
import "package:googleapis_auth/auth_io.dart";
import 'package:googleapis/calendar/v3.dart';
import 'package:url_launcher/url_launcher.dart';

class EventService {
  static const _scopes = const [CalendarApi.CalendarScope];

  insert(title, startTime, endTime, description, location) {
    var _clientID = new ClientId(
        "594890504054-0j7i01kad44d4f1f31tj08qj17mmgmoc.apps.googleusercontent.com",
        "");
    clientViaUserConsent(_clientID, _scopes, prompt).then((AuthClient client) {
      var calendar = CalendarApi(client);
      calendar.calendarList.list().then((value) => print("VAL________$value"));

      String calendarId = "primary";

      //created event object
      Event event = Event();

      //added event title
      event.summary = title;

      //added event location
      event.location = location;

      //added event description
      event.description = description;

      //creating reminder for email
      EventReminder _eventReminder1 = new EventReminder();
      _eventReminder1.method = "email";
      _eventReminder1.minutes = 60;

      //creating reminder for popup notification of google calendar
      EventReminder _eventReminder2 = new EventReminder();
      _eventReminder2.method = "popup";
      _eventReminder2.minutes = 60;

      //added remiders
      EventReminders _reminders = new EventReminders();
      _reminders.useDefault = false;
      _reminders.overrides = [_eventReminder1, _eventReminder2];
      event.reminders = _reminders;

      //added event start time
      EventDateTime start = new EventDateTime();
      start.dateTime = startTime;
      start.timeZone = "GMT+05:30";
      event.start = start;

      //addded event end time
      EventDateTime end = new EventDateTime();
      end.timeZone = "GMT+05:30";
      end.dateTime = endTime;
      event.end = end;

      try {
        calendar.events.insert(event, calendarId).then((value) {
          print("ADDEDDD_________________${value.status}");
          if (value.status == "confirmed") {
            log('Event added in google calendar');
          } else {
            log("Unable to add event in google calendar");
          }
        });
      } catch (e) {
        log('Error creating event $e');
      }
    });
  }

  void prompt(String url) async {
    print("Please go to the following URL and grant access:");
    print("  => $url");
    print("");

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
