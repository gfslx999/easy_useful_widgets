import 'package:flutter/material.dart';

/// 默认间隔时间
const _defaultIntervalMillSeconds = 1000;

/// 用于防止重复点击的按钮
///
/// 该组件用于避免两个组件之间的点击事件间隔互相影响，各自独立
class UsefulDebounceButton extends StatefulWidget {
  const UsefulDebounceButton({
    Key? key,
    required this.onClickListener,
    required this.child,
    this.intervalMillSeconds = _defaultIntervalMillSeconds,
    this.margin,
  }) : super(key: key);

  /// 子控件，不要在子控件内处理点击事件，请使用 [onClickListener]
  final Widget child;
  /// 点击回调
  final VoidCallback onClickListener;
  /// 间隔时长，默认： [_defaultIntervalMillSeconds]
  final int intervalMillSeconds;
  /// 当前组件的边距，默认为空
  final EdgeInsetsGeometry? margin;

  @override
  State<UsefulDebounceButton> createState() => _UsefulDebounceButtonState();
}

class _UsefulDebounceButtonState extends State<UsefulDebounceButton> {
  // 上次点击生效的时间
  int _currentLastTakeEffectClickTime = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        onTap: () {
          // 防止重复点击
          // 这里指定'上次点击生效的时间'，以达到每个组件互相独立的效果
          _currentLastTakeEffectClickTime = preventDoubleClick(
              widget.onClickListener,
              intervalMillSeconds: widget.intervalMillSeconds,
              lastTakeEffectClickTime: _currentLastTakeEffectClickTime
          );
        },
        child: widget.child,
      ),
    );
  }
}

/// 上次点击生效的时间
int _lastTakeEffectClickTime = 0;

/// 防止重复点击
///
/// [func] 要执行的方法
/// [intervalMillSeconds] 防止重复点击的间隔，毫秒
/// [lastTakeEffectClickTime] 用于自定义上次点击生效的时间，一般无需传递此值
///
/// ⚠️ 直接使用从方法会导致一个问题：例如页面A中的按钮，使用了此方法，点击A按钮，跳转到了页面B，
/// 页面B按钮如果也使用了此方法，并且此时距离页面A的 [intervalMillSeconds] 还没有结束，
/// 就会导致页面B按钮暂时无法点击，直到 [intervalMillSeconds] 过时
///
/// 简单来说就是此方法会导致两个组件间相互影响，若要避免此影响，请使用 [UsefulDebounceButton]
int preventDoubleClick(VoidCallback func,{
  int intervalMillSeconds = _defaultIntervalMillSeconds,
  int? lastTakeEffectClickTime
}) {
  final currentTime = DateTime.now().millisecondsSinceEpoch;
  // 获取上次点击生效的时间
  int useLastTakeEffectClickTime = lastTakeEffectClickTime ?? _lastTakeEffectClickTime;
  // 判断当前时间与上次点击时间是否已经大于了指定间隔
  if (currentTime - useLastTakeEffectClickTime >= intervalMillSeconds) {
    func();
    // 更新点击生效时间时间
    if (lastTakeEffectClickTime == null) {
      _lastTakeEffectClickTime = currentTime;
    } else {
      useLastTakeEffectClickTime = currentTime;
    }
  }
  return useLastTakeEffectClickTime;
}