All contributions welcome. Please be kind and mindful of other people and their time.

### Runing tests

Since this repository is intended for building arm64-darwin flake systems, it only
makes sense to run tests on such devices. Currently we have to do it manually, since
GitHub still does not provide an arm64 mac environment (see [here](https://github.com/actions/virtual-environments/issues/2187)). 

If you add a new feature, or fix something, be sure that at least the templates are ok.
On the root of this repository execute:

```shell
make test
```

### Pull-Requests

Along with your awesome code contribution, please add a new line at the top of `Unreleased`
section on CHANGELOG.md. Try keeping it short and provide links to your pull-request/issues.
