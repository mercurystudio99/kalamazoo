import 'dart:collection';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:kalamazoo/utils/navigation_router.dart';
import 'package:kalamazoo/utils/util.dart';
import 'package:kalamazoo/utils/color.dart';
import 'package:kalamazoo/utils/constants.dart';
import 'package:kalamazoo/models/app_model.dart';

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
  List<String> banners = [];
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime(kToday.year, kToday.month, kToday.day);
  DateTime? _selectedDay;

  late final Map<DateTime, List<Event>> _kEventSource = {};

  int carouselIndicatorCurrent = 0;

  @override
  void initState() {
    super.initState();
    _getBanners();
    _getEvents(_focusedDay);
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    kEvents.clear();
    banners.clear();
    super.dispose();
  }

  void _getBanners() {
    AppModel().getEventBanners(
      onSuccess: (List<String> param) {
        banners = param;
        setState(() {});
      },
    );
  }

  void _getEvents(DateTime day) {
    AppModel().getEventForMonth(
      year: day.year.toString(),
      month: day.month.toString(),
      onSuccess: (List<Map<String, dynamic>> param) {
        _kEventSource.clear();
        for (var element in param) {
          var date = DateTime.fromMillisecondsSinceEpoch(
              element[EVENT_MILLISECONDS],
              isUtc: true);
          if (_kEventSource[date] != null) {
            _kEventSource[date]?.add(Event(
                eventTitle: element[EVENT_TITLE],
                eventDesc: element[EVENT_DESC],
                r: getRandomInt(0, 255),
                g: getRandomInt(0, 255),
                b: getRandomInt(0, 255)));
          } else {
            _kEventSource[date] = [
              Event(
                eventTitle: element[EVENT_TITLE],
                eventDesc: element[EVENT_DESC],
                r: getRandomInt(0, 255),
                g: getRandomInt(0, 255),
                b: getRandomInt(0, 255),
              )
            ];
          }
          kEvents.addAll(_kEventSource);
        }
        setState(() {});
      },
    );
  }

  int getRandomInt(int min, int max) {
    final random = Random();
    int number = min + random.nextInt(max - min + 1);
    return number;
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

  @override
  Widget build(BuildContext context) {
    final List<Widget> imageSliders = banners
        .map((item) => Container(
            margin: const EdgeInsets.all(5.0),
            decoration: const BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Image.network(item,
                  width:
                      MediaQuery.of(context).size.width - 4 * Util.mainPadding,
                  fit: BoxFit.contain),
            )))
        .toList();

    return Scaffold(
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
              Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Util.mainPadding * 0.5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: CustomColor.primaryColor,
                        ),
                        onPressed: () {
                          NavigationRouter.back(context);
                        },
                      ),
                      const Text('Event',
                          style: TextStyle(
                              color: CustomColor.primaryColor, fontSize: 22)),
                      const SizedBox(width: Util.mainPadding)
                    ],
                  )),
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
                children: banners.asMap().entries.map((entry) {
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
                  _getEvents(_focusedDay);
                },
                calendarBuilders: CalendarBuilders(
                  singleMarkerBuilder: (context, date, event) {
                    Color color = Color.fromRGBO(event.r, event.g, event.b, 1);
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
                        var splitted = value[index].toString().split('&@&');
                        return Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: Util.mainPadding,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(
                                    int.parse(splitted[2]),
                                    int.parse(splitted[3]),
                                    int.parse(splitted[4]),
                                    0.1)),
                            child: Row(children: [
                              Container(
                                  width: 5,
                                  height: 50,
                                  color: Color.fromRGBO(
                                      int.parse(splitted[2]),
                                      int.parse(splitted[3]),
                                      int.parse(splitted[4]),
                                      1)),
                              const SizedBox(width: 20),
                              Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(splitted[0],
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    int.parse(splitted[2]),
                                                    int.parse(splitted[3]),
                                                    int.parse(splitted[4]),
                                                    1))),
                                        Text(
                                          splitted[1],
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  int.parse(splitted[2]),
                                                  int.parse(splitted[3]),
                                                  int.parse(splitted[4]),
                                                  1),
                                              fontWeight: FontWeight.bold),
                                        )
                                      ]))
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
}

class Event {
  final String eventTitle;
  final String eventDesc;
  final int r;
  final int g;
  final int b;

  Event({
    required this.eventTitle,
    required this.eventDesc,
    required this.r,
    required this.g,
    required this.b,
  });

  @override
  String toString() => '$eventTitle&@&$eventDesc&@&$r&@&$g&@&$b';
}
