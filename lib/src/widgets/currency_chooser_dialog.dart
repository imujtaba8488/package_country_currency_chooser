import 'package:country_currency_chooser/src/components/search_field.dart';
import 'package:flutter/material.dart';

import '../components/country_list.dart';
import '../models/countries.dart';
import '../models/country.dart';
import '../models/country_utils.dart';

/// Signature of the callback that is fired when a currency is selected on the currency chooser dialog.
typedef CurrencySelector = void Function(
  Widget flag,
  String currencyCode,
  String currencySymbol,
  String countryName,
);

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

  /// Whether to show currency code or not.
  final bool showCurrencyCodes;

  /// Whether to show currency symbol or not.
  final bool showCurrencySymbol;

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

  /// The height of the dialog
  final DialogStretch dialogStretch;

  /// Where to place the pullToStartFloatingButton
  final Alignment pullToStartFloatingButtonPlacement;

  CurrencyChooserDialog({
    this.selectedCurrency,
    this.showFlags = true,
    this.showPullToStartFloatingButton = true,
    this.showListDividers = true,
    this.showCurrencyCodes = true,
    this.showCurrencySymbol = false,
    this.backgroundColor = Colors.white,
    this.interfaceColor = Colors.black,
    this.borderColor = Colors.white,
    this.pullToStartFloatingButtonColor = Colors.green,
    this.dialogAnimationEffect = Curves.fastOutSlowIn,
    this.dialogAnimationDuration = const Duration(milliseconds: 500),
    this.animationDisabled = false,
    this.flagDecoration,
    this.searchDisabled = false,
    this.dialogStretch = DialogStretch.min,
    this.pullToStartFloatingButtonPlacement = Alignment.bottomRight,
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
  List<Country> _countries;
  AnimationController animationController;
  Animation animation;

  @override
  void initState() {
    super.initState();

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
    _dialogHeight = widget.dialogStretch == DialogStretch.min
        ? MediaQuery.of(context).size.height / 2.5
        : MediaQuery.of(context).size.height;
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
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: animation.value,
          maxWidth: _dialogWidth,
        ),
        child: Container(
          padding: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: widget.borderColor,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              !widget.searchDisabled
                  ? Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: SearchField(
                          interfaceColor: widget.interfaceColor,
                          countries: sortedCountryList(),
                          onSearched: (List<Country> countries) {
                            setState(() {
                              _countries = countries;
                            });
                          },
                        ),
                      ),
                    )
                  : Container(),
              Flexible(
                flex: 2,
                fit: FlexFit.tight,
                child: CountryList(
                  countries: _countries,
                  interfaceColor: widget.interfaceColor,
                  onItemSelected: _onItemSelected,
                  flagDecoration: widget.flagDecoration,
                  showCurrencyCodes: widget.showCurrencyCodes,
                  showCurrencySymbol: widget.showCurrencySymbol,
                  showFlags: widget.showFlags,
                  showListDividers: widget.showListDividers,
                  pullToStartFloatingButtonPlacement:
                      widget.pullToStartFloatingButtonPlacement,
                  pullToStartFloatingButtonColor:
                      widget.pullToStartFloatingButtonColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onItemSelected(int index) {
    if (widget.selectedCurrency != null) {
      widget.selectedCurrency(
        CountryUtils.getDefaultFlagImage(_countries[index]),
        _countries[index].currencyCode,
        _countries[index].currencyName,
        _countries[index].name,
      );
    }

    // Exit with an animation effect.
    if (!widget.animationDisabled) animationController.reverse().orCancel;

    !widget.animationDisabled
        ? animationController.addStatusListener((status) {
            if (status == AnimationStatus.dismissed) {
              Navigator.pop(context);
            }
          })
        : Navigator.pop(context);
  }
}

enum DialogStretch {
  min,
  max,
}
