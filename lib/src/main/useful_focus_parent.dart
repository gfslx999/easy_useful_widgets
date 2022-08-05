
import 'package:flutter/material.dart';

/// 焦点容器
///
/// 当前组件默认提供带焦点时边框样式，
class UsefulFocusParent extends StatefulWidget {
  const UsefulFocusParent({
    Key? key,
    this.child,
    this.usefulFocusBuilder,
    this.autoFocus = false,
    this.focusNode,
    this.borderRadius = 8,
    this.borderColor = Colors.lightBlue,
    this.paddingToBorder,
    this.margin,
    this.onClickListener,
  }) : super(key: key);

  /// 是否自动获取焦点
  final bool autoFocus;
  /// 用于自定义处理焦点逻辑
  final FocusNode? focusNode;
  final Widget? child;
  /// 回调是否有焦点的一个组件，如果你想自定义焦点样式ui，请使用这个;
  /// 使用此事件，点击事件也需要自己处理，这里只负责回调是否有焦点
  final UsefulFocusBuilder? usefulFocusBuilder;
  /// 边框圆角
  final double borderRadius;
  /// 边框颜色
  final Color borderColor;
  /// 子组件到边框的距离
  final EdgeInsetsGeometry? paddingToBorder;
  /// 边框到外部的距离
  final EdgeInsetsGeometry? margin;
  /// 点击事件回调
  final VoidCallback? onClickListener;

  @override
  State<StatefulWidget> createState() => _UsefulFocusParentState();
}

class _UsefulFocusParentState extends State<UsefulFocusParent> {

  @override
  Widget build(BuildContext context) {
    return Focus(
      canRequestFocus: true,
      autofocus: widget.autoFocus,
      child: Builder(builder: (context) {
        final hasFocus = Focus.of(context).hasFocus || (widget.focusNode?.hasFocus ?? false);
        // 如果 usefulFocusBuilder 不为空，代表用户需要自定义UI样式
        if (widget.usefulFocusBuilder != null) {
          return widget.usefulFocusBuilder!(hasFocus);
        }
        final border = Border.all(
          color: hasFocus ? widget.borderColor : Colors.transparent,
        );
        return InkWell(
          canRequestFocus: false,
          onTap: widget.onClickListener,
          child: Container(
            margin: widget.margin,
            decoration: BoxDecoration(
              border: border,
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
            child: Padding(
              padding: widget.paddingToBorder ?? const EdgeInsets.all(5),
              child: widget.child,
            ),
          ),
        );
      }),
    );
  }

}

/// 用于用户自定义Ui时，回调当前是否有焦点
typedef UsefulFocusBuilder = Widget Function(bool hasFocus);