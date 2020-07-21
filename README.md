# Country Currency Chooser

![Pub Version (including pre-releases)](https://img.shields.io/pub/v/country_currency_chooser?include_prereleases)
![GitHub issues](https://img.shields.io/github/issues-raw/imujtaba8488/package_country_currency_chooser)
![GitHub closed issues](https://img.shields.io/github/issues-closed/imujtaba8488/package_country_currency_chooser)
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

| Property | Description | Default |
|--------------------------------|---------------------------------------------------------------------------|------------------------------|
| selectedCurrency | Callback that provides `flag` and `currencyCode` of the currency selected | - |
| showFlags | Whether to show flags in the country list or not | true |
| showPullToStartFloatingButton | Whether to show pullToStartFloatingButton or not | true |
| showListDividers | Whether to show list dividers in the country list or not | true |
| showCurrencyCodes | Whether to show currency codes in the country list or not | true |
| backgroundColor | The background color of the currency chooser dialog | White |
| interfaceColor | The color to apply to the elements of the dialog | Black |
| borderColor | The color to apply to the border of the dialog | White |
| pullToStartFloatingButtonColor | Color to the apply to pullToStartFloatingButton | Green |
| dialogAnimationEffect | Dialog pop-up and pop-out animation | FastOutSlowIn |
| dialogAnimationDuration | Duration of dialog pop-up and pop-out animation | 500 milliseconds |
| animationDisabled | Whether to disable the dialog pop-up and pop-out animation | false |
| flagDecoration | Decoration to set for the flag if displayed. | -  |
| searchDisabled | Whether the search box is disabled | false |
| dialogStretch | The height of the dialog | DialogStretch.min |
| pullToStartButtonPlacement | Where to place the pullToStartFloatingButton | ButtonPlacement.bottom_right |
