import 'review_model.dart';
import 'purchase_model.dart';
import 'wishlist_model.dart';

enum UserType { customer, shopOwner }

class User {
  String userId;
  String username;
  String name;
  String email;
  String uuid; // From Auth ? Customer-0001, ShopOwner-0001
  UserType userType; // Enum or separate class
  String phoneNumber;
  bool isPremium;
  List<Purchase> purchases = []; // Purchase class
  double userRating;
  String userReview;
  String userImage;
  String storeId;
  String storeName;
  String reviewId;
  List<Review> reviews = []; // Review class
  int numberOfReviews; // length of subcollection
  int numberOfPurchases; // length of subcollection
  String userFeedbackForApp;
  List<String> connectListLarray = []; // Array of storeIds
  List<String> storePagesOpened = []; // Array of storeIds
  List<String> myPurchases = []; // Array of OrderIds
  List<String> userAddresses = []; // Array of addresses
  List<Wishlist> wishlist = []; // Wishlist class

  User({
    required this.userId,
    required this.username,
    this.name = '',
    this.email = '',
    required this.uuid,
    this.userType = UserType.customer,
    this.phoneNumber = '',
    this.isPremium = false,
    this.userRating = 0.0,
    this.userReview = '',
    this.userImage = '',
    this.storeId = '',
    this.storeName = '',
    this.reviewId  = '',
    this.numberOfReviews  = 0,
    this.numberOfPurchases  = 0,
    this.userFeedbackForApp  = '',
  });
}
