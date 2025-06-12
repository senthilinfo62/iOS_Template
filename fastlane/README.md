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

### ios staging

```sh
[bundle exec] fastlane ios staging
```

Build and upload staging build to TestFlight

### ios production

```sh
[bundle exec] fastlane ios production
```

Build and upload production build to TestFlight

### ios certificates

```sh
[bundle exec] fastlane ios certificates
```

Download certificates and provisioning profiles

### ios test

```sh
[bundle exec] fastlane ios test
```

Run tests

### ios sync_team

```sh
[bundle exec] fastlane ios sync_team
```

Sync team ID from Xcode project to Appfile

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
