# ASI HackYeah communication entry

## Before first run

Remember to init inject.dart submodule

```
git submodule init
git submodule update
```

## Code generation

First run: (local build_runner cache doesn't know about committed generated files)

```
flutter pub run build_runner build --delete-conflicting-outputs
./gen.sh
```

Next runs:
```
./gen.sh
```
