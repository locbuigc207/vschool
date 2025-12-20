import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter/foundation.dart';

class DropdownEditingController<T> extends ChangeNotifier {
  T? _value;

  DropdownEditingController({T? value}) : _value = value;

  T? get value => _value;

  set value(T? newValue) {
    if (_value == newValue) return;
    _value = newValue;
    notifyListeners();
  }

  @override
  String toString() => '${describeIdentity(this)}($value)';
}

/// Create a dropdown form field
class DropdownFormField<T> extends StatefulWidget {
  final bool autoFocus;

  /// It will trigger on user search
  final bool Function(T item, String str)? filterFn;

  /// Check item is selected
  final bool Function(T? item1, T? item2)? selectedFn;

  /// Return list of items what need to list for dropdown.
  /// The list may be offline, or remote data from server.
  final Future<List<T>> Function(String str) findFn;

  /// Build dropdown Items, it get called for all dropdown items
  /// [item] = [dynamic value] List item to build dropdown ListTile
  /// [lasSelectedItem] = [null | dynamic value] last selected item, it gives user chance to highlight selected item
  /// [position] = [0,1,2...] Index of the list item
  /// [focused] = [true | false] is the item if focused, it gives user chance to highlight focused item
  /// [onTap] = [Function] *important! just assign this function to ListTile.onTap  = onTap, in case you missed this,
  /// the click event if the dropdown item will not work.
  ///
  final ListTile Function(
    T item,
    int position,
    bool focused,
    bool selected,
    Function() onTap,
  ) dropdownItemFn;

  /// Build widget to display selected item inside Form Field
  final Widget Function(T? item) displayItemFn;

  final InputDecoration? decoration;
  final Color? dropdownColor;
  final DropdownEditingController<T>? controller;
  final void Function(T? item)? onChanged;
  final void Function(T?)? onSaved;
  final String? Function(T?)? validator;

  /// height of the dropdown overlay, Default: 240
  final double? dropdownHeight;

  /// Style the search box text
  final TextStyle? searchTextStyle;

  final Color? cursorColor;

  /// Message to display if the search rows not match with any item, Default : "No matching found!"
  final String emptyText;

  /// Give action text if you want handle the empty search.
  final String emptyActionText;

  /// this function triggers on click of emptyAction button
  final Future<void> Function()? onEmptyActionPressed;

  final double overlayDistance;

  final BorderRadius borderRadius;

  final bool enabled;

  const DropdownFormField({
    super.key,
    required this.dropdownItemFn,
    required this.displayItemFn,
    required this.findFn,
    this.filterFn,
    this.autoFocus = false,
    this.controller,
    this.validator,
    this.decoration,
    this.dropdownColor,
    this.onChanged,
    this.onSaved,
    this.dropdownHeight,
    this.searchTextStyle,
    this.cursorColor,
    this.emptyText = "No matching found!",
    this.emptyActionText = 'Create new',
    this.onEmptyActionPressed,
    this.selectedFn,
    this.overlayDistance = 0.0,
    this.enabled = true,
    this.borderRadius = const BorderRadius.all(Radius.zero),
  });

  @override
  DropdownFormFieldState createState() => DropdownFormFieldState<T>();
}

