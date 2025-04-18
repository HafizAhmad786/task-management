import 'package:provider/provider.dart';
import 'package:tgo_todo/provider/calendar_provider.dart';
import 'package:tgo_todo/utills/file_indexes.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:tgo_todo/widgets/home_widgets/task_container.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<CalendarProvider>(context,listen: false).getTasks(context);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CalendarProvider>(context);

    // Filter tasks for selected date
    final selectedTasks = provider.tasks
        .where((task) =>
            task.date!.year == provider.selectedDateTime.year &&
            task.date!.month == provider.selectedDateTime.month &&
            task.date!.day == provider.selectedDateTime.day)
        .toList();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 16),
              Text('Select Date', style: kTextStyle(fontSize: 20)),
              const SizedBox(height: 12),
              EasyDateTimeLinePicker(
                firstDate: DateTime(2025, 1, 1),
                lastDate: DateTime(2030, 3, 18),
                focusedDate: provider.selectedDateTime,
                onDateChange: (date) {
                  provider.updateDate(date);
                },
                timelineOptions: const TimelineOptions(
                  height: 100,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
              const SizedBox(height: 16),
              if (selectedTasks.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text('No tasks for this day.'),
                ),
              ListView.builder(
                itemCount: selectedTasks.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final task = selectedTasks[index];
                  return TaskContainer(
                    task: task,
                    index: index, isCalendar: true,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
