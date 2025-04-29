import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../Constants/colors.dart';

class SettingsButtonListTile extends StatefulWidget {
  final String iconPath;
  final String title;
  final String trailingIconPath;
  final VoidCallback? onTap;

  final List<String>? dropdownItems;
  final String? selectedItem;
  final ValueChanged<String>? onDropdownChanged;
  final bool enableDropdownTrailing;

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
  });

  @override
  State<SettingsButtonListTile> createState() => _SettingsButtonListTileState();
}

class _SettingsButtonListTileState extends State<SettingsButtonListTile> {
  bool _expanded = false;
  late String? _selectedItem;
  late bool _toggleState;

  bool get _isDropdownEnabled =>
      widget.dropdownItems != null && widget.enableDropdownTrailing;

  bool get _isToggleEnabled => widget.enableToggle;

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.selectedItem;
    _toggleState = widget.toggleValue ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap:
              _isDropdownEnabled
                  ? () {
                    setState(() {
                      _expanded = !_expanded;
                    });
                  }
                  : widget.onTap,
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
                SvgPicture.asset(widget.iconPath, height: 24.h, width: 24.w),
                SizedBox(width: 16.w),
                Expanded(
                  child: Text(
                    widget.title,
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
                      child: Text(
                        _selectedItem!,
                        style: TextStyle(
                          color: const Color(0xffF3EDDC),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
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
        if (_expanded && _isDropdownEnabled)
          Container(
            width: 350.w,
            margin: EdgeInsets.only(top: 8.h),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: secondaryGrey,
              borderRadius: BorderRadius.circular(20.sp),
            ),
            child: Column(
              children:
                  widget.dropdownItems!
                      .map(
                        (item) => GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedItem = item;
                              _expanded = false;
                            });
                            widget.onDropdownChanged?.call(item);
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                            child: Row(
                              children: [
                                Icon(
                                  _selectedItem == item
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_off,
                                  color: textWhite,
                                  size: 18.sp,
                                ),
                                SizedBox(width: 12.w),
                                Text(
                                  item,
                                  style: TextStyle(
                                    color: textWhite,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
            ),
          ),
      ],
    );
  }
}
