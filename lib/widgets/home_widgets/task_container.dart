import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tgo_todo/model/task_model.dart';
import 'package:tgo_todo/provider/calendar_provider.dart';
import 'package:tgo_todo/provider/home_page_provider.dart';
import 'package:tgo_todo/provider/task_providerBase.dart';
import 'package:tgo_todo/utills/file_indexes.dart';

class TaskContainer extends StatelessWidget {
  final int index;
  final TaskModel task;
  final bool isCalendar;
  const TaskContainer({super.key,required this.task, required this.index, required this.isCalendar});

  @override
  Widget build(BuildContext context) {

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              color: task.priority == 'High'
                  ? AppColor.red
                  : task.priority == 'Medium'
                  ? AppColor.yellow
                  : AppColor.green,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Row(
                    spacing: 5,
                    children: [
                      showSvgIconWidget(iconPath: AppIcons.flag, context: context,color: Colors.white),
                      Text(task.priority.toString(),style: kTextStyle(color: Colors.white),),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  color: Colors.white,
                  iconColor: Colors.white,
                  onSelected: (value) {
                    // var provider = isCalendar == true ? Provider.of<CalendarProvider>(context,listen: false) : Provider.of<HomePageProvider>(context,listen: false);
                    var provider = isCalendar == true
                        ? Provider.of<CalendarProvider>(context, listen: false) as TaskProviderBase
                        : Provider.of<HomePageProvider>(context, listen: false) as TaskProviderBase;

                    if (value == 'edit') {
                      provider.addNewTask(context, "Todo",task: task);
                      // homeProvider.addOrEditTask(context, task.title ?? "", task.description ?? "",task.taskId ?? "",taskData: task);
                    } else if (value == 'delete') {
                      provider.removeTask(context, task.taskId ?? "",index);
                      // TODO: Add delete logic
                    }
                  },
                  itemBuilder: (BuildContext context) => [
                    const PopupMenuItem<String>(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 18),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 18),
                          SizedBox(width: 8),
                          Text('Delete'),
                        ],
                      ),
                    ),
                  ],
                  icon: const Icon(Icons.more_horiz),
                ),
              ],
            ),

          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  spacing: 10,
                  children: [
                    showSvgIconWidget(iconPath: AppIcons.liveIcon, context: context),
                    Text(task.title.toString(),style: kTextStyle(),),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Text(task.type ?? "",style: kTextStyle(color: Colors.white),),
                    )
                  ],),
                SizedBox(height: 10,),
                Text(
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  task.description.toString(),style: kTextStyle(fontSize: 12,color: AppColor.greyText),),
                SizedBox(height: 50,),
                Divider(color: AppColor.lightGreyColor,),
                Row(
                  spacing: 10,
                  children: [
                    showSvgIconWidget(iconPath: AppIcons.alarmIcon, context: context),
                    Text(task.time.toString(),style: kTextStyle(),),
                    Spacer(),
                    Text(DateFormat("EEEE, dd, MMM yyyy").format(task.date!),style: kTextStyle(fontSize: 12,color: AppColor.greyText),),
                  ],),
              ],),
          )

        ],
      ),
    );
  }
}