class DropdownFormFieldState<T> extends State<DropdownFormField<T>>
    with SingleTickerProviderStateMixin {
  final FocusNode _widgetFocusNode = FocusNode();
  final FocusNode _searchFocusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  final ValueNotifier<List<T>> _listItemsValueNotifier =
      ValueNotifier<List<T>>([]);
  final TextEditingController _searchTextController = TextEditingController();
  final DropdownEditingController<T> _controller =
      DropdownEditingController<T>();

  bool _selectedFn(dynamic item1, dynamic item2) {
    return item1 == item2;
  }

  bool get _isEmpty => _selectedItem == null;
  bool _isFocused = false;

  OverlayEntry? _overlayEntry;
  OverlayEntry? _overlayBackdropEntry;
  List<T>? _options;
  int _listItemFocusedPosition = 0;
  T? _selectedItem;
  Widget? _displayItem;
  Timer? _debounce;
  String? _lastSearchString;
  String _lastText = "";

  DropdownEditingController<dynamic>? get _effectiveController =>
      widget.controller ?? _controller;

  DropdownFormFieldState() : super();

  @override
  void initState() {
    super.initState();
    _search("");
    if (widget.autoFocus) {
      _widgetFocusNode.requestFocus();
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _addOverlay();
      });
    }
    _selectedItem = _effectiveController!.value;
    _effectiveController?.addListener(() {
      if (_effectiveController?.value == null) {
        _selectedItem = _effectiveController!.value;
        _lastText = '';
        setState(() {});
      }
    });

    _searchFocusNode.addListener(() {
      if (!_searchFocusNode.hasFocus && _overlayEntry != null) {
        _removeOverlay();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _debounce?.cancel();
    _searchTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _displayItem = widget.displayItemFn(_selectedItem);

    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: () {
          _widgetFocusNode.requestFocus();
          _toggleOverlay();
        },
        child: Focus(
          autofocus: widget.autoFocus,
          focusNode: _widgetFocusNode,
          onFocusChange: (focused) {
            setState(() {
              _isFocused = focused;
            });
          },
          onKey: (focusNode, event) {
            return _onKeyPressed(event);
          },
          child: FormField(
            enabled: widget.enabled,
            validator: (str) {
              if (widget.validator != null) {
                return widget.validator!(_effectiveController!.value);
              }
              return null;
            },
            onSaved: (str) {
              if (widget.onSaved != null) {
                widget.onSaved!(_effectiveController!.value);
              }
            },
            builder: (state) {
              return InputDecorator(
                decoration: widget.decoration ??
                    const InputDecoration(
                      border: UnderlineInputBorder(),
                      suffixIcon: Icon(Icons.arrow_drop_down),
                    ),
                isEmpty: _isEmpty,
                isFocused: _isFocused,
                child: _overlayEntry != null
                    ? EditableText(
                        style: (widget.searchTextStyle ??
                            Theme.of(context).textTheme.titleMedium)!,
                        controller: _searchTextController,
                        cursorColor: (widget.cursorColor ??
                            Theme.of(context).primaryColor),
                        focusNode: _searchFocusNode,
                        backgroundCursorColor: Colors.transparent,
                        onChanged: (str) {
                          _lastText = str;
                          if (_overlayEntry == null) {
                            _addOverlay();
                          }
                          _onTextChanged(str);
                        },
                        onSubmitted: (str) {
                          // _searchTextController.value =
                          //     TextEditingValue(text: "");
                          _lastText = str;
                          _setValue();
                          _removeOverlay();
                          _widgetFocusNode.nextFocus();
                        },
                        onEditingComplete: () {},
                      )
                    : _displayItem ?? Container(),
              );
            },
          ),
        ),
      ),
    );
  }

  OverlayEntry _createOverlayEntry() {
    final renderObject = context.findRenderObject() as RenderBox;
    final Size size = renderObject.size;

    return OverlayEntry(
      builder: (context) {
        return Positioned(
          width: size.width,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: Offset(0.0, size.height + widget.overlayDistance),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: widget.borderRadius,
                color: widget.dropdownColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 2), // changes position of shadow
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: widget.borderRadius,
                child: Material(
                  color: widget.dropdownColor ?? Colors.white,
                  child: Container(
                    height: widget.dropdownHeight ?? 240,
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: widget.borderRadius,
                      border: Border.all(
                          color: const Color(0xFFD1D1D1), width: 1.0),
                    ),
                    child: ValueListenableBuilder(
                      valueListenable: _listItemsValueNotifier,
                      builder: (context, List<T> items, child) {
                        return _options != null && _options!.isNotEmpty
                            ? ListView.separated(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                itemCount: _options!.length,
                                itemBuilder: (context, position) {
                                  T item = _options![position];
                                  ListTile listTile = widget.dropdownItemFn(
                                    item,
                                    position,
                                    position == _listItemFocusedPosition,
                                    (widget.selectedFn ?? _selectedFn)(
                                        _selectedItem, item),
                                    () {
                                      _listItemFocusedPosition = position;
                                      _widgetFocusNode.unfocus();
                                      // _searchTextController.value =
                                      //     TextEditingValue(text: "");
                                      _removeOverlay();
                                      _setValue();
                                    },
                                  );

                                  return listTile;
                                },
                                separatorBuilder: (context, position) {
                                  return const Divider(
                                    color: Color(0xFFE0E0E0),
                                    height: 1.0,
                                    thickness: 1.0,
                                    indent: 20.0,
                                    endIndent: 20.0,
                                  );
                                },
                              )
                            : Container(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(widget.emptyText),
                                    if (widget.onEmptyActionPressed != null)
                                      TextButton(
                                        onPressed: () async {
                                          await widget.onEmptyActionPressed!();
                                          _search(
                                              _searchTextController.value.text);
                                        },
                                        child: Text(widget.emptyActionText),
                                      ),
                                  ],
                                ),
                              );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  OverlayEntry _createBackdropOverlay() {
    return OverlayEntry(
        builder: (context) => Positioned(
            left: 0,
            top: 0,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: GestureDetector(
              onTap: () {
                _removeOverlay();
              },
            )));
  }

  _addOverlay() {
    if (_overlayEntry == null) {
      _search(_lastText);
      _overlayBackdropEntry = _createBackdropOverlay();
      _overlayEntry = _createOverlayEntry();
      _searchTextController.text = _lastText;
      if (_overlayEntry != null) {
        // Overlay.of(context)!.insert(_overlayEntry!);
        Overlay.of(context).insertAll([_overlayBackdropEntry!, _overlayEntry!]);
        setState(() {
          _searchFocusNode.requestFocus();
        });
      }
    }
  }

  /// Detach overlay from the dropdown widget
  _removeOverlay() {
    if (_overlayEntry != null) {
      _overlayBackdropEntry!.remove();
      _overlayEntry!.remove();
      _overlayEntry = null;
      // _searchTextController.value = TextEditingValue.empty;
      setState(() {});
    }
  }

  _toggleOverlay() {
    if (_overlayEntry == null) {
      _addOverlay();
    } else {
      _removeOverlay();
    }
  }

  _onTextChanged(String? str) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (_lastSearchString != str) {
        _lastSearchString = str;
        _search(str ?? "");
      }
    });
  }

  _onKeyPressed(RawKeyEvent event) {
    if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
      if (_searchFocusNode.hasFocus) {
        _toggleOverlay();
      } else {
        _toggleOverlay();
      }
      return false;
    } else if (event.isKeyPressed(LogicalKeyboardKey.escape)) {
      _removeOverlay();
      return true;
    } else if (event.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
      int v = _listItemFocusedPosition;
      v++;
      if (v >= _options!.length) v = 0;
      _listItemFocusedPosition = v;
      _listItemsValueNotifier.value = List<T>.from(_options ?? []);
      return true;
    } else if (event.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
      int v = _listItemFocusedPosition;
      v--;
      if (v < 0) v = _options!.length - 1;
      _listItemFocusedPosition = v;
      _listItemsValueNotifier.value = List<T>.from(_options ?? []);
      return true;
    }
    return false;
  }

  _search(String str) async {
    List<T> items = await widget.findFn(str);

    if (str.isNotEmpty && widget.filterFn != null) {
      items = items.where((item) => widget.filterFn!(item, str)).toList();
    }

    _options = items;

    _listItemsValueNotifier.value = items;
  }

  _setValue() {
    var item = _options![_listItemFocusedPosition];
    _selectedItem = item;

    _effectiveController!.value = _selectedItem;

    // TODO: replace with '', add scroll to selectedItem
    _lastText = _selectedItem.toString();

    if (widget.onChanged != null) {
      widget.onChanged!(_selectedItem);
    }

    setState(() {});
  }
}
