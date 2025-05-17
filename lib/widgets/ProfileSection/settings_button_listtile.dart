import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hope/utilities/app.constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Constants/colors.dart';
import '../../utilities/text.utility.dart' show AllText;

class SettingsButtonListTile extends StatefulWidget {
  final String iconPath;
  final String title;
  final String trailingIconPath;
  final VoidCallback? onTap;

  final List<String>? dropdownItems;
  final String? selectedItem;
  final ValueChanged<String>? onDropdownChanged;
  final bool enableDropdownTrailing;
  final bool? showIcon;
  final bool enableToggle;
  final bool? toggleValue;
  final ValueChanged<bool>? onToggleChanged;

  const SettingsButtonListTile({
    super.key,
    required this.iconPath,
    required this.title,
    required this.trailingIconPath,
    this.onTap,
    this.dropdownItems,
    this.selectedItem,
    this.onDropdownChanged,
    this.enableDropdownTrailing = false,
    this.enableToggle = false,
    this.toggleValue,
    this.onToggleChanged,
    this.showIcon = true,
  });

  @override
  State<SettingsButtonListTile> createState() => _SettingsButtonListTileState();
}

class _SettingsButtonListTileState extends State<SettingsButtonListTile> {
  late String? _selectedItem;
  late bool _toggleState;
  late SharedPreferences _prefs;

  bool get _isDropdownEnabled =>
      widget.dropdownItems != null && widget.enableDropdownTrailing;

  bool get _isToggleEnabled => widget.enableToggle;

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.selectedItem;
    _toggleState = widget.toggleValue ?? false;
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    if (widget.title == "Voiceover") {
      _selectedItem =
          _prefs.getString('voiceover_gender') ?? widget.selectedItem;
    }
  }

  void _showCupertinoPicker() {
    showCupertinoModalPopup(
      context: context,
      builder:
          (BuildContext context) => Container(
            height: 200.h,
            color: secondaryBlack,
            child: Column(
              children: [
                Container(
                  height: 60.h,
                  color: secondaryGrey,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CupertinoButton(
                        child: const AllText(text: 'Cancel'),
                        onPressed: () => Navigator.pop(context),
                      ),
                      CupertinoButton(
                        child: const AllText(text: 'Done'),
                        onPressed: () {
                          Navigator.pop(context);
                          if (widget.title == "Voiceover") {
                            _prefs.setString(
                              'voiceover_gender',
                              _selectedItem!,
                            );

                            AppConstants.isMale =
                                _selectedItem == "Male" ? true : false;
                          }
                          widget.onDropdownChanged?.call(_selectedItem!);
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: CupertinoPicker(
                    backgroundColor: secondaryBlack,
                    itemExtent: 32.h,
                    onSelectedItemChanged: (int index) {
                      setState(() {
                        _selectedItem = widget.dropdownItems![index];
                      });
                    },
                    children:
                        widget.dropdownItems!
                            .map(
                              (item) => Center(
                                child: AllText(
                                  text: item,
                                  style: TextStyle(
                                    color: textWhite,
                                    fontSize: 16.sp,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: _isDropdownEnabled ? _showCupertinoPicker : widget.onTap,
          child: Container(
            width: 350.w,
            height: 72.h,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            decoration: BoxDecoration(
              color: secondaryGrey,
              borderRadius: BorderRadius.circular(99.sp),
            ),
            child: Row(
              children: [
                if (widget.showIcon == true)
                  SvgPicture.asset(widget.iconPath, height: 24.h, width: 24.w),
                SizedBox(width: 16.w),
                Expanded(
                  child: AllText(
                    text: widget.title,
                    style: TextStyle(
                      color: textWhite,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (_isToggleEnabled)
                  CupertinoSwitch(
                    value: _toggleState,
                    thumbColor: secondaryBlack,
                    activeTrackColor: accentWhite,
                    inactiveThumbColor: accentWhite,
                    inactiveTrackColor: secondaryBlack,
                    onChanged: (val) {
                      setState(() {
                        _toggleState = val;
                      });
                      widget.onToggleChanged?.call(val);
                    },
                  )
                else if (_isDropdownEnabled) ...[
                  if (_selectedItem != null)
                    Padding(
                      padding: EdgeInsets.only(right: 6.w),
                      child: AllText(
                        text: _selectedItem!,
                        style: TextStyle(
                          color: const Color(0xffF3EDDC),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 24.sp,
                    color: textWhite.withOpacity(0.8),
                  ),
                ] else
                  SvgPicture.asset(
                    widget.trailingIconPath,
                    height: 24.h,
                    width: 24.w,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
