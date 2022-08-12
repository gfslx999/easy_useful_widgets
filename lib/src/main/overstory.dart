/// 防重复点击/防抖/节流
///
/// [action] 要执行的方法
/// [intervalDuration] 间隔多长时间执行，默认1秒
///
/// 'example':
///     InkWell(
///       onTap: debounce(() {
///         // 这里最快的回调速度为 1秒/次
///       }, intervalDuration: const Duration(seconds: 1)),
///       child: const Text('Test Click'),
///     );
dynamic debounce(Function action, {
  Duration intervalDuration = const Duration(seconds: 1),
}) {
  // 上次点击生效的时间, 单位：毫秒
  // 由于闭包特性，这个变量会被每个方法绑定，相当与为每个调用此方法的地方，声明一个独立的全局变量
  int lastTakeEffectClickTime = 0;

  // 声明闭包函数
  closureFunction (){
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    // 判断当前时间与上次点击时间是否已经大于了指定间隔
    if (currentTime - lastTakeEffectClickTime >= intervalDuration.inMilliseconds) {
      action();
      // 更新点击生效时间时间
      lastTakeEffectClickTime = currentTime;
    }
  }
  return closureFunction;
}