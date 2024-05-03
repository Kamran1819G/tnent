class Store {
  String ownerId;
  String storeName;
  String storeUID;
  String ownerUPI;
  List<String> storeContactArray; // -> Phone Number(s) -> Store Email
  String domainName;
  String storePhid;
  String storeAddress;

  Store({
    required this.ownerId,
    required this.storeName,
    required this.storeUID,
    required this.ownerUPI,
    required this.storeContactArray,
    required this.domainName,
    required this.storePhid,
    required this.storeAddress,
  });
}