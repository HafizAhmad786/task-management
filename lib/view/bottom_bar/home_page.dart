import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:provider/provider.dart';
import 'package:tgo_todo/components/custom_text_field.dart';
import 'package:tgo_todo/provider/home_page_provider.dart';
import 'package:tgo_todo/widgets/home_widgets/task_container.dart';
import 'package:tgo_todo/utills/file_indexes.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
      if(mounted) Provider.of<HomePageProvider>(context, listen: false).getAllTasks(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<HomePageProvider>(context, listen: true);
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15),
                Text(
                  'Today',
                  style: kTextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                ),
                Text(
                  provider.formattedDate,
                  style: kTextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: AppColor.greyText),
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.greyText.withValues(alpha: 0.2),
                        spreadRadius: 0,
                        blurRadius: 40,
                        offset: const Offset(0, 4), // changes position of shadow
                      ),
                    ],
                  ),
                  child: GetTextField(
                    context: context,
                    obSecureText: false,
                    onChanged: (val) {
                      provider.filterTasks(val);
                    },
                    hintText: 'Search Task',
                    prefixIcon: AppIcons.searchIcon,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  spacing: 8,
                  children: [
                    Expanded(
                      child: TabBar(
                        padding: const EdgeInsets.only(bottom: 15),
                        indicator: BoxDecoration(
                          color: AppColor.lightPrimary, // orange selected tab
                          borderRadius: BorderRadius.circular(12),
                        ),
                        splashBorderRadius: BorderRadius.circular(12),
                        splashFactory: NoSplash.splashFactory,
                        labelColor: AppColor.whiteColor,
                        unselectedLabelColor: AppColor.greyText,
                        labelStyle: kTextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        unselectedLabelStyle: kTextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        dividerColor: Colors.transparent,
                        indicatorSize: TabBarIndicatorSize.tab,
                        tabs: const [
                          Tab(text: 'To-Do'),
                          Tab(text: 'Habit'),
                          Tab(text: 'Journal'),
                          Tab(text: 'Note'),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: showSvgIconWidget(height: 45, width: 45, iconPath: AppIcons.filterIcon, context: context,color: Colors.transparent),
                    ),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      Consumer<HomePageProvider>(
                        builder: (context, provider, _) {
                          return provider.filteredTasks.isNotEmpty
                              ? ListView.builder(
                                  itemCount: provider.filteredTasks.length,
                                  itemBuilder: (context, index) {
                                    var task = provider.filteredTasks[index];
                                    return TaskContainer(
                                      task: task,
                                      index: index,
                                      isCalendar: false,
                                    );
                                  },
                                )
                              : Align(
                                  alignment: Alignment.topCenter,
                                  child: Image(image: AssetImage(AppImages.noTaskImage)),
                                );
                        },
                      ),
                      Align(alignment: Alignment.topCenter, child: Image(image: AssetImage(AppImages.noTaskImage))),
                      Align(alignment: Alignment.topCenter, child: Image(image: AssetImage(AppImages.noTaskImage))),
                      Align(alignment: Alignment.topCenter, child: Image(image: AssetImage(AppImages.noTaskImage)))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: ExpandableFab.location,
        floatingActionButton: ExpandableFab(
          openButtonBuilder: DefaultFloatingActionButtonBuilder(
            backgroundColor: AppColor.lightPrimary,
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
          closeButtonBuilder: DefaultFloatingActionButtonBuilder(
            backgroundColor: AppColor.lightPrimary,
            child: Icon(
              Icons.close,
              color: Colors.white,
            ),
          ),
          distance: 60,
          type: ExpandableFabType.up,
          children: [
            CustomFloatingButton(
                text: "Add Todo",
                backgroundColor: AppColor.lightPrimary,
                borderColor: Colors.white,
                onPressed: () {
                  provider.addNewTask(context, "Todo");
                }),
            CustomFloatingButton(
                text: "Add Note",
                backgroundColor: AppColor.lightPrimary,
                borderColor: Colors.white,
                onPressed: () => provider.addNewTask(context, "Note")),
            CustomFloatingButton(
                text: "Add List",
                backgroundColor: AppColor.lightPrimary,
                borderColor: Colors.white,
                onPressed: () => provider.addNewTask(context, "List")),
            CustomFloatingButton(
                text: "Setup Habit",
                backgroundColor: Colors.white,
                borderColor: AppColor.lightPrimary,
                onPressed: () => provider.addNewTask(context, "Habit")),
            CustomFloatingButton(
                text: "Setup Journal",
                backgroundColor: Colors.white,
                borderColor: AppColor.lightPrimary,
                onPressed: () => provider.addNewTask(context, "Journal")),
          ],
        ),
      ),
    );
  }
}

class CustomFloatingButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color borderColor;
  final VoidCallback onPressed;

  const CustomFloatingButton({super.key, required this.text, required this.backgroundColor, required this.onPressed, required this.borderColor});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      elevation: 0,
      highlightElevation: 0,
      backgroundColor: Colors.transparent,
      heroTag: null,
      label: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: backgroundColor, border: Border.all(color: borderColor)),
        child: Text(
          text,
          style: kTextStyle(
              fontSize: 14, fontWeight: FontWeight.w500, color: backgroundColor == AppColor.lightPrimary ? Colors.white : AppColor.lightPrimary),
        ),
      ),
      onPressed: onPressed,
    );
  }
}
