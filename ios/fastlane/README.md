fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios build_unsigned

```sh
[bundle exec] fastlane ios build_unsigned
```

Compila Flutter i genera .xcarchive sense signar per a l'admin

### ios build_unsigned_alt

```sh
[bundle exec] fastlane ios build_unsigned_alt
```

Compila Flutter i genera .xcarchive (versió alternativa)

### ios signing_info

```sh
[bundle exec] fastlane ios signing_info
```

Mostra informació sobre com signar l'archive

### ios generate_export_options

```sh
[bundle exec] fastlane ios generate_export_options
```

Genera ExportOptions.plist per a l'admin

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
