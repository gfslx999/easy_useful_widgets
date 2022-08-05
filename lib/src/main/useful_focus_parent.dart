
import 'package:easy_useful_widgets/easy_useful_widgets.dart';
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
    this.child,
    this.childBuilder,
    this.autoFocus = false,
    this.focusNode,
    this.borderRadius = 8,
    this.borderColor = Colors.lightBlue,
    this.paddingToBorder,
    this.margin,
    this.onKey,
    this.intervalMillSeconds = 500,
  }) : super(key: key) {
    assert(child != null || childBuilder != null, "child and usefulFocusBuilder, you must chose on of them.");
  }

  /// 是否自动获取焦点
  final bool autoFocus;
  /// 子组件，如传入 [childBuilder]，[child] 将失效
  final Widget? child;
  /// 回调是否有焦点的一个组件，如果你想自定义焦点样式ui，请使用这个
  final UsefulFocusBuilder? childBuilder;
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
  /// 自定义处理焦点事件
  final FocusOnKeyCallback? onKey;
  /// 自定义处理焦点事件
  final FocusNode? focusNode;
  /// 防重复点击的间隔时间，默认 500ms
  final int intervalMillSeconds;

  @override
  State<StatefulWidget> createState() => _UsefulFocusParentState();
}

class _UsefulFocusParentState extends State<UsefulFocusParent> {

  /// 上次点击生效的时间
  int _lastTakeEffectClickTime = 0;

  @override
  Widget build(BuildContext context) {
    FocusOnKeyCallback onKeyCallback;
    // 如果未指定，则只处理确认事件
    if (widget.onKey == null) {
      onKeyCallback = (node, event) {
        if (widget.onClickListener != null &&
            event is RawKeyUpEvent && event.logicalKey == LogicalKeyboardKey.select) {
          executeOnClick();
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
        // 如果 usefulFocusBuilder 不为空，代表用户需要自定义UI样式
        if (widget.childBuilder != null) {
          return InkWell(
            canRequestFocus: false,
            onTap: () {
              executeOnClick();
            },
            child: widget.childBuilder!(hasFocus),
          );
        }
        final border = Border.all(
          color: hasFocus ? widget.borderColor : Colors.transparent,
        );
        return InkWell(
          canRequestFocus: false,
          onTap: () {
            executeOnClick();
          },
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

  /// 执行点击操作
  void executeOnClick() {
    _lastTakeEffectClickTime = preventDoubleClick(
        widget.onClickListener!,
        intervalMillSeconds: widget.intervalMillSeconds,
        lastTakeEffectClickTime: _lastTakeEffectClickTime
    );
  }

}

/// 用于用户自定义Ui时，回调当前是否有焦点
typedef UsefulFocusBuilder = Widget Function(bool hasFocus);