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
import 'package:hope/screens/home_screen.dart';
import 'package:purchases_flutter/purchases_flutter.dart'
    show CustomerInfo, EntitlementInfo, Offering, Purchases;
import 'package:intl/intl.dart';
import '../../utilities/app.constants.dart'
    show AppConstants, EntitleMents, Utils;
import '../../widgets/PricingSection/pricing_tab_selector.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../onboarding/controllers/onboarding.controller.dart'
    show OnboardingController;
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
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  widget.isMainScreen
                      ? const SizedBox()
                      : Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 15.h),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: ClipRRect(
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 6,
                                    sigmaY: 6,
                                  ),
                                  child: Container(
                                    width: 42.w,
                                    height: 42.h,
                                    decoration: BoxDecoration(
                                      color: CupertinoColors.systemGrey
                                          .withOpacity(0.2),
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
                  SizedBox(height: 50.h),
                  Text(
                    'Transform your \nSpiritual Journey \nToday',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFFFF5DE),
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 55.h),
                  PricingTabSelector(),
                  SizedBox(height: 18.h),
                  Container(
                    width: 357.w,
                    height: 334.h,
                    padding: EdgeInsets.symmetric(
                      vertical: 10.h,
                      horizontal: 16.w,
                    ),
                    decoration: BoxDecoration(
                      color: cardGrey.withValues(alpha: .4),
                      borderRadius: BorderRadius.circular(12.sp),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _featureRow(
                          'assets/images/pricing_option_1.png',
                          'Your Faith, Your Way',
                          'Instantly tailor your experience based on your denomination, age, and spiritual journey—get content that actually speaks to you.',
                        ),
                        Divider(color: textWhite.withValues(alpha: .08)),
                        _featureRow(
                          'assets/images/pricing_option_2.png',
                          ' Peace on Demand',
                          'Access daily devotionals, guided prayers, and calming reflections anytime you need clarity or calm.',
                        ),
                        Divider(color: textWhite.withValues(alpha: .08)),
                        _featureRow(
                          'assets/images/pricing_option_3.png',
                          'Growing Spiritual Community',
                          'You’re not alone—10,000+ believers like you are already praying, growing, and sharing through the app.',
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
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
                                    body: HomeScreen(),
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
                                    body: AuthPage(login: true),
                                  ),
                            ),
                          );
                        }
                      } on PlatformException catch (e) {
                        Utils.logger.i(e);
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
                        // Handle other purchase errors if needed.
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
                        color: accentYellow,
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
                                    ? "Subscribe for ${NumberFormat.currency(symbol: getCurrencySymbol(myProductList![1].storeProduct.currencyCode.toUpperCase()), decimalDigits: 2).format(myProductList[1].storeProduct.price)}/y"
                                    : "Subscribe for ${NumberFormat.currency(symbol: getCurrencySymbol(myProductList![2].storeProduct.currencyCode.toUpperCase()), decimalDigits: 2).format(myProductList[2].storeProduct.price)}/mo",
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
                  SizedBox(height: 18.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _featureRow(String asset, String title, String subtitle) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipOval(
            child: Image.asset(
              asset,
              width: 63.w,
              height: 63.h,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: textWhite,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: textGrey,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
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
