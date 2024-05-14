import 'package:picsa/domain/service/providers/subscription_provider.dart';
import 'package:picsa/domain/service/service_locator.dart';
import 'package:picsa/utilities/packages.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class SubscriptionCubit extends Cubit<SubscriptionState> {
  final _subscriptionproviders = service<SubscriptionProvider>();
  SubscriptionCubit() : super(SubscriptionState());

  Future<void> getOffers() async {
    try {
      emit(state.copyWith(status: SubscriptionStatus.loading));
      final offers = await _subscriptionproviders.getOffers();
      emit(state.copyWith(
        offers: offers,
        status: SubscriptionStatus.success,
        message: "Fetched offers successfully",
      ));
    } catch (error) {
      emit(state.copyWith(
          status: SubscriptionStatus.error,
          message: error.toString().toException()));
    }
  }

  Future<void> getPackages() async {
    try {
      emit(state.copyWith(status: SubscriptionStatus.loading));
      final packages = await _subscriptionproviders.getAvailablePackages();
      emit(state.copyWith(
        packages: packages,
        status: SubscriptionStatus.success,
        message: "Fetched packages successfully",
      ));
    } catch (error) {
      emit(state.copyWith(
          status: SubscriptionStatus.error,
          message: error.toString().toException()));
    }
  }


  Future<void> purchasePackage({required Package package}) async {
    try {
      emit(state.copyWith(status: SubscriptionStatus.loading));
      await _subscriptionproviders.purchasePackage(package);
      emit(state.copyWith(
        status: SubscriptionStatus.subscribed,
        message: "Purchased package successfully",
      ));
    } catch (error) {
      emit(state.copyWith(
          status: SubscriptionStatus.error,
          message: error.toString().toException()));
    }
  }

  Future<void> restorePurchase() async {
    try {
      emit(state.copyWith(status: SubscriptionStatus.loading));
      final user = await _subscriptionproviders.restorePurchase();
      emit(state.copyWith(
        status: SubscriptionStatus.subscribed,
        isSubscribed:
            user.entitlements.all[AppConstants.ENTITLEMENT_ID]?.isActive,
        message: "Restored purchase successfully",
      ));
    } catch (error) {
      emit(state.copyWith(
          status: SubscriptionStatus.error,
          message: error.toString().toException()));
    }
  }
}

//* SubscriptionState

enum SubscriptionStatus { initial, loading, success, subscribed, error }

class SubscriptionState {
  final bool isSubscribed;
  final List<Offering> offers;
  final List<Package> packages;
  final SubscriptionStatus status;
  final String message;

  SubscriptionState(
      {this.status = SubscriptionStatus.initial,
      this.offers = const [],
      this.packages = const [],
      this.message = "",
      this.isSubscribed = false});

  SubscriptionState copyWith({
    final bool? isSubscribed,
    final SubscriptionStatus? status,
    final List<Offering>? offers,
    final List<Package>? packages,
    final String? message,
  }) {
    return SubscriptionState(
        isSubscribed: isSubscribed ?? this.isSubscribed,
        offers: offers ?? this.offers,
        packages: packages ?? this.packages,
        status: status ?? this.status,
        message: message ?? this.message);
  }
}
