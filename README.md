# Country Currency Chooser

![Pub Version (including pre-releases)](https://img.shields.io/pub/v/country_currency_chooser?include_prereleases)
![GitHub issues](https://img.shields.io/github/issues-raw/imujtaba8488/package_country_currency_chooser)
![GitHub last commit](https://img.shields.io/github/last-commit/imujtaba8488/package_country_currency_chooser)
![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/imujtaba8488/package_country_currency_chooser)

## About

A simple yet powerful, elegant, customizable, and efficient currency chooser dialog __with search support.__

## Description

A simple yet powerful, elegant, customizable, and efficient currency chooser dialog with search support. Selecting a currency in the dialog fires a callback which returns the country flag along with the currency code of the country.

## Using

* Simply import package: `country_currency_chooser/country_currency_chooser.dart.`

* Use the built-in flutter `showDialog()` method and specify the return widget as
`CurrencyChooserDialog`.

* Selecting the currency on the `CurrencyChooserDialog` fires `selectedCurrency(Widget flag, String currencyCode)` callback.

## Feedback

Kindly email me directly for any feedback and hit the like button.

## Screenshots

![Screenshot](https://github.com/imujtaba8488/showcase/blob/master/currency_chooser_01.gif)

## Supported Attributes

 **Property**     | **Description**                                                                             | **Default**
------------------|---------------------------------------------------------------------------------------------|-------------
 selectedCurrency | A callback that provides the \`flag` and `currencyCode` of the currency that was selected\. | none
