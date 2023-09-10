import 'dart:collection';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:kalamazoo/utils/navigation_router.dart';
import 'package:kalamazoo/utils/util.dart';
import 'package:kalamazoo/utils/color.dart';

final List<Map<String, dynamic>> imgList = [
  {
    "title": Util.event,
    "image": "assets/burger.png",
    "bio": "Lorem ipsum dolor sit\n amet, consectetur adip\niscing elit.",
  },
  {
    "title": Util.event,
    "image": "assets/plate.png",
    "bio": "Lorem ipsum dolor sit\n amet, consectetur adip\niscing elit.",
  }
];

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year);
final kLastDay = DateTime(2050);

final kEvents = LinkedHashMap<DateTime, List<Event>>(
    equals: isSameDay, hashCode: getHashCode);

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  late final Map<DateTime, List<Event>> _kEventSource = {};

  int carouselIndicatorCurrent = 0;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    return kEvents[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _showAddEventDialog() async {
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('New Event'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildTextField(
                      controller: _titleController, hint: 'Enter Title'),
                  const SizedBox(
                    height: 20.0,
                  ),
                  buildTextField(
                      controller: _descController, hint: 'Enter Description'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    if (_titleController.text.isEmpty &&
                        _descController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter title & description'),
                          duration: Duration(seconds: 3),
                        ),
                      );
                      return;
                    } else {
                      setState(() {
                        if (_kEventSource[_selectedDay] != null) {
                          _kEventSource[_selectedDay]?.add(Event(
                              eventTitle: _titleController.text,
                              eventDesc: _descController.text,
                              eventColor: Colors.primaries[
                                  Random().nextInt(Colors.primaries.length)]));
                        } else {
                          _kEventSource[_selectedDay!] = [
                            Event(
                                eventTitle: _titleController.text,
                                eventDesc: _descController.text,
                                eventColor: Colors.primaries[
                                    Random().nextInt(Colors.primaries.length)])
                          ];
                        }
                        kEvents.addAll(_kEventSource);
                      });

                      _titleController.clear();
                      _descController.clear();

                      Navigator.pop(context);
                      return;
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> imageSliders = imgList
        .map((item) => Container(
              margin: const EdgeInsets.all(5.0),
              decoration: const BoxDecoration(
                color: Color(0xFFFFF9E5),
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: const BoxDecoration(
                            color: CustomColor.activeColor,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.zero,
                                topRight: Radius.zero,
                                bottomLeft: Radius.zero,
                                bottomRight: Radius.circular(100)),
                          ),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(5),
                          child: Row(children: [
                            const SizedBox(width: 30),
                            Image.asset(item["image"]),
                            const SizedBox(width: 10),
                            Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item["title"].toString().toUpperCase(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20)),
                                  RichText(
                                    text: TextSpan(children: [
                                      TextSpan(
                                        text: item["bio"],
                                        style: GoogleFonts.poppins(
                                            color: CustomColor.textDetailColor,
                                            fontSize: Util.descriptionSize),
                                      )
                                    ]),
                                  ),
                                ])
                          ]))
                    ],
                  )),
            ))
        .toList();

    return Scaffold(
      floatingActionButton: FloatingActionButton.small(
        onPressed: () => _showAddEventDialog(),
        backgroundColor: CustomColor.primaryColor,
        child: const Icon(Icons.add),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                'assets/background.svg',
                width: MediaQuery.of(context).size.width,
              ),
            ],
          ),
          ListView(
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Util.mainPadding * 0.5),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: CustomColor.primaryColor,
                    ),
                    onPressed: () {
                      NavigationRouter.back(context);
                    },
                  ),
                ),
              ),
              CarouselSlider(
                items: imageSliders,
                options: CarouselOptions(
                    aspectRatio: 2.0,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: false,
                    initialPage: 0,
                    autoPlay: true,
                    pageViewKey:
                        const PageStorageKey<String>('carousel_slider'),
                    onPageChanged: (index, reason) {
                      setState(() {
                        carouselIndicatorCurrent = index;
                      });
                    }),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: imgList.asMap().entries.map((entry) {
                  return Container(
                    width: (carouselIndicatorCurrent == entry.key ? 34 : 16),
                    height: 5.0,
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 4.0),
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        color: (carouselIndicatorCurrent == entry.key
                            ? CustomColor.primaryColor
                            : CustomColor.textDetailColor.withOpacity(0.5))),
                  );
                }).toList(),
              ),
              TableCalendar<Event>(
                firstDay: kFirstDay,
                lastDay: kLastDay,
                focusedDay: _focusedDay,
                availableCalendarFormats: const {CalendarFormat.month: 'Month'},
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                calendarFormat: _calendarFormat,
                eventLoader: _getEventsForDay,
                startingDayOfWeek: StartingDayOfWeek.sunday,
                headerStyle: HeaderStyle(
                  headerMargin: const EdgeInsets.symmetric(
                      horizontal: Util.mainPadding, vertical: 10),
                  titleCentered: true,
                  titleTextStyle: const TextStyle(
                      color: CustomColor.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                  leftChevronIcon:
                      const Icon(Icons.chevron_left, color: Colors.black45),
                  rightChevronIcon:
                      const Icon(Icons.chevron_right, color: Colors.black45),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: CustomColor.primaryColor.withOpacity(0.15),
                        blurRadius: 30.0,
                      ),
                    ],
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                  ),
                ),
                calendarStyle: CalendarStyle(
                  outsideDaysVisible: true,
                  tablePadding: const EdgeInsets.symmetric(
                      horizontal: Util.mainPadding, vertical: 5),
                  todayDecoration: BoxDecoration(
                      color: CustomColor.primaryColor.withOpacity(0.5),
                      shape: BoxShape.circle),
                  selectedDecoration: const BoxDecoration(
                      color: CustomColor.primaryColor, shape: BoxShape.circle),
                ),
                onDaySelected: _onDaySelected,
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
                calendarBuilders: CalendarBuilders(
                  singleMarkerBuilder: (context, date, event) {
                    Color color = event.eventColor;
                    return Container(
                      decoration:
                          BoxDecoration(shape: BoxShape.circle, color: color),
                      width: 7.0,
                      height: 7.0,
                      margin: const EdgeInsets.symmetric(horizontal: 1.5),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8.0),
              SizedBox(
                height: 200,
                child: ValueListenableBuilder<List<Event>>(
                  valueListenable: _selectedEvents,
                  builder: (context, value, _) {
                    return ListView.builder(
                      itemCount: value.length,
                      itemBuilder: (context, index) {
                        return Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: Util.mainPadding,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(color: Colors.black38),
                            child: Row(children: [
                              Container(
                                  width: 5, height: 30, color: Colors.black),
                              SizedBox(width: 20),
                              Column(children: [Text('${value[index]}')])
                            ]));
                      },
                    );
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget buildTextField(
      {String? hint, required TextEditingController controller}) {
    return TextField(
      controller: controller,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        labelText: hint ?? '',
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black, width: 1.5),
          borderRadius: BorderRadius.circular(
            10.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black, width: 1.5),
          borderRadius: BorderRadius.circular(
            10.0,
          ),
        ),
      ),
    );
  }
}

class Event {
  final String eventTitle;
  final String eventDesc;
  final Color eventColor;

  Event(
      {required this.eventTitle,
      required this.eventDesc,
      required this.eventColor});

  @override
  String toString() => eventTitle;
}
