import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tgo_todo/components/k_buttons.dart';
import 'package:tgo_todo/provider/home_page_provider.dart';
import 'package:tgo_todo/utills/file_indexes.dart';

class TimeSheet {
  static void time({required BuildContext context}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (_, controller) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Container(width: 40, height: 4, color: Colors.grey[300])),
                  const SizedBox(height: 10),
                  Center(
                    child: Column(
                      children: [
                        Text(DateFormat("EEEE").format(DateTime.now()), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(DateFormat("MMM dd, yyyy").format(DateTime.now()), style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Consumer<HomePageProvider>(
                        builder: (context, provider, child) {
                          return ToggleButtons(
                            isSelected: provider.isSelected,
                            onPressed: provider.selectedFormat,
                            borderRadius: BorderRadius.circular(8),
                            selectedColor: Colors.white,
                            fillColor: Colors.orange,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: Text("12h"),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: Text("24h"),
                              ),
                            ],
                          );
                        },
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.language, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        "Indian Standard Time (UTC+05:30)",
                        style: kTextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down_outlined,
                        size: 15,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: Consumer<HomePageProvider>(
                      builder: (context, provider, _) {
                        return ListView.builder(
                          controller: controller,
                          itemCount: 16,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () => provider.currentIndex(index),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        decoration: BoxDecoration(
                                          color: provider.selectedIndex == index ? Colors.black : Colors.grey[200],
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          provider.format == 1 ? provider.twentyFourHourTimes[index] : provider.twentyHourTimes[index],
                                          style: TextStyle(
                                            color: provider.selectedIndex == index ? Colors.white : Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (provider.selectedIndex == index) ...[
                                      const SizedBox(width: 8),
                                      kTextButton(
                                        onPressed: () => provider.confirmTime(index),
                                        textColor: Colors.white,
                                        height: 44,
                                        fontSize: 12,
                                        color: AppColor.lightPrimary,
                                        btnText: provider.time.isNotEmpty ? "Confirmed" : "Confirm",
                                      ),
                                    ]
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: kTextButton(
                          onPressed: () => Navigator.pop(context),
                          textColor: AppColor.lightPrimary,
                          height: 50,
                          fontSize: 12,
                          borderColor: AppColor.lightPrimary,
                          color: Colors.white,
                          btnText: "Back",
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: kTextButton(
                          onPressed: () {
                            final homeProvider = Provider.of<HomePageProvider>(context, listen: false);
                            if(homeProvider.time.isEmpty){
                              Fluttertoast.showToast(msg: "Please select your time");
                            }else{
                              Navigator.of(context).pop();
                            }
                          },
                          textColor: Colors.white,
                          height: 50,
                          fontSize: 12,
                          color: AppColor.lightPrimary,
                          btnText: "Next",
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
