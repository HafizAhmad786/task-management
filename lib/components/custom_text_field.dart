import 'package:tgo_todo/utills/extensions.dart';
import 'package:tgo_todo/utills/file_indexes.dart';

class GetTextField extends StatelessWidget {
  final BuildContext context;
  final String? hintText;
  final String? prefixIcon;
  final IconData? suffixIcon;

  final String? Function(String?)? validator;
  final Function()? suffixOnTap;
  final Function()? fieldOnTap;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextEditingController? controller;
  final bool? obSecureText;
  final bool? readOnly;
  final Function(String)? onChanged;
  final FocusNode? focusNode;
  final Color? borderColor;
  final int? maxLines;
  final double? verticalPadding;

  const GetTextField({super.key,
    required this.context,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.controller,
    this.obSecureText,
    this.suffixOnTap,
    this.onChanged,
    this.focusNode,
    this.readOnly,
    this.borderColor,
    this.maxLines,
    this.verticalPadding,
    this.fieldOnTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly !=null ?true:false,
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
        prefixIcon: prefixIcon!=null? showSvgIconWidget(iconPath: prefixIcon!,height: 20,width: 25,context: context):null,
        prefixIconConstraints: const BoxConstraints(
          minHeight: 20,
          minWidth: 35,
        ),
        suffixIcon: suffixIcon != null
            ? IconButton(
          icon: Icon(
            suffixIcon,
            color: Colors.grey,
            size: 20,
          ),
          onPressed: suffixOnTap,
        )
            : null,
        contentPadding:  EdgeInsets.symmetric(horizontal:  15,vertical: verticalPadding??15),
        hintStyle: kTextStyle(color: Colors.grey, fontSize: 12.0),
        filled: true,
        isDense: true,
        fillColor: Colors.white,
        enabledBorder:  OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide:  BorderSide(color: borderColor?? AppColor.lightGreyColor,),
        ),
        focusedBorder:  OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide:   BorderSide(color: borderColor?? AppColor.lightGreyColor,),
        ),
      ),
    );
  }
}
