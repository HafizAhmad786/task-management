import 'package:tgo_todo/utills/file_indexes.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 50,),
            Text('Notifications',style: kTextStyle(fontSize: 22,fontWeight: FontWeight.w600),),
            SizedBox(height: 30,),
            ListView.separated(
              itemCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (BuildContext context, int index) {  return SizedBox(height: 10,);},
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: AppColor.lightGreyColor,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  title: Text('Reminder',style: kTextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
                  subtitle: Text('Description',style: kTextStyle(color: AppColor.greyText),),
                );
              }, ),
          ],
        ),
      ),
    );
  }
}