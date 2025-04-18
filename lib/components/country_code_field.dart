import 'package:tgo_todo/utills/extensions.dart';
import 'package:tgo_todo/utills/file_indexes.dart';

class CountryCodeField extends StatelessWidget {
  final BuildContext context;
  final String? hintText;
  final String? prefixIcon;
  final Widget? prefixWidget;
  final String? Function(String?)? validator;
  final Function()? fieldOnTap;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextEditingController? controller;
  final bool? obSecureText;
  final Function(String)? onChanged;
  final FocusNode? focusNode;
  final int? maxLines;

  const CountryCodeField({super.key,
    required this.context,
    this.hintText,
    this.prefixIcon,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.controller,
    this.obSecureText,
    this.onChanged,
    this.focusNode,
    this.maxLines,
    this.fieldOnTap, this.prefixWidget,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      cursorColor: AppColor.darkPrimary,
      maxLines: maxLines?? 1,
      style: kTextStyle( fontSize: 14.0,fontWeight: FontWeight.w500),
      keyboardType: keyboardType ?? TextInputType.text,
      textInputAction: textInputAction??TextInputAction.next,
      obscureText: obSecureText??true,
      onTapOutside: (event) {context.dismissKeyBoard();},
      onChanged: onChanged,
      onTap: fieldOnTap?? (){},

      focusNode: focusNode,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixWidget,
        prefixIconConstraints: const BoxConstraints(
          minHeight: 20,
          minWidth: 35,
        ),
        contentPadding:  EdgeInsets.symmetric(horizontal:  15,vertical: 15),
        hintStyle: kTextStyle(color: Colors.grey, fontSize: 12.0),
        filled: true,
        isDense: true,
        fillColor: Colors.white,
        enabledBorder:  OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide:  BorderSide(color: AppColor.lightGreyColor,),
        ),
        focusedBorder:  OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide:   BorderSide(color: AppColor.lightGreyColor,),
        ),
      ),
    );
  }
}
