
import 'package:flutter/material.dart';

import 'useful_focus_parent.dart';

/// 焦点按钮
class UsefulFocusButton extends StatelessWidget {
  const UsefulFocusButton({
    Key? key,
    required this.onClickListener,
    required this.autoFocus,
    required this.textContent,
    this.focusStyleModel = const FocusButtonStyleModel(),
  }) : super(key: key);

  // 点击回调
  final VoidCallback onClickListener;
  // 是否自动获取焦点
  final bool autoFocus;
  // 按钮文本内容
  final String textContent;
  // 按钮样式类
  final FocusButtonStyleModel focusStyleModel;

  @override
  Widget build(BuildContext context) {
    return UsefulFocusParent(
      margin: focusStyleModel.margin,
      onClickListener: onClickListener,
      autoFocus: autoFocus,
      childBuilder: (hasFocus) {
        final backgroundColor = hasFocus ? focusStyleModel.focusBackgroundColor : focusStyleModel.unFocusBackgroundColor;
        final textColor = hasFocus ? focusStyleModel.focusTextColor : focusStyleModel.unFocusTextColor;
        return IntrinsicWidth(
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(focusStyleModel.radius),
            ),
            child: Center(
              child: Padding(
                padding: focusStyleModel.padding,
                child: Text(
                  textContent,
                  style: TextStyle(
                    color: textColor,
                    fontSize: focusStyleModel.fontSize,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// 焦点按钮样式类
class FocusButtonStyleModel {
  const FocusButtonStyleModel({
    this.focusBackgroundColor = Colors.blue,
    this.focusTextColor = Colors.white,
    this.unFocusBackgroundColor = const Color.fromARGB(255, 220, 220, 220),
    this.unFocusTextColor = Colors.black26,
    this.fontSize = 16,
    this.radius = 4,
    this.padding = const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
    this.margin = const EdgeInsets.all(5),
  });
  // 有焦点时的背景颜色
  final Color focusBackgroundColor;
  // 无焦点时的背景颜色
  final Color unFocusBackgroundColor;
  // 有焦点时的文本颜色
  final Color focusTextColor;
  // 无焦点时的文本颜色
  final Color unFocusTextColor;
  // 文字大小
  final double fontSize;
  // 按钮圆角
  final double radius;
  // 按钮的内边距
  final EdgeInsetsGeometry padding;
  // 按钮的外边距
  final EdgeInsetsGeometry margin;
}