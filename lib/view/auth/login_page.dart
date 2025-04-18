import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'package:tgo_todo/components/custom_text_field.dart';
import 'package:tgo_todo/components/k_buttons.dart';
import 'package:tgo_todo/controller/login_controller.dart';
import 'package:tgo_todo/utills/file_indexes.dart';
import 'package:tgo_todo/utills/loader.dart';
import 'package:tgo_todo/view/auth/signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  late final LoginController controller;

  @override
  void initState() {
    super.initState();
    controller = LoginController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: controller,
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: SingleChildScrollView(
              child: Container(
                height: MediaQuery.sizeOf(context).height,
                width: MediaQuery.sizeOf(context).width,
                decoration: BoxDecoration(gradient: AppColor.commonBackgroundGradient),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        AppImages.coloredLogo,
                        width: MediaQuery.sizeOf(context).width * 0.4,
                      ),
                      const SizedBox(height: 30,),
                      Container(
                        width: MediaQuery.sizeOf(context).width - 60,
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
                            Align(
                                alignment: Alignment.center,
                                child: Text('Login',
                                    style: kTextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w700,
                                    ))),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: RichText(
                                text: TextSpan(
                                  text: "Don't have an account? ",
                                  style: kTextStyle(color: AppColor.greyText, fontSize: 12), // base style
                                  children: [
                                    TextSpan(
                                      text: 'Signup',
                                      style: kTextStyle(color: AppColor.darkPrimary, fontWeight: FontWeight.bold, fontSize: 12),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.push(context, MaterialPageRoute(builder: (_) => SignupPage()));
                                        },
                                    ),
                                  ],
                                ),
                              ),
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
                              'Password',
                              style: kTextStyle(color: AppColor.greyText),
                            ),
                            Selector<LoginController,bool>(
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
                            Row(
                              children: [
                                Selector<LoginController, bool>(
                                  selector: (context, controller) => controller.checked,
                                  builder: (context, value, child) {
                                    print("build");
                                    return Checkbox(
                                      value: value,
                                      onChanged: (val) {
                                        context.read<LoginController>().rememberMe(val!);
                                      },
                                      activeColor: AppColor.lightPrimary,
                                      side: BorderSide(color: AppColor.greyText),
                                    );
                                  },
                                ),
                                Text(
                                  'Remember me',
                                  style: kTextStyle(color: AppColor.greyText),
                                ),
                                Spacer(),
                                Text(
                                  'Forgot Password?',
                                  style: kTextStyle(color: AppColor.darkPrimary),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            kTextButton(
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  showLoader();
                                  await controller.login(context);
                                  hideLoader();
                                }
                              },
                              textColor: AppColor.whiteColor,
                              btnText: 'Login',
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Divider(
                                  color: AppColor.lightGreyColor,
                                  endIndent: 20,
                                )),
                                Text(
                                  'Or',
                                  style: kTextStyle(color: AppColor.greyText),
                                ),
                                Expanded(
                                    child: Divider(
                                  color: AppColor.lightGreyColor,
                                  indent: 20,
                                )),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            kTextButton(
                              onPressed: () async {
                                await controller.signInWithGoogle(context);
                              },
                              widget: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                spacing: 5,
                                children: [showSvgIconWidget(iconPath: AppIcons.googleIcon, context: context), Text('Continue with Google')],
                              ),
                              borderColor: AppColor.lightGreyColor,
                              color: AppColor.whiteColor,
                              textColor: AppColor.whiteColor,
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
