
# Waveui

Waveui is a modular flutter ui library focused on **efficiency**, **customization**, and **modern design standards**. It provides rich, reusable widgets that make building complex apps easier and faster.

## Our Mission

- Provide **efficient**, **beautiful**, and **highly customizable** widgets  
- Align with **modern community and design standards**  
- Continuously evolve to support the **widest range of components possible**  
- Deliver a **developer friendly API**

>⚠️ Please **do not use in production** unless you're an **active contributor**.  
> The public API is under **rapid iteration** and breaking changes are expected without notice.


## Installation & Usage

Install via pub:

```sh
flutter pub add waveui
````

Wrap your app with `WaveApp` to enable global theming:

```dart
MaterialApp(
  builder: (context, child) => WaveApp(
    theme: Theme.of(context), // or a custom theme
    child: child!,
  ),
);
```


## Roadmap

| Status | Feature | Description                                       |
| ------ | ---------------- | ------------------------------------------------------------ |
| ✅      | Theme            | App wide theme logic |
| ✅      | ColorScheme      | Modular scheme used throughout the ui                 |
| ✅      | TextTheme        | Includes Inter font, multiple text styles                    |
| ✅      | WaveApp          | Entry point for providing theme context                      |
| ⏳      | AppBar           | Customizable top app bar (title, actions, elevation, etc.)   |
| ⏳      | TextField        | Filled, outlined, underlined with validator and hint support |
| ⏳      | Button           | Filled, Outlined, Ghost; themable via `ButtonTheme`          |
| ⏳      | Badge            | Count badge, status dot; supports size and color variants    |
| ⏳      | Card             | Elevation-based cards with layout utilities                  |
| ⏳      | ListTile         | Icon + title + subtitle support, customizable density        |
| ⏳      | Dialog           | Alert, Confirm, Custom – modal styling and blur              |
| ⏳      | BottomSheet      | Modal / persistent, with blur and drag support               |
| ⏳      | Toast            | Overlay-based status toast (info, success, error)            |
| ⏳      | Snackbar         | Actionable message component with duration handling          |
| ⏳      | Avatar           | Supports initials, icons, or image profile display           |

## License

Waveui is released under the [MIT License](https://opensource.org/license/mit/).

This package includes the **Inter** typeface by **Rasmus Andersson**, which is distributed under the [SIL Open Font License 1.1](https://openfontlicense.org/).  
The font is embedded in the package and governed by its corresponding terms included in `OFL.txt`.
