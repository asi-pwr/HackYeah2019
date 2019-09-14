#!/bin/bash
flutter pub run build_runner build
find . -type f -name *.inject.dart -size 0 -delete
find . -type f -name *.inject.summary -delete

