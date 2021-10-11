import 'package:doc_manager/models/models.dart';
import 'package:doc_manager/networking_n_storage/db_helper.dart';
import 'package:doc_manager/networking_n_storage/networking.dart';
import 'package:flutter/material.dart';

class DocProvider with ChangeNotifier {
  bool isGridView = false;
  bool isSaving = false;

  bool isLoading = false;
  dynamic error;
  List<Doctor> doctors = <Doctor>[];

  toggleView() {
    isGridView = !isGridView;
    notifyListeners();
  }

  List<Doctor> get top3Doctors {
    var ordered = <Doctor>[];
    ordered.addAll(doctors);
    ordered.sort((a, b) => b.ratingNum.compareTo(a.ratingNum));
    if (ordered.length > 3) ordered = ordered.take(3).toList();
    return ordered;
  }

  updatePic(Doctor doctor, String path) {
    doctor.profilePic = path;
    DbHelper().addOrUpdateDoctor(doctor.copyWith(profilePic: path));
    notifyListeners();
  }

  Future<Doctor?> saveToLocalDb(Doctor doctor) async {
    var doc = await DbHelper().addOrUpdateDoctor(doctor);
    notifyListeners();
    return doc;
  }

  syncData() {
    var copy = [];
    copy.addAll(doctors);
    DbHelper().getDoctors().then((value) {
      doctors.clear();
      for (var e in copy) {
        var doc = e;
        for (var element in value) {
          if (e == element) {
            doc = element;
          }
        }
        doctors.add(doc);
      }
      notifyListeners();
    });
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
        syncData();
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
