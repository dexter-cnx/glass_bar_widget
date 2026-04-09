# Publish Checklist

- Update version in `pubspec.yaml`
- Update `CHANGELOG.md`
- Run `flutter pub get`
- Run `dart format .`
- Run `flutter analyze`
- Run `flutter test`
- Run `flutter pub publish --dry-run`
- Verify GitHub Pages demo build succeeds
- Tag release as `vX.Y.Z`
