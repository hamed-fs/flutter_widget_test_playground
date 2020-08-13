part of '../sliver_sticky_header.dart';

class _StickyHeaderConstraints extends BoxConstraints {
  _StickyHeaderConstraints({
    @required this.state,
    @required BoxConstraints boxConstraints,
  }) : super(
          minWidth: boxConstraints.minWidth,
          maxWidth: boxConstraints.maxWidth,
          minHeight: boxConstraints.minHeight,
          maxHeight: boxConstraints.maxHeight,
        );

  final SliverStickyHeaderState state;

  @override
  bool get isNormalized =>
      state.scrollPercentage >= 0.0 &&
      state.scrollPercentage <= 1.0 &&
      super.isNormalized;

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is! _StickyHeaderConstraints) {
      return false;
    }

    return state == other.state &&
        minWidth == other.minWidth &&
        maxWidth == other.maxWidth &&
        minHeight == other.minHeight &&
        maxHeight == other.maxHeight;
  }

  @override
  int get hashCode =>
      hashValues(minWidth, maxWidth, minHeight, maxHeight, state);
}
