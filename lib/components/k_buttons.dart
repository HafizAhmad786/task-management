import 'package:tgo_todo/utills/file_indexes.dart';

Widget kTextButton( {
  Color? color,
  Function()? onPressed,
  String? btnText,
  Widget? widget,
  Color? textColor,
  Color? borderColor,
  double? height,
  double ? width,
  double ? borderRadius,
  double ? fontSize,
}) {
  return GestureDetector(
    onTap: onPressed,
    child: Container(
      height:  height?? 60,
      width: width,
      alignment: Alignment.center,
      padding:  const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: color ?? AppColor.darkPrimary,
        borderRadius: BorderRadius.circular(borderRadius??10),
        border: Border.all(color: borderColor?? Colors.transparent),
      ),
      child: widget?? Text(
          btnText!,
          textAlign: TextAlign.center,
          style: kTextStyle(
              fontSize: fontSize??16,
              fontWeight: FontWeight.w600,
              color: textColor??AppColor.blackColor
          ),
        ),),
  );
}