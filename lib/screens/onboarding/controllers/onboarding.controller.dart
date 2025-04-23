import 'package:get/get.dart';

import '../../../utilities/app.constants.dart' show Utils;

/// OnboardingController handles the state and logic for the onboarding flow
/// This controller is designed to be flexible and handle various types of data
/// for different onboarding pages
class OnboardingController extends GetxController {
  // Store all page data in a single map
  final RxMap<int, dynamic> _pageData = <int, dynamic>{}.obs;

  // Track completion status for each page
  final RxMap<int, bool> _pageCompletion = <int, bool>{}.obs;

  // Current page index
  final RxInt _currentPage = 0.obs;

  // Total number of pages
  final int totalPages;

  // Selected denomination
  final Rx<String?> _selectedDenomination = Rx<String?>(null);
  String? get selectedDenomination => _selectedDenomination.value;

  OnboardingController({required this.totalPages}) {
    // Initialize all pages as incomplete
    for (int i = 0; i < totalPages; i++) {
      _pageCompletion[i] = false;
    }
  }

  /// Getters
  int get currentPage => _currentPage.value;
  Map<int, dynamic> get allPageData => _pageData;
  bool isPageComplete(int page) => _pageCompletion[page] ?? false;

  // Get data for a specific page
  T? getPageData<T>(int page) => _pageData[page] as T?;

  // Update data and completion status for a page
  void updatePageData(int page, dynamic data) {
    Utils.logger.f("Updating page $page with data: $data");
    _pageData[page] = data;
    _pageCompletion[page] = true;
    update();
  }

  // Check if can proceed to next page
  bool canProceedFromPage(int page) => _pageCompletion[page] ?? false;

  // Navigation methods
  void nextPage() {
    if (currentPage < totalPages - 1 && canProceedFromPage(currentPage)) {
      _currentPage.value++;
      update();
    }
  }

  void previousPage() {
    if (currentPage > 0) {
      _currentPage.value--;
      update();
    }
  }

  // Update current page directly
  void setCurrentPage(int page) {
    if (page >= 0 && page < totalPages) {
      _currentPage.value = page;
      update();
    }
  }

  /// Set the selected denomination
  void setDenomination(String? denomination) {
    _selectedDenomination.value = denomination;
    // Also store in page data for consistency
    _pageData[0] = denomination;
    // Update validation for the denomination page
    _pageCompletion[0] = denomination != null;
    update();
  }

  /// Reset all data
  void resetOnboarding() {
    _pageData.clear();
    for (int i = 0; i < totalPages; i++) {
      _pageCompletion[i] = false;
    }
    _currentPage.value = 0;
    _selectedDenomination.value = null;
    update();
  }

  /// Get progress
  double get progress => (currentPage + 1) / totalPages;

  @override
  void onClose() {
    // Clean up any resources if needed
    super.onClose();
  }
}
