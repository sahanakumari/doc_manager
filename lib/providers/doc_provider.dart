import 'package:doc_manager/models/models.dart';
import 'package:doc_manager/session_n_networking/networking.dart';
import 'package:flutter/material.dart';

class DocProvider with ChangeNotifier {
  bool isGridView = false;

  bool isLoading = false;
  dynamic error;
  List<Doctor> doctors = <Doctor>[];
  List<Doctor> top3Doctors = <Doctor>[];

  toggleView() {
    isGridView = !isGridView;
    notifyListeners();
  }

  _findTopRatedDocs(List<Doctor> items) {
    var ordered = <Doctor>[];
    ordered.addAll(items);
    ordered.sort((a, b) => b.ratingNum.compareTo(a.ratingNum));
    if (ordered.length > 3) ordered = ordered.take(3).toList();
    top3Doctors.clear();
    top3Doctors.addAll(ordered);
    notifyListeners();
  }

  Future<void> getDocs() async {
    isLoading = true;
    notifyListeners();
    return Networking.get("/contacts", enableCaching: true).then((value) {
      if (value.response is List) {
        var items =
            value.response.map<Doctor>((e) => Doctor.fromJson(e))?.toList() ??
                [];
        doctors.clear();
        doctors.addAll(items);
        Future.delayed(Duration(milliseconds: 500), () {
          _findTopRatedDocs(items);
        });
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
