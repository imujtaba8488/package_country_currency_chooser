import 'package:flutter/material.dart';

import '../models/country.dart';

class SearchField extends StatefulWidget {
  final Color interfaceColor;
  final List<Country> countries;
  final Function onSearched;

  SearchField({this.interfaceColor, this.countries, this.onSearched});

  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  TextEditingController _searchController;
  List<Country> _countries;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _countries = widget.countries;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.search,
          color: widget.interfaceColor,
        ),

        // Shows the clearText icon when something is typed within the search box.
        suffix: _searchController.text.isEmpty
            ? null
            : InkWell(
                child: Icon(
                  Icons.clear,
                  color: widget.interfaceColor,
                ),
                onTap: () {
                  setState(() {
                    _searchController.clear();

                    _countries = widget.countries;
                    widget.onSearched(_countries);
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
    );
  }

  void _onSearch(String searchValue) {
    if (searchValue.trim().isEmpty) {
      _countries = widget.countries;
      widget.onSearched(_countries);
    } else {
      // <|IMPORTANT|> set countries list back to initial list, so that the next value is searched within the whole list. For example, say you type 'I', countries will be searched for value of 'I', next say you type 'IN', now the countries will be searched for 'IN' instead of 'I', and so on.
      _countries = widget.countries;

      // Search for either the country name or the currency code.
      _countries = _countries.where((country) {
        return country.name.startsWith(searchValue.trim()) ||
            country.name
                .toLowerCase()
                .startsWith(searchValue.toLowerCase().trim()) ||
            country.currencyCode.startsWith(searchValue.trim()) ||
            country.currencyCode.toLowerCase().startsWith(searchValue.trim());
      }).toList();
    }

    // Must be called after the previous statement.
    widget.onSearched(_countries);
  }
}
