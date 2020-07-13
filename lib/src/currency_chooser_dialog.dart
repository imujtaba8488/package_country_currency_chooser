import 'package:flutter/material.dart';

import 'countries.dart';
import 'country_utils.dart';
import 'country.dart';

/// Signature of the callback that is fired when a currency is selected on the currency chooser dialog.
typedef CurrencySelector = void Function(Widget flag, String currencyCode);

/// A simple yet powerful, elegant, customizable, and efficient currency chooser dialog with search support. Selecting a currency in the dialog fires a callback which returns the country flag along with the currency code of the country.
class CurrencyChooserDialog extends StatefulWidget {
  /// Returns the country flag and currencyCode of the currency that was selected.
  final CurrencySelector selectedCurrency;

  /// Whether to show country flags or not.
  final bool showFlags;

  /// When the country list is scrolled, pullToStartFloatingButton scrolls the list to the beginning with an animation effect. This property specifies whether to show the pullToStartFloatingButton or not.
  final bool showPullToStartFloatingButton;

  /// Whether to show dividers or not.
  final bool showListDividers;

  /// Whether to currency code or not.
  final bool showCurrencyCodes;

  /// The background color of the dialog.
  final Color backgroundColor;

  /// Color to apply to the elements of the dialog.
  final Color interfaceColor;

  /// Border color of the dialog.
  final Color borderColor;

  /// Color to apply to the pullToStartFloatingButton.
  final Color pullToStartFloatingButtonColor;

  /// The animation effect to apply to the dialog when it pops-up and pops-out. __Use the built-in Flutter Curves class to set the effect.__
  final Curve dialogAnimationEffect;

  /// The dialog pop-up and pop-out animation duration.
  final Duration dialogAnimationDuration;

  /// Whether to disable the dialog pop-up and pop-out animation or not.
  final bool animationDisabled;

  /// The decoration for the flag.
  final Decoration flagDecoration;

  /// Whether to disable the search or not.
  final bool searchDisabled;

  CurrencyChooserDialog({
    this.selectedCurrency,
    this.showFlags = true,
    this.showPullToStartFloatingButton = true,
    this.showListDividers = true,
    this.showCurrencyCodes = true,
    this.backgroundColor = Colors.white,
    this.interfaceColor = Colors.black,
    this.borderColor = Colors.white,
    this.pullToStartFloatingButtonColor = Colors.green,
    this.dialogAnimationEffect = Curves.fastOutSlowIn,
    this.dialogAnimationDuration = const Duration(milliseconds: 500),
    this.animationDisabled = false,
    this.flagDecoration,
    this.searchDisabled = false,
  }) {
    assert(
      showFlags == false && flagDecoration == null ||
          showFlags && flagDecoration == null ||
          showFlags && flagDecoration != null,
      'You cannot specify a flag decoration if flags are disabled',
    );
  }

  @override
  _CurrencyChooserDialogState createState() => _CurrencyChooserDialogState();
}

