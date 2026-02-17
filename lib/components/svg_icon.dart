import 'package:tgo_todo/utills/file_indexes.dart';

Widget showSvgIconWidget({required String iconPath, bool replacement = false,
  Widget? page, Function()? onTap,Color? color,double? width,double? height,required BuildContext context}) {
  return GestureDetector(
      onTap: () {
        if(onTap != null){
          onTap();
        }
        if (page != null){
          if(replacement){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => page));
          }else{
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => page));
          }
        }
      },
      child: SvgPicture.asset(
        iconPath,
        // color: color,
        colorFilter: ColorFilter.mode(color ?? AppColor.lightPrimary,BlendMode.srcIn),
        width: width,
        height: height,
      ));
}