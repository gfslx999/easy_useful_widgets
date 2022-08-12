import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 焦点容器
///
/// 当前组件默认提供带焦点时边框样式，最简单的使用：
/// 仅传递 [child] 、[autoFocus]、[onClickListener]
class UsefulFocusParent extends StatefulWidget {
  UsefulFocusParent({
    Key? key,
    required this.onClickListener,
    required this.autoFocus,
    this.child,
    this.childBuilder,
    this.focusNode,
    this.borderRadius = 8,
    this.borderColor = Colors.lightBlue,
    this.paddingToBorder,
    this.margin,
    this.onKey,
  }) : super(key: key) {
    // 两个属性，必须传入其中一个
    if (child == null && childBuilder == null) {
      throw ArgumentError("child and childBuilder, you must chose on of them.");
    }
  }

  /// 是否自动获取焦点
  final bool autoFocus;
  /// 子组件，如传入 [childBuilder]，[child] 将失效
  final Widget? child;
  /// 可自定义焦点ui样式的子组件回调，回调当前是否有焦点
  final UsefulFocusBuilder? childBuilder;
  /// 组件外部的距离
  final EdgeInsetsGeometry? margin;
  /// 点击事件回调
  final VoidCallback onClickListener;
  /// 自定义处理焦点事件
  final FocusOnKeyCallback? onKey;
  /// 自定义处理焦点事件
  final FocusNode? focusNode;

  /// ⚠️下面的变量仅在传入 [child] 时生效
  /// 边框圆角
  final double borderRadius;
  /// 边框颜色
  final Color borderColor;
  /// 子组件到边框的距离
  final EdgeInsetsGeometry? paddingToBorder;

  @override
  State<StatefulWidget> createState() => _UsefulFocusParentState();
}

class _UsefulFocusParentState extends State<UsefulFocusParent> {

  @override
  Widget build(BuildContext context) {
    FocusOnKeyCallback onKeyCallback;
    // 如果未指定，则只处理确认事件
    if (widget.onKey == null) {
      onKeyCallback = (node, event) {
        if (event is RawKeyUpEvent && event.logicalKey == LogicalKeyboardKey.select) {
          widget.onClickListener();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      };
    } else {
      onKeyCallback = widget.onKey!;
    }

    return Focus(
      canRequestFocus: true,
      autofocus: widget.autoFocus,
      onKey: onKeyCallback,
      focusNode: widget.focusNode,
      child: Builder(builder: (context) {
        final hasFocus = Focus.of(context).hasFocus || (widget.focusNode?.hasFocus ?? false);
        // 如果 childBuilder 不为空，代表用户需要自定义UI样式
        if (widget.childBuilder != null) {
          return Container(
            margin: widget.margin,
            child: InkWell(
              canRequestFocus: false,
              onTap: widget.onClickListener,
              child: widget.childBuilder!(hasFocus),
            ),
          );
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

/// 用于用户自定义焦点Ui时，回调当前是否有焦点，并需要返回一个 Widget
typedef UsefulFocusBuilder = Widget Function(bool hasFocus);