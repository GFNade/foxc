import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:untitled/common/managers/session_manager.dart';

class InterstitialManager {
  static var shared = InterstitialManager();

  InterstitialAd? _interstitialAd;

  InterstitialManager() {
    if (SessionManager.shared.isAdMobOn()) {
      loadAd();
    }
  }

  void loadAd() {
    InterstitialAd.load(
        adUnitId: SessionManager.shared.getInterstitialAdId(),
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
                // Called when the ad showed the full screen content.
                onAdShowedFullScreenContent: (ad) {},
                // Called when an impression occurs on the ad.
                onAdImpression: (ad) {},
                // Called when the ad failed to show full screen content.
                onAdFailedToShowFullScreenContent: (ad, err) {
                  // Dispose the ad here to free resources.
                  ad.dispose();
                  loadAd();
                },
                // Called when the ad dismissed full screen content.
                onAdDismissedFullScreenContent: (ad) {
                  // Dispose the ad here to free resources.
                  ad.dispose();
                  loadAd();
                },
                // Called when a click is recorded for an ad.
                onAdClicked: (ad) {});

            debugPrint('$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            _interstitialAd = ad;
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('InterstitialAd failed to load: $error');
          },
        ));
  }

  void showAd() {
    print("AD: ${_interstitialAd}");
    if (SessionManager.shared.isAdMobOn()) {
      _interstitialAd?.show();
    }
  }
}
