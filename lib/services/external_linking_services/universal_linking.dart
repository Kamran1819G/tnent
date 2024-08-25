import 'package:app_links/app_links.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tnent/core/helpers/snackbar_utils.dart';
import 'package:tnent/models/community_post_model.dart';
import 'package:tnent/models/product_model.dart';
import 'package:tnent/presentation/pages/home_pages/community.dart';
import 'package:tnent/presentation/pages/product_detail_screen.dart';
import 'package:tnent/services/context_utility.dart';

class UniversalLinking {
  // ignore: prefer_final_fields
  static AppLinks _appLinks = AppLinks();

  static String _productId = "";
  static String get productId => _productId;
  static bool get hasProductId => _productId.isNotEmpty;
  static void resetProductId() => _productId = "";

  static String _postId = "";
  static String get postId => _postId;
  static bool get hasPostId => _postId.isNotEmpty;
  static void resetPostId() => _postId = "";

  static init() async {
    try {
      final Uri? uri = await _appLinks.getInitialLink();
      uriHandler(uri);
    } on PlatformException catch (e) {
      showSnackBar(ContextUtility.context!, "Someting went wrong... $e");
    }

    _appLinks.uriLinkStream.listen((Uri? uri) async {
      uriHandler(uri);
    }, onError: (e) {
      showSnackBar(ContextUtility.context!, e.toString());
    });
  }

  static uriHandler(Uri? uri) async {
    if (uri == null || uri.queryParameters.isEmpty) return;

    Map<String, String> params = uri.queryParameters;

    String receivedProductId = params["productId"] ?? "";
    String receivedPostId = params["postId"] ?? "";

    // ----------------------------------------------------------------
    if (receivedPostId.isNotEmpty) {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('communityPosts')
          .doc(receivedPostId)
          .get();
      Get.to(() => PostViewScreen(post: CommunityPostModel.fromFirestore(doc)));
    }
    if (receivedProductId.isNotEmpty) {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('products')
          .doc(receivedProductId)
          .get();
      Get.to(
          () => ProductDetailScreen(product: ProductModel.fromFirestore(doc)));
    }
    // ----------------------------------------------------------------
  }
}
