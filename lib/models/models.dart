import 'package:flutter/cupertino.dart';
import 'package:remixicon/remixicon.dart';

class Country {
  final String name;
  final String? alpha2Code;
  final String extension;

  Country({required this.name, this.alpha2Code, required this.extension});
}

class Doctor {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? profilePic;
  final bool? isFavourite;
  final String? primaryContactNo;
  final String? rating;
  final String? email;
  final String? qualification;
  final String? description;
  final String? specialization;
  final String? languagesKnown;

  Doctor({
    this.id,
    this.firstName,
    this.lastName,
    this.profilePic,
    this.isFavourite,
    this.primaryContactNo,
    this.rating,
    this.email,
    this.qualification,
    this.description,
    this.specialization,
    this.languagesKnown,
  });

  String get name => ((firstName ?? "n/a") + (lastName ?? "")).trim();

  String? get initials {
    String letter = firstName?.substring(0, 1) ?? "";
    letter += lastName?.substring(0, 1) ?? "";
    return letter.isEmpty ? null : letter;
  }

  Widget get avatar {
    if (profilePic?.isEmpty ?? true) {
      if (initials != null) return Text(initials!);
      return const Icon(Remix.user_3_fill);
    }
    return Image.network(
      profilePic!,
      width: double.maxFinite,
      height: double.maxFinite,
      fit: BoxFit.cover,
    );
  }

  factory Doctor.fromJson(Map<String, dynamic>? jsonStr) {
    if (jsonStr == null) throw "noData";
    return Doctor(
      id: jsonStr["id"],
      firstName: jsonStr["first_name"],
      lastName: jsonStr["last_name"],
      profilePic: jsonStr["profile_pic"],
      isFavourite: jsonStr["favourite"],
      primaryContactNo: jsonStr["primary_contact_no"],
      rating: jsonStr["rating"],
      email: jsonStr["email_address"],
      qualification: jsonStr["qualification"],
      description: jsonStr["description"],
      specialization: jsonStr["specialization"],
      languagesKnown: jsonStr["languagesKnown"],
    );
  }
}
