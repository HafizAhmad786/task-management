import 'package:tgo_todo/utills/file_indexes.dart';

class CustomRow extends StatelessWidget {
  final String icon;
  final String text;
  final String val;

  const CustomRow({super.key, required this.icon, required this.text, required this.val});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          spacing: 5,
          children: [showSvgIconWidget(iconPath: icon, context: context), Text(text)],
        ),
        Text(
          val,
          style: kTextStyle(fontSize: 12, color: AppColor.greyText),
        ),
      ],
    );
  }
}