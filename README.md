# 🎲 RPGMaster

RPGMaster to mobilna aplikacja mobilna wspierająca prowadzenie i uczestniczenie w sesjach gier fabularnych (RPG). Celem projektu jest uproszczenie organizacji sesji RPG. Aplikacja jest skierowana zarówno do prowadzących gier (Game Masterów) jak i dla graczy. Umożliwia tworzenie kampanii, szablonów postaci, kart postaci, prowadzenie notatek z sesji, śledzenie swoich statystyk, ekwipunku oraz przebiegu rozgrywki.

Projekt został stworzony z wykorzystaniem technologii **Flutter i Firebase**.


## Architektura systemu (Diagramy C4)

![diagram c1](./C4_Mockupy/C1.png)
![diagram c3](./C4_Mockupy/C3.png)


## Mockupy widoków aplikacji

[Zobacz prototyp w Figma](https://www.figma.com/proto/A5WTh8LHV5v5uck69XmdYN/RPG-Master?node-id=1-250&p=f&t=dx4xmqepyMDgSWsy-1&scaling=scale-down&content-scaling=fixed&page-id=0%3A1&starting-point-node-id=1%3A250)

## Struktura projektu

### Główne pliki

#### **main.dart**

Punkt startowy aplikacji.
Odpowiada za inicjalizację Fluttera, konfigurację Firebase oraz uruchomienie głównego widgetu aplikacji.

#### **app.dart**

Zawiera globalną konfigurację aplikacji - motywy (jasny i ciemny), routing oraz ustawienia nawigacji.

#### **routes.dart**

Definiuje podstawowe ścieżki w aplikacji i przypisuje je do odpowiednich ekranów.


### Struktura katalogów

#### **models/**

Zawiera modele danych, takie jak Character, Campaign, Note czy Template. Określają one strukturę informacji zapisywanych i pobieranych z bazy Firestore.

#### **providers/**

Odpowiada za zarządzanie stanem aplikacji i logikę biznesową. Zawiera klasy reagujące na zmiany danych i aktualizujące interfejs użytkownika.

#### **services/**

Warstwa komunikacji z zewnętrznymi usługami. Znajduje się tu m.in. obsługa Firestore, autoryzacji oraz innych integracji.

#### **screens/**

Zawiera wszystkie ekrany aplikacji - np. widok arkusza postaci (character_sheet) czy ekran kampanii (campaign_screen).

#### **ui/**

Skupia wspólne komponenty interfejsu użytkownika: przyciski, karty, pola tekstowe, motywy graficzne i inne elementy wielokrotnego użytku.


## Technologie i narzędzia

- **Frontend:** Flutter (Dart)
- **Backend:** Firebase (Auth, Firestore, Storage)
- **Autoryzacja:** Firebase Authentication (Google / Email)
- **Projektowanie UI:** Figma
- **Diagramy:** Visual Paradigm

## Autorzy

Projekt wykonany przez:

Julia Krok, 272981

Jakub Warczyk, 273014

Nikodem Grzela, 272870 

Patrycja Smits, 272940


## Licencja

Projekt dostępny na licencji MIT.
