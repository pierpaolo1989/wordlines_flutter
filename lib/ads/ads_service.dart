import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  static InterstitialAd? _interstitialAd;

  static String get interstitialId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/1033173712'; // TEST ANDROID
    } else {
      return 'ca-app-pub-3940256099942544/4411468910';
    }
  }

  static void loadInterstitial() {
    if (kIsWeb) return;
    InterstitialAd.load(
      adUnitId: interstitialId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (error) {
          _interstitialAd = null;
        },
      ),
    );
  }

  static void showInterstitial() {
    if (kIsWeb) return;
    if (_interstitialAd == null) return;

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        loadInterstitial();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        loadInterstitial();
      },
    );

    _interstitialAd!.show();
    _interstitialAd = null;
  }
}
