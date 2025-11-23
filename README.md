# 🎲 RPGMaster

RPGMaster to mobilna aplikacja mobilna wspierająca prowadzenie i uczestniczenie w sesjach gier fabularnych (RPG). Celem projektu jest uproszczenie organizacji sesji RPG. Aplikacja jest skierowana zarówno do prowadzących gier (Game Masterów) jak i dla graczy. Umożliwia tworzenie kampanii, szablonów postaci, kart postaci, prowadzenie notatek z sesji, śledzenie swoich statystyk, ekwipunku oraz przebiegu rozgrywki.

Projekt został stworzony z wykorzystaniem technologii **Flutter i Firebase**.


## Architektura systemu (Diagramy C4)

![diagram c1](./C4_Mockupy/C1.png)
![diagram c3](./C4_Mockupy/C3.png)


## Mockupy widoków aplikacji

[Zobacz prototyp w Figma](https://www.figma.com/proto/A5WTh8LHV5v5uck69XmdYN/RPG-Master?node-id=1-250&p=f&t=dx4xmqepyMDgSWsy-1&scaling=scale-down&content-scaling=fixed&page-id=0%3A1&starting-point-node-id=1%3A250)


## Struktura projektu

```

lib/
│
├── main.dart
│   Główny punkt wejścia aplikacji. Inicjalizuje Fluttera, ładuje konfigurację Firebase oraz uruchamia główny widget
│
├── app.dart
│   Zawiera globalną konfigurację aplikacji: motywy (jasny/ciemny), routing i nawigację
│
├── routes.dart
│   Definiuje ścieżki między ekranami (routing) i mapuje je na odpowiednie widoki
│
├── models/
│   Modele danych używane w aplikacji (Character, Campaign, Note, Template)
|   Odpowiadają za strukturę danych pobieranych i zapisywanych w bazie Firestore
│
├── providers/
│   Warstwa zarządzania stanem aplikacji
|   Zawiera logikę biznesową, reaguje na zmiany danych i aktualizuje interfejs użytkownika
│
├── services/
│   Obsługuje komunikację z zewnętrznymi usługami
│
├── screens/
│   Widoki aplikacji, czyli poszczególne ekrany, np. character_sheet, campaign_screen
│
├── ui/
│   Wspólne komponenty interfejsu użytkownika - widgety takie jak przyciski, karty, pola tekstowe, motywy graficzne


```

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
