// main.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Calendar',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      debugShowCheckedModeBanner: false,
      home: CalendarScreen(),
    );
  }
}

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _currentMonth = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  // Padding customization for event list
  final double eventPadding = 16.0; // Adjust this value as needed

  // Sample event data
  List<Map<String, String>> _events = [
    {'time': '9:00 AM', 'event': 'Morning Exercises'},
    {'time': '11:30 PM', 'event': 'Time To Sleep'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          _buildGradientAppBar(),
          SizedBox(height: 0),
          _buildCalendarContainer(),
          Expanded(child: _buildEventList()),
        ],
      ),
    );
  }

  Widget _buildGradientAppBar() {
    return Container(
      padding: EdgeInsets.only(top: 70.0, bottom: 50.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF9C19F4), Colors.pinkAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 32,
              color: Colors.white,
              fontStyle: FontStyle.italic,
            ),
            children: [
              TextSpan(
                text: 'S',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
              TextSpan(text: 'mart '),
              TextSpan(
                text: 'C',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
              TextSpan(text: 'alendar'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarContainer() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 60.0),
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          _buildMonthYearHeader(),
          _buildDaysOfWeek(),
          _buildCalendarGrid(),
        ],
      ),
    );
  }

  Widget _buildMonthYearHeader() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              setState(() {
                _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
              });
            },
          ),
          Flexible(
            child: Text(
              DateFormat('MMMM yyyy').format(_currentMonth), // No capitalization
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis, // Prevents overflow issue
            ),
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward_ios),
            onPressed: () {
              setState(() {
                _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDaysOfWeek() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
      child: Row(
        children: <Widget>[
          for (var day in ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'])
            Expanded(
              child: Center(
                child: Text(
                  day,
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    int daysInMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
    int firstDayOfWeek = DateTime(_currentMonth.year, _currentMonth.month, 1).weekday;
    int prevMonthDays = DateTime(_currentMonth.year, _currentMonth.month, 0).day;
    int totalCells = (firstDayOfWeek - 1) + daysInMonth;
    int nextMonthDays = 7 - (totalCells % 7);

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
      ),
      itemCount: totalCells + (nextMonthDays == 7 ? 0 : nextMonthDays),
      itemBuilder: (context, index) {
        if (index < firstDayOfWeek - 1) {
          int day = prevMonthDays - (firstDayOfWeek - 2) + index;
          return _buildDayCell(day, isFaded: true);
        } else if (index >= firstDayOfWeek - 1 + daysInMonth) {
          int day = index - (firstDayOfWeek - 1) - daysInMonth + 1;
          return _buildDayCell(day, isFaded: true);
        } else {
          int day = index - (firstDayOfWeek - 2);
          return _buildDayCell(day);
        }
      },
    );
  }

  Widget _buildDayCell(int day, {bool isFaded = false}) {
    bool isSelected = _selectedDay == DateTime(_currentMonth.year, _currentMonth.month, day);
    return GestureDetector(
      onTap: isFaded
          ? null
          : () {
        setState(() {
          _selectedDay = DateTime(_currentMonth.year, _currentMonth.month, day);
        });
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? Colors.pink[300] : Colors.transparent,
        ),
        child: Center(
          child: Text(
            day.toString(),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w400,
              color: isFaded ? Colors.grey[400] : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEventList() {
    return ListView.builder(
      padding: const EdgeInsets.all(0.0),
      itemCount: _events.length,
      itemBuilder: (context, index) {
        var event = _events[index];
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 0.0, vertical: 1.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF9C19F4), Colors.pinkAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: eventPadding, vertical: 18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${event['event']}',
                  style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 19),
                ),
                Text(
                  '${event['time']}',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
