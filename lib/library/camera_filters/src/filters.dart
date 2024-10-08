import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

@immutable
class FilterSelector extends StatefulWidget {
  const FilterSelector({
    Key? key,
    required this.filters,
    required this.onFilterChanged,
    required this.onTap,
    this.onVideoFilter = false,
    this.padding = const EdgeInsets.symmetric(vertical: 24.0),
    this.onLongPress,
    this.onLongPressEnd,
  }) : super(key: key);

  ///List of filters Color
  final List<Color> filters;

  /// function will call when a user changes the filter
  final void Function(Color selectedColor) onFilterChanged;

  final EdgeInsets padding;

  /// when you tap on filter this on tap will call
  final GestureTapCallback? onTap;

  final GestureTapCallback? onLongPress;

  final Function(LongPressEndDetails)? onLongPressEnd;

  /// filter for camera or video condition
  final bool? onVideoFilter;

  @override
  _FilterSelectorState createState() => _FilterSelectorState();
}

class _FilterSelectorState extends State<FilterSelector> {
  /// filter per screen is by default five
  static const _filtersPerScreen = 5;

  /// screen responsiveness with filters
  static const _viewportFractionPerItem = 1.0 / _filtersPerScreen;

  ///initializer of page controller
  late final PageController _controller;

  ///page number
  late int _page;

  /// filter count form filter list
  int get filterCount => widget.filters.length;

  Color itemColor(int index) => widget.filters[index % filterCount];

  @override
  void initState() {
    super.initState();
    _page = 0;
    _controller = PageController(
      initialPage: _page,
      viewportFraction: _viewportFractionPerItem,
    );
    _controller.addListener(_onPageChanged);
    setState(() {});
  }

  /// call when filter changes
  void _onPageChanged() {
    final page = (_controller.page ?? 0).round();

    if (page != _page) {
      _page = page;
      Future.delayed(
        const Duration(microseconds: 1),
        () {
          HapticFeedback.lightImpact();
        },
      );
      widget.onFilterChanged(widget.filters[page]);
    }
  }

  ///call when tap on filters
  void _onFilterTapped(int index) {
    _controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 450),
      curve: Curves.ease,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollable(
      controller: _controller,
      axisDirection: AxisDirection.right,
      physics: const PageScrollPhysics(),
      viewportBuilder: (context, viewportOffset) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final itemSize = constraints.maxWidth * _viewportFractionPerItem;
            viewportOffset
              ..applyViewportDimension(constraints.maxWidth)
              ..applyContentDimensions(0.0, itemSize * (filterCount - 1));

            return Stack(
              alignment: Alignment.bottomCenter,
              children: [
                _buildShadowGradient(itemSize),
                SafeArea(
                  child: _buildCarousel(
                    onVideoFilter: widget.onVideoFilter!,
                    viewportOffset: viewportOffset,
                    itemSize: itemSize,
                  ),
                ),
                widget.onVideoFilter == true
                    ? Container()
                    : SafeArea(child: _buildSelectionRing(itemSize)),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildShadowGradient(double itemSize) {
    return SizedBox(
      height: itemSize * 2 + widget.padding.vertical,
      child: const DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black,
            ],
          ),
        ),
        child: SizedBox.expand(),
      ),
    );
  }

  ///carousel slider of filters
  Widget _buildCarousel({
    required ViewportOffset viewportOffset,
    required double itemSize,
    required bool onVideoFilter,
  }) {
    return Container(
      height: itemSize,
      margin: widget.padding,
      child: Flow(
        delegate: CarouselFlowDelegate(
          viewportOffset: viewportOffset,
          filtersPerScreen: _filtersPerScreen,
        ),
        children: [
          for (int i = 0; i < filterCount; i++)
            FilterItem(
              onVideoFilter: onVideoFilter,
              onFilterSelected: () => _onFilterTapped(i),
              color: itemColor(i),
            ),
        ],
      ),
    );
  }

  /// filters ui
  Widget _buildSelectionRing(double itemSize) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      onLongPressEnd: widget.onLongPressEnd,
      child: IgnorePointer(
        child: Padding(
          padding: widget.padding,
          child: SizedBox(
            width: itemSize,
            height: itemSize,
            child: const DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.fromBorderSide(
                  BorderSide(width: 6.0, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CarouselFlowDelegate extends FlowDelegate {
  CarouselFlowDelegate({
    required this.viewportOffset,
    required this.filtersPerScreen,
  }) : super(repaint: viewportOffset);

  final ViewportOffset viewportOffset;
  final int filtersPerScreen;

  @override
  void paintChildren(FlowPaintingContext context) {
    final count = context.childCount;

    /// All available painting width
    final size = context.size.width;

    /// The distance that a single item "page" takes up from the perspective
    /// of the scroll paging system. We also use this size for the width and
    /// height of a single item.
    final itemExtent = size / filtersPerScreen;

    /// The current scroll position expressed as an item fraction, e.g., 0.0,
    /// or 1.0, or 1.3, or 2.9, etc. A value of 1.3 indicates that item at
    /// index 1 is active, and the user has scrolled 30% towards the item at
    /// index 2.
    final active = viewportOffset.pixels / itemExtent;

    /// Index of the first item we need to paint at this moment.
    /// At most, we paint 3 items to the left of the active item.
    final int min = math.max(0, active.floor() - 3);

    /// Index of the last item we need to paint at this moment.
    /// At most, we paint 3 items to the right of the active item.
    final int max = math.min(count - 1, active.ceil() + 3);

    /// Generate transforms for the visible items and sort by distance.
    for (var index = min; index <= max; index++) {
      final itemXFromCenter = itemExtent * index - viewportOffset.pixels;
      final percentFromCenter = 1.0 - (itemXFromCenter / (size / 2)).abs();
      final itemScale = 0.5 + (percentFromCenter * 0.5);
      final opacity = 0.25 + (percentFromCenter * 0.75);

      final itemTransform = Matrix4.identity()
        ..translate((size - itemExtent) / 2)
        ..translate(itemXFromCenter)
        ..translate(itemExtent / 2, itemExtent / 2)
        ..multiply(Matrix4.diagonal3Values(itemScale, itemScale, 1.0))
        ..translate(-itemExtent / 2, -itemExtent / 2);

      context.paintChild(
        index,
        transform: itemTransform,
        opacity: opacity,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CarouselFlowDelegate oldDelegate) {
    return oldDelegate.viewportOffset != viewportOffset;
  }
}

@immutable
class FilterItem extends StatelessWidget {
  const FilterItem({
    Key? key,
    required this.color,
    required this.onVideoFilter,
    this.onFilterSelected,
  }) : super(key: key);

  final Color color;
  final bool onVideoFilter;
  final VoidCallback? onFilterSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onFilterSelected,
      child: onVideoFilter == true
          ? Container()
          : AspectRatio(
              aspectRatio: 1.0,
              child: ClipOval(
                child: Image.network(
                  'https://github.com/hamzasidd3634/camera_filter/blob/master/assets/grey.jpeg?raw=true',
                  color: color.withOpacity(0.5),
                  fit: BoxFit.fill,
                  colorBlendMode: BlendMode.hardLight,
                ),
              ),
            ),
    );
  }
}
