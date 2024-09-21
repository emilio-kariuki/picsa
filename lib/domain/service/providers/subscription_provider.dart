import 'package:picsa/domain/service/repository/subscription_repository.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class SubscriptionProvider extends SubsciptionTemplate {
  final SubscriptionRepository _subscriptionRepository;
  SubscriptionProvider({required SubscriptionRepository subscriptionRepository})
      : _subscriptionRepository = subscriptionRepository;

  @override
  Future<List<Offering>> getOffers() {
    return _subscriptionRepository.getOffers();
  }

  @override
  Future<bool> purchasePackage(Package package) {
    return _subscriptionRepository.purchasePackage(package);
  }

  @override
  Future<CustomerInfo> restorePurchase() {
    return _subscriptionRepository.restorePurchase();
  }
  
  @override
  Future<List<Package>> getAvailablePackages() {
    return _subscriptionRepository.getAvailablePackages();
  }
}
