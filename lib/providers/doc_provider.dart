import 'package:doc_manager/models/models.dart';
import 'package:doc_manager/session_n_networking/networking.dart';
import 'package:flutter/material.dart';

class DocProvider with ChangeNotifier {
  bool isLoading = false;
  dynamic error;
  List<Doctor> doctors = <Doctor>[];

  Future<void> getDocs() async {
    isLoading = true;
    notifyListeners();
    return Networking.get("/contacts").then((value) {
      if (value.response is List) {
        var items =
            value.response.map<Doctor>((e) => Doctor.fromJson(e))?.toList() ??
                [];
        doctors.clear();
        doctors.addAll(items);
      }
      isLoading = false;
      notifyListeners();
    }).catchError((err) {
      isLoading = false;
      notifyListeners();
      error = err;
    });
  }
}
