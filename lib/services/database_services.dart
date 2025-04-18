
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseServices{
  var user = FirebaseFirestore.instance.collection("users");
  var task = FirebaseFirestore.instance.collection("tasks");
}