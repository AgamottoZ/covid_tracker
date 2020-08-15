import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:covid_tracker/utils/constants.dart';

class SliverDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(height: kDividerHeight),
    );
  }
}

class SliverContainer extends StatelessWidget {
  final Alignment alignment;
  final Color color;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Decoration decoration;
  final Widget child;
  final double sliverWidth;
  final double sliverHeight;
  final BoxConstraints sliverConstraints;

  SliverContainer({
    Key key,
    this.alignment,
    this.padding,
    this.color,
    this.decoration,
    this.sliverWidth,
    this.sliverHeight,
    this.sliverConstraints,
    this.margin,
    this.child,
  })  : assert(margin == null || margin.isNonNegative),
        assert(padding == null || padding.isNonNegative),
        assert(decoration == null || decoration.debugAssertIsValid()),
        assert(sliverConstraints == null || sliverConstraints.debugAssertIsValid()),
        assert(
            color == null || decoration == null,
            'Cannot provide both a color and a decoration\n'
            'To provide both, use "decoration: BoxDecoration(color: color)".'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
          color: color,
          decoration: decoration,
          alignment: alignment,
          padding: padding,
          width: sliverWidth,
          height: sliverHeight,
          constraints: sliverConstraints,
          margin: margin,
          child: child),
    );
  }
}
