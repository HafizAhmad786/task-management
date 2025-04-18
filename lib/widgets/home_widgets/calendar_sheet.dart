import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tgo_todo/components/k_buttons.dart';
import 'package:tgo_todo/provider/home_page_provider.dart';
import 'package:tgo_todo/utills/file_indexes.dart';

class CalendarSheet {
  static void calendar({
    required BuildContext context,
    required String title,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      backgroundColor: AppColor.whiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        final mQ = MediaQuery.sizeOf(context);
        return SizedBox(
          height: mQ.height *0.7 ,
          width: mQ.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal:  8.0,vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 5,
                    width: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColor.lightGreyColor,
                      borderRadius: BorderRadius.circular(
                       12
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    showSvgIconWidget(iconPath: AppIcons.clockIcon, context: context),
                    Text('Select Due Date'),
                  ],
                ),
                Divider(color: AppColor.lightGreyColor,),
                SizedBox(height: 20,),
                ///show a calendar widget here
                Consumer<HomePageProvider>(
                  builder: (context, provider, child) {
                    return TableCalendar(
                      firstDay: DateTime.utc(2000, 1, 1),
                      lastDay: DateTime.utc(2100, 12, 31),
                      focusedDay: provider.focusedDate,
                      selectedDayPredicate: (day) =>
                          isSameDay(provider.selectedDate, day),
                      onDaySelected: (selectedDay, focusedDay) {
                        provider.setSelectedDate(selectedDay);
                      },
                      calendarStyle: const CalendarStyle(
                        todayDecoration: BoxDecoration(
                          color: Colors.blueAccent,
                          shape: BoxShape.circle,
                        ),
                        selectedDecoration: BoxDecoration(
                          color: Colors.deepPurple,
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  },
                ),
                Spacer(),
                Row(
                  spacing: 10,
                  children: [
                  Expanded(
                    child: kTextButton(
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                      height: 50,
                      btnText: 'Back',
                      color: AppColor.greyColor.withValues(alpha: 0.4),
                      textColor: AppColor.lightPrimary,
                    ),
                  ),
                  Expanded(
                    child: kTextButton(
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                      height: 50,
                      btnText: 'Next',
                      color: AppColor.lightPrimary,
                      textColor: AppColor.whiteColor,
                    ),
                  ),

                ],)
              ],
            ),
          ),
        );
      },
    );
  }



}