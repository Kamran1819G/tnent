class Document {
  String id;
  String typeOfDocument;
  String isVerified;
  DateTime dateOfBirth;
  bool isAddressVerified;

  Document({
    required this.id,
    required this.typeOfDocument,
    required this.isVerified,
    required this.dateOfBirth,
    required this.isAddressVerified,
  });
}