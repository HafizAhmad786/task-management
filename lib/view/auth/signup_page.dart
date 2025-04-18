import 'package:country_code_picker_plus/country_code_picker_plus.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'package:tgo_todo/components/country_code_field.dart';
import 'package:tgo_todo/components/custom_text_field.dart';
import 'package:tgo_todo/components/k_buttons.dart';
import 'package:tgo_todo/controller/signup_controller.dart';
import 'package:tgo_todo/utills/file_indexes.dart';
import 'package:tgo_todo/utills/loader.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final formKey = GlobalKey<FormState>();
  late final SignupController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = SignupController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: controller,
      child: Builder(
        builder: (context) {
          var controller = context.read<SignupController>();
          return Scaffold(
            body: Container(
              height: MediaQuery
                  .sizeOf(context)
                  .height,
              width: MediaQuery
                  .sizeOf(context)
                  .width,
              decoration: BoxDecoration(gradient: AppColor.commonBackgroundGradient),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 100,),
                      Image.asset(
                        AppImages.coloredLogo,
                        width: MediaQuery.sizeOf(context).width * 0.4,
                      ),
                      const SizedBox(height: 30,),
                      Container(
                        width: MediaQuery
                            .sizeOf(context)
                            .width - 60,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        decoration: BoxDecoration(
                          color: AppColor.whiteColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppColor.blackColor.withValues(alpha: 0.1),
                              blurRadius: 10,
                              spreadRadius: 2,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(Icons.arrow_back)),
                            Text('Sign Up',
                                style: kTextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                )),
                            RichText(
                              text: TextSpan(
                                text: "Already Have An Account? ",
                                style: kTextStyle(color: AppColor.greyText, fontSize: 12), // base style
                                children: [
                                  TextSpan(
                                    text: 'Login',
                                    style: kTextStyle(color: AppColor.darkPrimary, fontWeight: FontWeight.bold, fontSize: 12),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.pop(context);
                                      },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Full Name',
                              style: kTextStyle(color: AppColor.greyText),
                            ),
                            GetTextField(
                              controller: controller.name,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "Please fill this field";
                                }
                                return null;
                              },
                              context: context,
                              obSecureText: false,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Email',
                              style: kTextStyle(color: AppColor.greyText),
                            ),
                            GetTextField(
                              controller: controller.email,
                              keyboardType: TextInputType.emailAddress,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "Please fill this field";
                                }
                                if (!val.contains(".") || !val.contains("@")) {
                                  return "Please enter a valid email";
                                }
                                return null;
                              },
                              context: context,
                              obSecureText: false,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Date Of Birth',
                              style: kTextStyle(color: AppColor.greyText),
                            ),
                            Selector<SignupController,String>(
                              builder: (context,value,child){
                                return  GetTextField(
                                  fieldOnTap: () async {
                                    controller.changeData(context);
                                  },
                                  controller: controller.dob,
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return "Please fill this field";
                                    }
                                    return null;
                                  },
                                  readOnly: true,
                                  context: context,
                                  obSecureText: false,
                                  textInputAction: TextInputAction.done,
                                  suffixIcon: Icons.calendar_month,
                                );
                              },
                              selector: (context,controller) => controller.dob.text,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Phone Number',
                              style: kTextStyle(color: AppColor.greyText),
                            ),
                            CountryCodeField(
                              controller: controller.number,
                              context: context,
                              keyboardType: TextInputType.number,
                              obSecureText: false,
                              prefixWidget: CountryCodePicker(
                                mode: CountryCodePickerMode.dialog,
                                onChanged: (country) {
                                  controller.countryCode = country.dialCode;
                                },
                                initialSelection: 'Pk',
                                showFlag: true,
                                showDropDownButton: true,
                              ),
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "Please fill this field";
                                }
                                return null;
                              },
                            ),

                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Set Password',
                              style: kTextStyle(color: AppColor.greyText),
                            ),
                            Selector<SignupController,bool>(
                                builder: (context,value,child){
                                  return GetTextField(
                                    controller: controller.password,
                                    context: context,
                                    obSecureText: controller.obscurePassword,
                                    suffixIcon: value ? Icons.visibility_off : Icons.visibility,
                                    suffixOnTap: () {
                                      controller.togglePasswordVisibility();
                                    },
                                    hintText: '',
                                    textInputAction: TextInputAction.done,
                                    validator: (val) {
                                      if (val!.isEmpty) return "Please fill this field";
                                      if (val.length < 6) return "Password length should be greater than 6";
                                      return null;
                                    },
                                  );
                                },
                                selector: (context,controller) => controller.obscurePassword
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            kTextButton(
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  showLoader();
                                  await controller.signupWithEmail(context);
                                  hideLoader();
                                }
                              },
                              textColor: AppColor.whiteColor,
                              btnText: 'Signup',
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
