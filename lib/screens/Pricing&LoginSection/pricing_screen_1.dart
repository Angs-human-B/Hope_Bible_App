import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback, PlatformException;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart' show Get, Inst, Obx;
import 'package:hope/Constants/colors.dart';
import 'package:hope/Constants/icons.dart';
import 'package:hope/screens/auth/auth_page.dart' show AuthPage;
import 'package:purchases_flutter/purchases_flutter.dart'
    show CustomerInfo, EntitlementInfo, Offering, Purchases;
import 'package:intl/intl.dart';
import '../../utilities/app.constants.dart'
    show AppConstants, EntitleMents, Utils;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../onboarding/controllers/onboarding.controller.dart'
    show OnboardingController;
import '../persistent_botom_nav.dart' show PersistentBottomNav;
import 'pricing_screen_2.dart' show PricingScreen2;

class PricingScreen1 extends StatefulWidget {
  final Offering? offering;
  final bool isMainScreen;
  const PricingScreen1({super.key, this.offering, this.isMainScreen = false});

  @override
  State<PricingScreen1> createState() => _PricingScreen1State();
}

class _PricingScreen1State extends State<PricingScreen1>
    with SingleTickerProviderStateMixin {
  final OnboardingController oboardingController =
      Get.find<OnboardingController>();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    var myProductList = widget.offering?.availablePackages;
    final selectedPlan = oboardingController.selectedPlan;
    double? yearlyPrice;
    double? monthlyPrice;
    if (myProductList != null && myProductList.length > 2) {
      yearlyPrice = myProductList[1].storeProduct.price;
      monthlyPrice = myProductList[2].storeProduct.price;
    }
    int? savePercent;
    if (yearlyPrice != null && monthlyPrice != null && monthlyPrice > 0) {
      double monthlyEquivalent = yearlyPrice / 12.0;
      savePercent = ((1 - (monthlyEquivalent / monthlyPrice)) * 100).round();
      if (savePercent < 0) savePercent = 0;
    }
    return CupertinoPageScaffold(
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black, Color(0xFF31343A)],
                stops: [0.41, 1.0],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Top bar with close button
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 15.h, right: 8.w),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: ClipRRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                            child: Container(
                              width: 42.w,
                              height: 42.h,
                              decoration: BoxDecoration(
                                color: CupertinoColors.systemGrey.withOpacity(
                                  0.2,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                  closeIcon,
                                  height: 22.h,
                                  colorFilter: const ColorFilter.mode(
                                    CupertinoColors.white,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30.h),
                // Headline
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Text(
                    'Help us\nSpread Faith',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(height: 40.h),
                // Plan cards
                Obx(
                  () => Column(
                    children: [
                      Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          GestureDetector(
                            onTap: () {
                              oboardingController.selectedPlan.value = 'Annual';
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 18.h),
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 18.h,
                              ),
                              width: MediaQuery.of(context).size.width - 36.w,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(16.sp),
                                border: Border.all(
                                  color:
                                      selectedPlan.value == 'Annual'
                                          ? Colors.white
                                          : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    selectedPlan.value == 'Annual'
                                        ? Icons.radio_button_checked_rounded
                                        : Icons.radio_button_unchecked_rounded,
                                    color: Colors.white,
                                    size: 28.sp,
                                  ),
                                  SizedBox(width: 8.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Yearly',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.sp,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        SizedBox(height: 2.h),
                                        Text(
                                          'Annual Plan',
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(
                                              0.7,
                                            ),
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    myProductList != null &&
                                            myProductList.length > 1
                                        ? NumberFormat.currency(
                                              symbol: getCurrencySymbol(
                                                myProductList[1]
                                                    .storeProduct
                                                    .currencyCode
                                                    .toUpperCase(),
                                              ),
                                              decimalDigits: 2,
                                            ).format(
                                              myProductList[1]
                                                  .storeProduct
                                                  .price,
                                            ) +
                                            '/y'
                                        : '24.99/y',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16.sp),
                              ),
                              child: Text(
                                savePercent != null ? 'Save $savePercent%' : '',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.sp,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 18.h),
                      GestureDetector(
                        onTap: () {
                          oboardingController.selectedPlan.value = 'Monthly';
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 18.h,
                          ),
                          width: MediaQuery.of(context).size.width - 36.w,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(16.sp),
                            border: Border.all(
                              color:
                                  selectedPlan.value == 'Monthly'
                                      ? Colors.white
                                      : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                selectedPlan.value == 'Monthly'
                                    ? Icons.radio_button_checked_rounded
                                    : Icons.radio_button_unchecked_rounded,
                                color: Colors.white,
                                size: 28.sp,
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Monthly',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(height: 2.h),
                                    Text(
                                      'Monthly Plan',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                myProductList != null &&
                                        myProductList.length > 2
                                    ? NumberFormat.currency(
                                          symbol: getCurrencySymbol(
                                            myProductList[2]
                                                .storeProduct
                                                .currencyCode
                                                .toUpperCase(),
                                          ),
                                          decimalDigits: 2,
                                        ).format(
                                          myProductList[2].storeProduct.price,
                                        ) +
                                        '/m'
                                    : '24.99/m',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                GestureDetector(
                  onTap: () async {
                    await Purchases.restorePurchases();
                    Navigator.of(context, rootNavigator: true).push(
                      CupertinoPageRoute(
                        builder:
                            (context) => const CupertinoScaffold(
                              body: AuthPage(login: true),
                            ),
                      ),
                    );
                  },
                  child: Text(
                    'Restore Purchase',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.only(
                    left: 18.w,
                    right: 18.w,
                    bottom: 18.h,
                  ),
                  child: GestureDetector(
                    onTap: () async {
                      Utils.logger.e(myProductList);
                      setState(() {
                        isLoading = true;
                      });
                      HapticFeedback.mediumImpact();
                      int index =
                          oboardingController.selectedPlan.value == "Annual"
                              ? 1
                              : 2;
                      try {
                        CustomerInfo customerInfo =
                            await Purchases.purchasePackage(
                              myProductList![index],
                            );
                        EntitlementInfo? entitlement =
                            customerInfo.entitlements.all[EntitleMents
                                .entitlementId];
                        AppConstants.revenueCatId =
                            customerInfo.originalAppUserId;
                        AppConstants.currentSubscription =
                            entitlement?.productIdentifier ?? '';
                        if (AppConstants.existingUser) {
                          await Purchases.restorePurchases();
                        }
                        if (entitlement?.isActive == true &&
                            AppConstants.userId.isEmpty) {
                          await Navigator.of(context, rootNavigator: true).push(
                            CupertinoPageRoute(
                              builder:
                                  (context) => CupertinoScaffold(
                                    body: AuthPage(
                                      login: AppConstants.existingUser,
                                    ),
                                  ),
                            ),
                          );
                        } else if (entitlement?.isActive == true &&
                            AppConstants.userId.isNotEmpty) {
                          await Navigator.of(context, rootNavigator: true).push(
                            CupertinoPageRoute(
                              builder:
                                  (context) => const CupertinoScaffold(
                                    body: PersistentBottomNav(),
                                  ),
                            ),
                          );
                        } else if (entitlement?.isActive == true &&
                            AppConstants.userId.isNotEmpty) {
                          setState(() {
                            AppConstants.isSubscriptionActive = true;
                          });
                          Navigator.pop(context);
                        } else {
                          await Purchases.restorePurchases();
                          await Navigator.of(context, rootNavigator: true).push(
                            CupertinoPageRoute(
                              builder:
                                  (context) => const CupertinoScaffold(
                                    body: AuthPage(login: false),
                                  ),
                            ),
                          );
                        }
                      } on PlatformException catch (e) {
                        if (e.message == 'Purchase was cancelled.') {
                          // await Posthog().capture(
                          //   properties: {
                          //     'revenueCatId': AppConstants.revenueCatId,
                          //   },
                          //   eventName: "Viewed One-Time Offer",
                          // );

                          await showCupertinoModalBottomSheet(
                            topRadius: Radius.circular(32.sp),
                            context: context,
                            builder:
                                (context) => SizedBox(
                                  height: 351.h,
                                  child: PricingScreen2(
                                    offering: widget.offering!,
                                  ),
                                ),
                          );

                          // await Navigator.of(context, rootNavigator: true).push(
                          //   CupertinoPageRoute(
                          //     fullscreenDialog: true,
                          //     builder:
                          //         (context) => CupertinoScaffold(
                          //           body: AuthPage(
                          //             login: AppConstants.existingUser,
                          //           ),
                          //         ),
                          //   ),
                          // );
                        }

                        // Handle errors
                      } catch (e) {
                        // Handle any other unexpected errors.
                      } finally {
                        setState(() {
                          isLoading = false;
                        });
                      }
                    },
                    child: Container(
                      height: 56.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: accentWhite,
                        borderRadius: BorderRadius.circular(30.sp),
                      ),
                      child: Center(
                        child: Obx(() {
                          return isLoading == true
                              ? const CupertinoActivityIndicator(
                                color: CupertinoColors.black,
                              )
                              : Text(
                                oboardingController.selectedPlan.value ==
                                        "Annual"
                                    ? "Subscribe for " +
                                        (myProductList != null &&
                                                myProductList.length > 1
                                            ? NumberFormat.currency(
                                              symbol: getCurrencySymbol(
                                                myProductList[1]
                                                    .storeProduct
                                                    .currencyCode
                                                    .toUpperCase(),
                                              ),
                                              decimalDigits: 2,
                                            ).format(
                                              myProductList[1]
                                                  .storeProduct
                                                  .price,
                                            )
                                            : '49.99') +
                                        "/y"
                                    : "Subscribe for " +
                                        (myProductList != null &&
                                                myProductList.length > 2
                                            ? NumberFormat.currency(
                                              symbol: getCurrencySymbol(
                                                myProductList[2]
                                                    .storeProduct
                                                    .currencyCode
                                                    .toUpperCase(),
                                              ),
                                              decimalDigits: 2,
                                            ).format(
                                              myProductList[2]
                                                  .storeProduct
                                                  .price,
                                            )
                                            : '24.99') +
                                        "/m",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: secondaryBlack,
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                        }),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String getCurrencySymbol(String currencyCode) {
    switch (currencyCode.toUpperCase()) {
      case 'AED':
        return 'د.إ'; // United Arab Emirates Dirham
      case 'AFN':
        return '؋'; // Afghan Afghani
      case 'ALL':
        return 'L'; // Albanian Lek
      case 'AMD':
        return '֏'; // Armenian Dram
      case 'ANG':
        return 'ƒ'; // Netherlands Antillean Guilder
      case 'AOA':
        return 'Kz'; // Angolan Kwanza
      case 'ARS':
        return '\$'; // Argentine Peso
      case 'AUD':
        return '\$'; // Australian Dollar
      case 'AWG':
        return 'ƒ'; // Aruban Florin
      case 'AZN':
        return '₼'; // Azerbaijani Manat
      case 'BDT':
        return '৳'; // Bangladeshi Taka
      case 'BGN':
        return 'лв'; // Bulgarian Lev
      case 'BHD':
        return 'ب.د'; // Bahraini Dinar
      case 'FR':
        return '€'; //French Euros
      case 'BIF':
        return 'Fr'; // Burundian Franc
      case 'BMD':
        return '\$'; // Bermudian Dollar
      case 'BND':
        return '\$'; // Brunei Dollar
      case 'BRL':
        return 'R\$'; // Brazilian Real
      case 'CAD':
        return '\$'; // Canadian Dollar
      case 'CHF':
        return 'CHF'; // Swiss Franc
      case 'CLP':
        return '\$'; // Chilean Peso
      case 'CNY':
        return '¥'; // Chinese Yuan
      case 'COP':
        return '\$'; // Colombian Peso
      case 'CRC':
        return '₡'; // Costa Rican Colón
      case 'CUP':
        return '₱'; // Cuban Peso
      case 'CZK':
        return 'Kč'; // Czech Koruna
      case 'DKK':
        return 'kr'; // Danish Krone
      case 'DOP':
        return 'RD\$'; // Dominican Peso
      case 'DZD':
        return 'د.ج'; // Algerian Dinar
      case 'EGP':
        return 'ج.م'; // Egyptian Pound
      case 'ERN':
        return 'Nfk'; // Eritrean Nakfa
      case 'ETB':
        return 'ብር'; // Ethiopian Birr
      case 'EUR':
        return '€'; // Euro
      case 'FJD':
        return '\$'; // Fijian Dollar
      case 'FKP':
        return '£'; // Falkland Islands Pound
      case 'GBP':
        return '£'; // British Pound Sterling
      case 'GEL':
        return '₾'; // Georgian Lari
      case 'GHS':
        return '₵'; // Ghanaian Cedi
      case 'GIP':
        return '£'; // Gibraltar Pound
      case 'GMD':
        return 'D'; // Gambian Dalasi
      case 'GNF':
        return 'Fr'; // Guinean Franc
      case 'GTQ':
        return 'Q'; // Guatemalan Quetzal
      case 'GYD':
        return '\$'; // Guyanese Dollar
      case 'HKD':
        return '\$'; // Hong Kong Dollar
      case 'HNL':
        return 'L'; // Honduran Lempira
      case 'HRK':
        return 'kn'; // Croatian Kuna
      case 'HTG':
        return 'G'; // Haitian Gourde
      case 'HUF':
        return 'Ft'; // Hungarian Forint
      case 'IDR':
        return 'Rp'; // Indonesian Rupiah
      case 'ILS':
        return '₪'; // Israeli New Shekel
      case 'INR':
        return '₹'; // Indian Rupee
      case 'IQD':
        return 'ع.د'; // Iraqi Dinar
      case 'IRR':
        return 'ریال'; // Iranian Rial
      case 'ISK':
        return 'kr'; // Icelandic Króna
      case 'JMD':
        return 'J\$'; // Jamaican Dollar
      case 'JPY':
        return '¥'; // Japanese Yen
      case 'KES':
        return 'Ksh'; // Kenyan Shilling
      case 'KGS':
        return 'с'; // Kyrgyzstani Som
      case 'KHR':
        return '៛'; // Cambodian Riel
      case 'KPW':
        return '₩'; // North Korean Won
      case 'KRW':
        return '₩'; // South Korean Won
      case 'KWD':
        return 'د.ك'; // Kuwaiti Dinar
      case 'KYD':
        return '\$'; // Cayman Islands Dollar
      case 'KZT':
        return '₸'; // Kazakhstani Tenge
      case 'LAK':
        return '₭'; // Laotian Kip
      case 'LBP':
        return 'ل.ل'; // Lebanese Pound
      case 'LKR':
        return 'Rs'; // Sri Lankan Rupee
      case 'LRD':
        return '\$'; // Liberian Dollar
      case 'LSL':
        return 'L'; // Lesotho Loti
      case 'LYD':
        return 'ل.د'; // Libyan Dinar
      case 'MAD':
        return 'د.م.'; // Moroccan Dirham
      case 'MDL':
        return 'L'; // Moldovan Leu
      case 'MGA':
        return 'Ar'; // Malagasy Ariary
      case 'MKD':
        return 'ден'; // Macedonian Denar
      case 'MMK':
        return 'K'; // Myanmar Kyat
      case 'MNT':
        return '₮'; // Mongolian Tögrög
      case 'MOP':
        return 'MOP\$'; // Macanese Pataca
      case 'MRU':
        return 'UM'; // Mauritanian Ouguiya
      case 'MUR':
        return '₨'; // Mauritian Rupee
      case 'MVR':
        return 'ރ'; // Maldivian Rufiyaa
      case 'MWK':
        return 'K'; // Malawian Kwacha
      case 'MXN':
        return '\$'; // Mexican Peso
      case 'MYR':
        return 'RM'; // Malaysian Ringgit
      case 'MZN':
        return 'MT'; // Mozambican Metical
      case 'NAD':
        return '\$'; // Namibian Dollar
      case 'NGN':
        return '₦'; // Nigerian Naira
      case 'NIO':
        return 'C\$'; // Nicaraguan Córdoba
      case 'NOK':
        return 'kr'; // Norwegian Krone
      case 'NZD':
        return '\$'; // New Zealand Dollar
      case 'OMR':
        return 'ر.ع.'; // Omani Rial
      case 'PAB':
        return 'B/. '; // Panamanian Balboa
      case 'PEN':
        return 'S/. '; // Peruvian Sol
      case 'PGK':
        return 'K'; // Papua New Guinean Kina
      case 'PHP':
        return '₱'; // Philippine Peso
      case 'PKR':
        return 'Rs'; // Pakistani Rupee
      case 'PLN':
        return 'zł'; // Polish Zloty
      case 'PYG':
        return '₲'; // Paraguayan Guarani
      case 'QAR':
        return 'ر.ق'; // Qatari Rial
      case 'RON':
        return 'lei'; // Romanian Leu
      case 'RSD':
        return 'Дин.'; // Serbian Dinar
      case 'RUB':
        return '₽'; // Russian Ruble
      case 'RWF':
        return 'Fr'; // Rwandan Franc
      case 'SAR':
        return 'ر.س'; // Saudi Riyal
      case 'SBD':
        return '\$'; // Solomon Islands Dollar
      case 'SCR':
        return '₨'; // Seychellois Rupee
      case 'SDG':
        return 'ج.س.'; // Sudanese Pound
      case 'SEK':
        return 'kr'; // Swedish Krona
      case 'SGD':
        return '\$'; // Singapore Dollar
      case 'SHP':
        return '£'; // Saint Helena Pound
      case 'SLL':
        return 'Le'; // Sierra Leonean Leone
      case 'SOS':
        return 'S'; // Somali Shilling
      case 'SRD':
        return '\$'; // Surinamese Dollar
      case 'SZL':
        return 'E'; // Swazi Lilangeni
      case 'THB':
        return '฿'; // Thai Baht
      case 'TJS':
        return 'ЅМ'; // Tajikistani Somoni
      case 'TMT':
        return 'T'; // Turkmenistani Manat
      case 'TND':
        return 'د.ت'; // Tunisian Dinar
      case 'TOP':
        return 'T'; // Tongan Paʻanga
      case 'TRY':
        return '₺'; // Turkish Lira
      case 'TTD':
        return 'TT\$'; // Trinidad and Tobago Dollar
      case 'TWD':
        return 'NT\$'; // New Taiwan Dollar
      case 'TZS':
        return 'TSh'; // Tanzanian Shilling
      case 'UAH':
        return '₴'; // Ukrainian Hryvnia
      case 'UGX':
        return 'USh'; // Ugandan Shilling
      case 'USD':
        return '\$'; // United States Dollar
      case 'UYU':
        return '\$'; // Uruguayan Peso
      case 'UZS':
        return 'лв'; // Uzbekistani Som
      case 'VES':
        return 'Bs.S'; // Venezuelan Bolívar Soberano
      case 'VND':
        return '₫'; // Vietnamese Dong
      case 'XAF':
        return 'Fr'; // Central African CFA Franc
      case 'XCD':
        return '\$'; // East Caribbean Dollar
      case 'XOF':
        return 'Fr'; // West African CFA Franc
      case 'XPF':
        return 'Fr'; // CFP Franc
      case 'YER':
        return 'ر.ي'; // Yemeni Rial
      case 'ZAR':
        return 'R'; // South African Rand
      case 'ZMW':
        return 'K'; // Zambian Kwacha
      case 'ZWL':
        return 'Z'; // Zimbabwean Dollar
      default:
        return currencyCode; // Return the code if symbol is not found
    }
  }
}
