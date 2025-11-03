# Instalacja flutter

1. Zainstaluj Android Studio.
   Zaznacz opcję Android Emulator przy instalacji
2. Otwórz android studio i pobierz flutter (oraz Dart):

   File → Settings → Plugins → Marketplace → Flutter (automatycznie zainstaluje również Dart)
3. Sprawdź instalacje:
    ```commandline
    flutter doctor
    ```
4. Jeżeli masz problem z brakującymi komponentami Android:

    Tools → SDK → Manager SDK Tools → Sprawdź czy masz poniższe:

    Android SDK (najnowsza wersja)
    
    Android SDK Platform-Tools

   Android SDK Build-Tools
    
    Android Emulator
    
    Włącz, wpisz Y dla review licenses i wpisz Y dla każdej licencji:
    ```commandline
    flutter doctor --android-licenses
    ```
5. Sklonuj repo:

   File → New → Project from Version Control

   https://github.com/NikodemGrzela/RPGMaster.git
6. Projekt będzie w katalogu `rpgmaster`
7. Wskaż ścieżkę do Dart

   (Jeżeli nie wiesz gdzie jest to w zewnętrznym terminalu wpisz `where dart`)
8. Stwórz emulator:

   Tools → Device Manager

   Ja mam Pixel 7 API 36.0 Android 16.0 ze Sklepu Google Play (1.8 Gb)
   Uruchom urządzenie (strzałka play). (ew. Wybierz utworzony telefon jako urządzenie)

9. Sprawdź czy działa:
    ```commandline
    flutter run
    ```