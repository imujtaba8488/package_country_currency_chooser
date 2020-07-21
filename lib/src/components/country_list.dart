import 'package:flutter/material.dart';

import '../models/country.dart';
import '../models/country_utils.dart';

class CountryList extends StatefulWidget {
  final List<Country> countries;
  final bool showFlags;
  final BoxDecoration flagDecoration;
  final Color interfaceColor;
  final bool showListDividers;
  final bool showCurrencyCodes;
  final Function onItemSelected;
  final Alignment pullToStartFloatingButtonPlacement;
  final Color pullToStartFloatingButtonColor;

  CountryList({
    @required this.countries,
    this.showFlags = true,
    this.flagDecoration,
    this.interfaceColor,
    this.showListDividers = true,
    this.showCurrencyCodes = true,
    this.onItemSelected,
    this.pullToStartFloatingButtonPlacement = Alignment.bottomRight,
    this.pullToStartFloatingButtonColor = Colors.green,
  });

  @override
  _CountryListState createState() => _CountryListState();
}

class _CountryListState extends State<CountryList> {
  ScrollController _scrollController;

  // !Problem: User could have tapped an item again and it would have resulted in second and successive tap that sent the app right off all the screens because of the Navigator.pop(context) statement.
  // Disables any successive taps to prevent the Navigator.of(context) to be called again, which evidently if called again resulted in popping more than one screen.
  bool _disableSuccessiveTaps = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(5.0),
          child: ListView.builder(
            itemCount: widget.countries.length,
            controller: _scrollController,
            itemBuilder: _buildCurrencyList,
          ),
        ),
        _scrollToInitialPositionButton(),
      ],
    );
  }

  Widget _buildCurrencyList(BuildContext context, int index) {
    return IgnorePointer(
      ignoring: _disableSuccessiveTaps,
      child: InkWell(
        onTap: () {
          widget.onItemSelected(index);
          _disableSuccessiveTaps = true;
        },
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                widget.showFlags
                    ? Container(
                        decoration: widget.flagDecoration,
                        child: CountryUtils.getDefaultFlagImage(
                          widget.countries[index],
                        ),
                      )
                    : Container(),
                SizedBox(width: 5.0),
                Expanded(
                  flex: 2,
                  child: Text(
                    widget.countries[index].name,
                    style: TextStyle(color: widget.interfaceColor),
                  ),
                ),
                widget.showCurrencyCodes
                    ? Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            widget.countries[index].currencyCode,
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
      ),
    );
  }

  Widget _scrollToInitialPositionButton() {
    return Container(
      alignment: widget.pullToStartFloatingButtonPlacement,
      padding: EdgeInsets.all(5.0),
      child: InkWell(
        child: Container(
          decoration: BoxDecoration(
            color: widget.pullToStartFloatingButtonColor,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.keyboard_arrow_up),
        ),
        onTap: () => _scrollController.animateTo(
          _scrollController.initialScrollOffset,
          curve: Curves.bounceIn,
          duration: Duration(seconds: 1),
        ),
      ),
    );
  }
}
