import 'package:picsa/utilities/packages.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

abstract class SubsciptionTemplate {
  Future<List<Offering>> getOffers();
  Future<List<Package>> getAvailablePackages();
  Future<bool> purchasePackage(Package package);
  Future<CustomerInfo> restorePurchase();
}

class SubscriptionRepository extends SubsciptionTemplate {
  @override
  Future<List<Offering>> getOffers() async {
    try {
      final offerings = await Purchases.getOfferings();
      final current = offerings.current;
      return current == null ? [] : [current];
    } on PlatformException catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  @override
  Future<bool> purchasePackage(Package package) async {
    try {
      await Purchases.purchasePackage(package);
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  @override
  Future<CustomerInfo> restorePurchase() async {
    try {
      final info = await Purchases.restorePurchases();
      return info;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e.toString());
    }
  }


  @override
  Future<List<Package>> getAvailablePackages() async {
    try {
      return await Purchases.getOfferings()
          .then((value) => value.current!.availablePackages);
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e.toString());
    }
  }
}

enum EntitlementStatus { free, pro }
