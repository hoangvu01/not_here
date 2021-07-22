import 'package:flutter/material.dart';

/// Signature for callback when search bar is tapped.
///
/// See also:
///   * [onTap], which is called when search bar is tapped
///   * [onUnFocus]
typedef TapCallback = void Function();

/// Signature for callback when search bar is/being edited.
///
/// See also:
///   * [onChnage], which is called when search bar is being editted
typedef EditCallBack = void Function(String);

class SearchBar extends StatefulWidget {
  const SearchBar({
    Key? key,
    this.onTap,
    this.onClear,
    this.onFocus,
    this.onUnFocus,
    this.onChange,
    this.onEditComplete,
    this.controller,
    this.focusNode,
  }) : super(key: key);

  /// Callback function when search bar is tapped/acquired focus
  final TapCallback? onTap;

  /// Callback function when search bar is tapped/acquired focus
  final TapCallback? onClear;

  /// Callback when search bar is no longer in focus
  final TapCallback? onFocus;

  /// Callback when search bar is no longer in focus
  final TapCallback? onUnFocus;

  /// Callback function when there is a change in the search bar content
  /// This takes in as parameter the current text in the search bar
  final EditCallBack? onChange;

  /// Callback function when there is a search bar content has been 'submitted'
  /// This takes in as parameter the current text in the search bar
  final EditCallBack? onEditComplete;

  /// Controller for the text field
  final TextEditingController? controller;

  /// [FocusNode] for the [TextField] inside search bar
  final FocusNode? focusNode;

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> with WidgetsBindingObserver {
  /// Controller for the text inside the text field of the search bar
  /// This will be either the one passed into the widget by its parent, i.e
  /// [widget.controller] if its not null, or a new instance of
  /// [TextEditingController] if required.
  late final TextEditingController _controller;

  /// [FocusNode] for the text field.
  late final FocusNode _focusNode;

  double _prevKeyboardBottomInset = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);

    /// Initialises controller
    _controller = widget.controller ?? TextEditingController();

    /// Initialises focus node
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        widget.onFocus?.call();
      } else {
        widget.onUnFocus?.call();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);

    if (widget.controller == null) {
      _controller.dispose();
    }

    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance!.window.viewInsets.bottom;
    if (bottomInset == 0 && _prevKeyboardBottomInset > 0) {
      _focusNode.unfocus();
      widget.onUnFocus?.call();
    }
    setState(() {
      _prevKeyboardBottomInset = bottomInset;
    });
  }

  Widget _buildSearchTextField(BuildContext ctx) => Container(
        padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
        child: TextField(
          controller: _controller,
          focusNode: _focusNode,
          decoration: InputDecoration(
            icon: Icon(Icons.search),
            border: UnderlineInputBorder(),
            hintText: 'Town, city or postcode',
            suffix: GestureDetector(
              onTap: () {
                widget.onClear?.call();
                _controller.clear();
              },
              child: Icon(Icons.clear, size: 14),
            ),
          ),
          onTap: widget.onTap,
          onEditingComplete: () {
            widget.onEditComplete?.call(_controller.text);
            _focusNode.unfocus();
          },
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            offset: Offset(0.0, 15.0),
            color: Theme.of(context).shadowColor,
            blurRadius: 10.0,
            spreadRadius: 3.0,
          ),
        ],
        color: Theme.of(context).colorScheme.onBackground,
      ),
      child: _buildSearchTextField(context),
    );
  }
}
