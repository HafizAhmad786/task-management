import 'package:tgo_todo/utills/file_indexes.dart';


TextStyle kTextStyle({double? fontSize, FontWeight? fontWeight,
  Color? color,TextDecoration? textDecoration,Color? decorationColor}) {
  return GoogleFonts.poppins(
      textStyle: TextStyle(
          decoration:textDecoration?? TextDecoration.none,
          fontSize:  fontSize?? 14,
          fontWeight: fontWeight??FontWeight.w400,
          color: color??Colors.black,
          decorationColor: decorationColor??AppColor.blackColor,
      )
  );
}
