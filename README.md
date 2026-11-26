# Konfigurator Vim (`vim_config.sh`)

Interaktywny skrypt w czystym Bashu do szybkiego generowania i zarządzania plikiem `~/.vimrc`. Nie wymaga zewnętrznych zależności takich jak `dialog` czy `whiptail`, automatycznie tworzy kopie zapasowe obecnej konfiguracji i pozwala opcjonalnie zainstalować menedżer wtyczek `vim-plug`.

## Wymagania

* `bash` (wersja 4.0+)
* `vim`
* `curl` (wymagany do uruchomienia instalatora oraz pobierania `vim-plug`)
* `git` (wymagany przy instalacji wtyczek przez `vim-plug`)

> **Wskazówka (Ubuntu / Debian):** Domyślny pakiet `vim` często nie jest skompilowany ze wsparciem schowka systemowego (`-clipboard`). Aby kopiowanie między Vimem a systemem działało bez problemu, zainstaluj pełną wersję:
> ```bash
> sudo apt update && sudo apt install -y vim-gtk3 curl git
> ```

---

## Instalacja i uruchomienie

Uruchom konfigurator bezpośrednio z terminala (zastąp link adresem raw swojego skryptu):

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/twoj-uzytkownik/twoje-repo/main/vim_config.sh)
```

*(Użycie podstawienia procesu `bash <(...)` zamiast potoku `| bash` zachowuje interaktywne wejście z terminala, dzięki czemu menu działa poprawnie.)*

### Obsługa konfiguratora

* **Przełączanie opcji:** Wpisz numer opcji i naciśnij `Enter`. Możesz przełączyć kilka opcji naraz, oddzielając je spacją (np. `3 8 12`).
* **`t`** – cykliczna zmiana szerokości wcięcia (`2`, `4`, `8` spacji).
* **`c`** – cykliczna zmiana wbudowanego motywu kolorystycznego.
* **`p`** – podgląd wygenerowanego pliku `~/.vimrc` przed zapisem.
* **`h`** – otwarcie wbudowanej dokumentacji i ściągawki (również przez `./vim_config.sh --help`).
* **`s`** – zapis konfiguracji (jeśli `~/.vimrc` już istnieje, skrypt utworzy backup `~/.vimrc.bak.RRRRMMDD_GGMMSS`).
* **`q`** – wyjście bez zapisywania zmian.

---

## Podstawowa obsługa Vima

Vim działa w oparciu o tryby. Najważniejsze to **Normal** (nawigacja i komendy – domyślny po uruchomieniu) oraz **Insert** (wpisywanie tekstu).

### Tryby i zapisywanie

| Skrót / Komenda | Działanie |
| :--- | :--- |
| `i` | Wejście w tryb **Insert** (przed kursorem) |
| `a` | Wejście w tryb **Insert** (za kursorem) |
| `o` | Nowa linia poniżej i wejście w tryb **Insert** |
| `Esc` | Powrót do trybu **Normal** |
| `v` / `V` | Tryb **Visual** (zaznaczanie znaków / całych linii) |
| `:w` | Zapisz plik |
| `:q` | Zamknij Vima |
| `:wq` lub `ZZ` | Zapisz i zamknij |
| `:q!` | Zamknij bez zapisywania |

### Nawigacja i edycja (tryb Normal)

| Skrót | Działanie |
| :--- | :--- |
| `h` `j` `k` `l` | Ruch kursora: lewo, dół, góra, prawo |
| `w` / `b` | Skok do następnego / poprzedniego słowa |
| `0` / `$` | Początek / koniec bieżącej linii |
| `gg` / `G` | Początek / koniec pliku |
| `u` / `Ctrl + r` | Cofnij (Undo) / Ponów (Redo) |
| `dd` | Wytnij całą linię |
| `yy` | Skopiuj całą linię |
| `p` | Wklej poniżej / za kursorem |
| `/tekst` | Wyszukaj `tekst` w dół (`n` – następny, `N` – poprzedni) |
| `\ + Enter` | Wyczyść podświetlenie wyszukiwania *(z tego konfiguratora)* |

### Dzielenie ekranu (Split Windows) i nawigacja między oknami

| Skrót / Komenda | Działanie |
| :--- | :--- |
| `:sp [plik]` lub `Ctrl + w`, `s` | Podział poziomy (otwiera plik lub duplikuje widok) |
| `:vsp [plik]` lub `Ctrl + w`, `v` | Podział pionowy (otwiera plik lub duplikuje widok) |
| `Ctrl + w`, potem `h`/`j`/`k`/`l` | Przejście do okna: lewo, dół, góra, prawo |
| `Ctrl + w`, potem `w` | Cykliczne przełączanie między otwartymi oknami |
| `Ctrl + w`, potem `=` | Wyrównanie rozmiarów wszystkich okien |
| `Ctrl + w`, potem `q` (lub `:q`) | Zamknięcie aktywnego okna |
| `Ctrl + w`, potem `o` | Zamknięcie wszystkich pozostałych okien (zostawia aktywne) |

---

## Zarządzanie wtyczkami (`vim-plug`)

Jeśli podczas konfiguracji zaznaczyłeś opcję **vim-plug**, skrypt zainstalował menedżer wtyczek wraz z **NERDTree** (drzewo plików) oraz **vim-airline** (pasek statusu).

### Podstawowe komendy (wpisywane wewnątrz Vima)

| Komenda | Działanie |
| :--- | :--- |
| `:PlugInstall` | Instaluje nowe wtyczki dopisane do `~/.vimrc` |
| `:PlugUpdate` | Aktualizuje wszystkie zainstalowane wtyczki |
| `:PlugClean` | Usuwa wtyczki wykreślone z `~/.vimrc` |
| `:PlugStatus` | Sprawdza stan wtyczek |
| `:PlugUpgrade` | Aktualizuje samego menedżera `vim-plug` |

### Obsługa zainstalowanych wtyczek

* **NERDTree (eksplorator plików):**
  * `Ctrl + n` – otwiera lub zamyka panel boczny z drzewem katalogów.
  * `Enter` – otwiera plik lub rozwija katalog.
  * `m` – otwiera menu operacji na plikach (dodawanie, zmiana nazwy, usuwanie).
  * `Ctrl + w`, a potem `w` – przełączanie fokusu między oknem NERDTree a edytowanym plikiem.

### Dodawanie własnych wtyczek

1. Otwórz `~/.vimrc` i znajdź blok `call plug#begin(...)`.
2. Dopisz nową wtyczkę w formacie `Plug 'autor/repozytorium'`:
   ```vim
   call plug#begin('~/.vim/plugged')
       Plug 'preservim/nerdtree'
       Plug 'vim-airline/vim-airline'
       Plug 'tpope/vim-commentary' " Przykład: szybkie komentowanie kodu (gcc)
   call plug#end()
   ```
3. Zapisz plik (`:w`), przeładuj konfigurację (`:source %`) i uruchom `:PlugInstall`.
