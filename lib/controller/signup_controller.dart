import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tgo_todo/utills/file_indexes.dart';
import 'package:tgo_todo/view/auth/login_page.dart';

import '../services/firebase_services.dart';

class SignupController extends ChangeNotifier {
  var name = TextEditingController();
  var email = TextEditingController();
  var dob = TextEditingController();
  var number = TextEditingController();
  var password = TextEditingController();
  String countryCode = "+92";
  bool obscurePassword = true;

  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  signupWithEmail(BuildContext context) async {
    var firebaseController = context.read<FirebaseServices>();
    String fullPhoneNumber = "$countryCode${number.text.trim()}";

    var response = await firebaseController.createNewUser({
      "displayName": name.text.trim(),
      "email": email.text.trim(),
      "phoneNumber": fullPhoneNumber,
      "dob": dob.text.trim(),
      "password": password.text.trim()
    });
    Fluttertoast.showToast(msg: "User created successfully");
    if (context.mounted) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => LoginPage()));
    }
    if (response is Map && response.containsKey("error")) {
      Fluttertoast.showToast(msg: response['error']);
      return;
    }
  }

  changeData(BuildContext context) async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      dob.text = DateFormat("yyyy-MM-dd").format(date);
      notifyListeners();
    }
  }
}
