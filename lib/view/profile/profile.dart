import 'package:provider/provider.dart';
import 'package:tgo_todo/provider/profile_provider.dart';
import 'package:tgo_todo/utills/file_indexes.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask((){
     if(mounted) Provider.of<ProfileProvider>(context,listen: false).getUserInfo(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfileProvider>(context);
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                color: AppColor.darkPrimary,
                height: MediaQuery.sizeOf(context).width * 0.30 + 50,
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    SizedBox(height: MediaQuery.sizeOf(context).width * 0.15),
                    Consumer<ProfileProvider>(
                      builder: (context,provider,_) => Text(
                        provider.userModel.displayName ?? 'John Doe',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Text(
                       'Marketing Manager',
                      textAlign: TextAlign.center,
                      style: kTextStyle(fontSize: 10, fontWeight: FontWeight.w400),
                    ),
                   SizedBox(height: 10,),
                      ListView.builder(
                        itemCount: provider.pages.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final item = provider.pages[index];
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              backgroundColor: AppColor.lightPrimary.withValues(alpha: 0.2),
                              child: showSvgIconWidget(iconPath: item.icon, context: context,),
                            ),
                            title: Text(
                              item.title,
                              style: kTextStyle(fontSize: 14,),
                            ),
                            trailing: IconButton(
                              onPressed: index == provider.pages.length -1 ? () async{
                                await provider.logout(context);
                              } : null,
                              icon: Icon(
                              Icons.arrow_forward,
                            ),)
                          );
                        },
                      )
                  ],
                ),
              ),
            ],
          ),
          // Profile picture container
          Positioned(
            top: MediaQuery.sizeOf(context).width * 0.50 * 0.5, // Adjust top to fit the avatar
            left: (MediaQuery.sizeOf(context).width / 2) - MediaQuery.sizeOf(context).width * 0.15, // Center the avatar
            child: GestureDetector(
              onTap: () {},
              child: CircleAvatar(
                radius: MediaQuery.sizeOf(context).width * 0.145,
                backgroundColor: AppColor.whiteColor,
                child: CircleAvatar(
                  radius: MediaQuery.sizeOf(context).width * 0.15 * 0.9,
                  backgroundColor: AppColor.whiteColor,
                  backgroundImage: const NetworkImage(
                    'https://img.freepik.com/free-photo/young-bearded-man-with-striped-shirt_273609-5677.jpg?t=st=1721152706~exp=1721156306~hmac=2c807194b896fa519c27566ed79a328c3d4731ab06e5ee403ed9edaf32df7ac2&w=740',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}