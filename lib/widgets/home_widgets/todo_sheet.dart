import 'package:provider/provider.dart';
import 'package:tgo_todo/components/custom_text_field.dart';
import 'package:tgo_todo/model/task_model.dart';
import 'package:tgo_todo/provider/calendar_provider.dart';
import 'package:tgo_todo/provider/home_page_provider.dart';
import 'package:tgo_todo/provider/task_providerBase.dart';
import 'package:tgo_todo/utills/file_indexes.dart';
import 'package:tgo_todo/widgets/home_widgets/calendar_sheet.dart';
import 'package:tgo_todo/widgets/home_widgets/time_sheet.dart';

class TodoSheet {
  static void todo({
    required BuildContext context,
    required String taskName,
    required bool isCalender,
    TaskModel? task,
    double heightFactor = 0.4,
  }) {
    var formKey = GlobalKey<FormState>();

    final titleController = TextEditingController(text: task?.title ?? '');
    final descriptionController = TextEditingController(text: task?.description ?? '');

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      isScrollControlled: true,
      isDismissible: false,
      backgroundColor: AppColor.whiteColor,
      builder: (BuildContext context) {
        final mQ = MediaQuery.sizeOf(context);
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          // height: context.isKeyboardVisible ? mQ.height * 0.7 : mQ.height * heightFactor,
          width: mQ.width,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 50,
                  width: mQ.width,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColor.lightPrimary,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Text(
                    "New $taskName",
                    textAlign: TextAlign.center,
                    style: kTextStyle(
                      fontSize: 15,
                      color: AppColor.whiteColor,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                _buildTextField(context: context, controller: titleController, hintText: 'e.g: Meeting with John', addValidation: true),
                _buildTextField(context: context, controller: descriptionController, hintText: 'Description', maxLines: 2),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    spacing: 8,
                    children: [
                      showSvgIconWidget(
                          onTap: () {
                            CalendarSheet.calendar(context: context, title: 'Select Date');
                          },
                          iconPath: AppIcons.calendarIcon,
                          context: context),
                      const SizedBox(
                        width: 5,
                      ),
                      showSvgIconWidget(
                          onTap: () {
                            TimeSheet.time(context: context);
                          },
                          iconPath: AppIcons.clockIcon,
                          context: context),
                      Consumer<HomePageProvider>(
                        builder: (context, provider, child) {
                          return PopupMenuButton<Priority>(
                            color: AppColor.whiteColor,
                            position: PopupMenuPosition.under,
                            padding: EdgeInsets.zero,
                            icon: SvgPicture.asset(
                              AppIcons.flagIcon,
                            ),
                            onSelected: (priority) {
                              provider.setPriority(priority);
                            },
                            itemBuilder: (BuildContext context) => [
                              PopupMenuItem(
                                value: Priority.high,
                                child: Text('⚠️  High Priority'),
                              ),
                              PopupMenuItem(
                                value: Priority.medium,
                                child: Text('⏳  Medium Priority'),
                              ),
                              PopupMenuItem(
                                value: Priority.low,
                                child: Text('✅  Low Priority'),
                              ),
                            ],
                          );
                        },
                      ),
                      Spacer(),
                      showSvgIconWidget(
                          onTap: () async {
                            var provider = isCalender == true
                                ? Provider.of<CalendarProvider>(context, listen: false) as TaskProviderBase
                                : Provider.of<HomePageProvider>(context, listen: false) as TaskProviderBase;
                            if (formKey.currentState!.validate()) {
                              if (task != null && task.toJson().isNotEmpty) {
                                await provider.addOrEditTask(context, titleController.text, descriptionController.text, task.taskId ?? "",
                                    taskData: task);
                              } else {
                                await provider.addOrEditTask(context, titleController.text, descriptionController.text, "");
                                titleController.clear();
                                descriptionController.clear();
                              }
                            }
                          },
                          iconPath: AppIcons.sendIcon,
                          context: context)
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget _buildTextField(
      {final TextEditingController? controller, required BuildContext context, required String hintText, final int? maxLines, bool? addValidation}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: GetTextField(
        controller: controller,
        context: context,
        hintText: hintText,
        obSecureText: false,
        maxLines: maxLines ?? 1,
        validator: addValidation == true
            ? (val) {
                if (val!.isEmpty) {
                  return "Please fill this field";
                }
                return null;
              }
            : null,
      ),
    );
  }
}
