part of '../sliver_sticky_header.dart';

class _RenderStickyHeaderLayoutBuilder extends RenderBox
    with RenderObjectWithChildMixin<RenderBox> {
  _RenderStickyHeaderLayoutBuilder({
    LayoutCallback<_StickyHeaderConstraints> callback,
  }) : _callback = callback;

  LayoutCallback<_StickyHeaderConstraints> _callback;

  LayoutCallback<_StickyHeaderConstraints> get callback => _callback;

  set callback(LayoutCallback<_StickyHeaderConstraints> value) {
    if (value != _callback) {
      _callback = value;
      markNeedsLayout();
    }
  }

  @override
  _StickyHeaderConstraints get constraints => super.constraints;

  @override
  double computeMinIntrinsicWidth(double height) => 0;

  @override
  double computeMaxIntrinsicWidth(double height) => 0;

  @override
  double computeMinIntrinsicHeight(double width) => 0;

  @override
  double computeMaxIntrinsicHeight(double width) => 0;

  @override
  void performLayout() {
    invokeLayoutCallback(callback);

    if (child != null) {
      child.layout(constraints, parentUsesSize: true);

      size = constraints.constrain(child.size);
    } else {
      size = constraints.biggest;
    }
  }

  @override
  bool hitTestChildren(HitTestResult result, {Offset position}) =>
      child?.hitTest(result, position: position) ?? false;

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) {
      context.paintChild(child, offset);
    }
  }
}
