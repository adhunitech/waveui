import 'package:example/sample/widgets.dart';
import 'package:waveui/waveui.dart';

///标签选择view
class CalendarViewExample extends StatefulWidget {
  final String _title;

  const CalendarViewExample(this._title, {super.key});

  @override
  State<StatefulWidget> createState() => TagViewExamplePageState();
}

class TagViewExamplePageState extends State<CalendarViewExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: WaveAppBar(
          title: widget._title,
        ),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: <Widget>[
              const Text('Single selection-no control-week view'),
              _calendarViewWeekNocontrol(context),
              const WaveLine(
                height: 40.0,
              ),
              const Text('Single selection-no control-week view-custom WeekName'),
              _calendarViewWeekNocontrollCustomWeekName(context),
              const WaveLine(
                height: 40.0,
              ),
              const Text('Single selection-week view'),
              _calendarViewWeek(context),
              const WaveLine(
                height: 40.0,
              ),
              const Text('Range selection-week view'),
              _calendarViewWeekRange(context),
              const WaveLine(
                height: 40.0,
              ),
              const Text('single-selection-month view'),
              _calendarViewMonth(context),
              const WaveLine(
                height: 40.0,
              ),
              const Text('Range Selection-Month View'),
              _calendarViewMonthRange(context),
            ],
          ),
        ));
  }

  Widget _calendarViewWeekNocontrol(context) {
    return WaveCalendarView.single(
      displayMode: DisplayMode.week,
      showControllerBar: false,
      dateChange: (date) {
        showSnackBar(context, msg: 'Selected time: $date');
      },
    );
  }

  Widget _calendarViewWeekNocontrollCustomWeekName(context) {
    return WaveCalendarView.single(
      displayMode: DisplayMode.week,
      showControllerBar: false,
      weekNames: const ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'],
      dateChange: (date) {
        showSnackBar(context, msg: 'Selected time: $date');
      },
    );
  }

  Widget _calendarViewWeek(context) {
    return WaveCalendarView.single(
      displayMode: DisplayMode.week,
      initDisplayDate: DateTime.parse('2020-06-01'),
      minDate: DateTime(2020),
      maxDate: DateTime(2021),
      dateChange: (date) {
        showSnackBar(context, msg: '选中的时间： $date');
      },
    );
  }

  Widget _calendarViewWeekRange(context) {
    return WaveCalendarView.range(
      displayMode: DisplayMode.week,
      rangeDateChange: (rangeDate) {
        showSnackBar(
          context,
          msg: 'Start time: ${rangeDate.start} , end time: ${rangeDate.end}',
        );
      },
    );
  }

  Widget _calendarViewMonth(context) {
    return WaveCalendarView.single(
      initDisplayDate: DateTime.parse('2020-06-01'),
      minDate: DateTime(2020),
      maxDate: DateTime(2021),
      dateChange: (date) {
        showSnackBar(context, msg: 'Selected time: $date');
      },
    );
  }

  Widget _calendarViewMonthRange(context) {
    return WaveCalendarView.range(
      minDate: DateTime(2020),
      maxDate: DateTime(2023),
      rangeDateChange: (rangeDate) {
        showSnackBar(
          context,
          msg: 'Start time: ${rangeDate.start} , end time: ${rangeDate.end}',
        );
      },
    );
  }
}
