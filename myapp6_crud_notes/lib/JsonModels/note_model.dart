import 'package:sqlite_flutter_crud/settings/constants_db.dart';

class LlibreModel {
  final int? llibreId;
  final String llibreTitol;
  final String llibreSinopsi;
  final String llibreCreatedAt;

  LlibreModel({
    this.llibreId,
    required this.llibreTitol,
    required this.llibreSinopsi,
    required this.llibreCreatedAt,
  });

  factory LlibreModel.fromMap(Map<String, dynamic> json) => LlibreModel(
    llibreId: json[ConstantsDb.FIELD_BOOK_ID],
    llibreTitol: json[ConstantsDb.FIELD_BOOK_TITLE],
    llibreSinopsi: json[ConstantsDb.FIELD_BOOK_SYNOPSIS],
    llibreCreatedAt: json[ConstantsDb.FIELD_BOOK_CREATED_AT],
  );

  Map<String, dynamic> toMap() => {
    ConstantsDb.FIELD_BOOK_ID: llibreId,
    ConstantsDb.FIELD_BOOK_TITLE: llibreTitol,
    ConstantsDb.FIELD_BOOK_SYNOPSIS: llibreSinopsi,
    ConstantsDb.FIELD_BOOK_CREATED_AT: llibreCreatedAt,
  };
}
