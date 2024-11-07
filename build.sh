#!/bin/bash

# Installa Flutter
git clone https://github.com/flutter/flutter.git -b stable --depth 1
export PATH="$PATH:`pwd`/flutter/bin"

# Verifica l'installazione di Flutter
flutter doctor

# Esegui il build
flutter build web