class _CurrencyChooserDialogState extends State<CurrencyChooserDialog>
    with SingleTickerProviderStateMixin {
  double _dialogHeight, _dialogWidth;
  ScrollController _scrollController;
  TextEditingController _searchController;
  List<Country> _countries;
  AnimationController animationController;
  Animation animation;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _searchController = TextEditingController();
    _countries = sortedCountryList();
    animationController = AnimationController(
      vsync: this,
      duration: widget.dialogAnimationDuration,
    )..addListener(() {
        setState(() {});
      });

    if (!widget.animationDisabled) animationController.forward();
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _dialogHeight = MediaQuery.of(context).size.height / 2.5;
    _dialogWidth = MediaQuery.of(context).size.width / 1.3;

    animation = Tween(begin: 0.0, end: _dialogHeight).animate(
      CurvedAnimation(
        curve: widget.dialogAnimationEffect,
        parent: animationController,
      ),
    );

    return Dialog(
      backgroundColor: widget.backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Container(
        height: !widget.animationDisabled ? animation.value : _dialogHeight,
        width: _dialogWidth,
        padding: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: widget.borderColor,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Stack(
          children: <Widget>[
            !widget.searchDisabled? _searchField(): Container(),
            _countriesList(),
            widget.showPullToStartFloatingButton
                ? _scrollToInitialPositionButton()
                : Container()
          ],
        ),
      ),
    );
  }

  Positioned _searchField() {
    return Positioned(
      width: _dialogWidth - 10,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: TextField(
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.search,
              color: widget.interfaceColor,
            ),

            // Shows the clearText icon when something is typed within the search box.
            suffix: _searchController.text.isEmpty
                ? null
                : InkWell(
                    child: Icon(Icons.clear),
                    onTap: () {
                      setState(() {
                        _countries = sortedCountryList();
                        _searchController.clear();
                      });
                    },
                  ),
            labelText: 'Search',
            labelStyle: TextStyle(
              color: widget.interfaceColor,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: widget.interfaceColor,
                width: 0.5,
              ),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: widget.interfaceColor,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: widget.interfaceColor,
              ),
            ),
          ),
          style: TextStyle(color: widget.interfaceColor),
          controller: _searchController,
          onChanged: _onSearch,
        ),
      ),
    );
  }

  Positioned _countriesList() {
    return Positioned(
      top: widget.searchDisabled? 0.0: 75.0,
      width: _dialogWidth - 15,
      height: _dialogHeight,
      child: Container(
        margin: EdgeInsets.all(5.0),
        child: ListView.builder(
          itemCount: _countries.length,
          controller: _scrollController,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                if (widget.selectedCurrency != null) {
                  widget.selectedCurrency(
                    CountryUtils.getDefaultFlagImage(_countries[index]),
                    _countries[index].currencyCode,
                  );
                }

                // Exit with an animation effect.
                if (!widget.animationDisabled)
                  animationController.reverse().orCancel;

                !widget.animationDisabled
                    ? animationController.addStatusListener((status) {
                        if (status == AnimationStatus.dismissed) {
                          Navigator.pop(context);
                        }
                      })
                    : Navigator.pop(context);
              },
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      widget.showFlags
                          ? Container(
                              decoration: widget.flagDecoration,
                              child: CountryUtils.getDefaultFlagImage(
                                _countries[index],
                              ),
                            )
                          : Container(),
                      SizedBox(width: 5.0),
                      Expanded(
                        flex: 2,
                        child: Text(
                          _countries[index].name,
                          style: TextStyle(color: widget.interfaceColor),
                        ),
                      ),
                      widget.showCurrencyCodes
                          ? Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  _countries[index].currencyCode,
                                  style: TextStyle(
                                    color: widget.interfaceColor,
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                  widget.showListDividers
                      ? Divider(color: widget.interfaceColor)
                      : Container(height: 5.0),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Positioned _scrollToInitialPositionButton() {
    return Positioned(
      top: _dialogHeight - 40,
      left: _dialogWidth - 40,
      child: InkWell(
        child: Container(
          decoration: BoxDecoration(
            color: widget.pullToStartFloatingButtonColor,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.keyboard_arrow_up),
        ),
        onTap: () {
          _scrollController.animateTo(
            _scrollController.initialScrollOffset,
            curve: Curves.bounceIn,
            duration: Duration(seconds: 1),
          );
        },
      ),
    );
  }

  void _onSearch(String value) {
    setState(() {
      if (value.trim().isEmpty) {
        _countries = sortedCountryList();
      } else {
        // <|IMPORTANT|> set countries list back to initial list, so that the next value is searched within the whole list. For example, say you type 'I', countries will be searched for value of 'I', next say you type 'IN', now the countries will be searched for 'IN' instead of 'I', and so on.
        _countries = sortedCountryList();

        // Search for either the country name or the currency code.
        _countries = _countries.where((country) {
          return country.name.startsWith(value.trim()) ||
              country.name
                  .toLowerCase()
                  .startsWith(value.toLowerCase().trim()) ||
              country.currencyCode.startsWith(value.trim()) ||
              country.currencyCode.toLowerCase().startsWith(value.trim());
        }).toList();
      }
    });
  }
}
