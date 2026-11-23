#!/usr/bin/env bash
# Interaktywny konfigurator Vim (~/.vimrc)

VIMRC="$HOME/.vimrc"
UNDODIR="$HOME/.vim/undodir"

# Kolory ANSI
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

# Kolejność kluczy w menu
KEYS=(
    "syntax"
    "number"
    "relativenumber"
    "expandtab"
    "smartindent"
    "search"
    "mouse"
    "clipboard"
    "ui"
    "undo"
    "noswap"
    "vimplug"
)

# Opisy opcji
declare -A LABELS=(
    ["syntax"]="Podświetlanie składni (syntax on + filetype)"
    ["number"]="Numerowanie linii (set number)"
    ["relativenumber"]="Relatywne numery linii (set relativenumber)"
    ["expandtab"]="Spacje zamiast tabulatorów (expandtab)"
    ["smartindent"]="Inteligentne wcięcia (autoindent + smartindent)"
    ["search"]="Lepsze wyszukiwanie (incsearch, hlsearch, smartcase)"
    ["mouse"]="Obsługa myszy i scrollowania (mouse=a)"
    ["clipboard"]="Wspólny schowek systemowy (unnamedplus)"
    ["ui"]="Ulepszenia UI (cursorline, wildmenu, scrolloff=8, pasek statusu)"
    ["undo"]="Trwała historia cofania po zamknięciu pliku (undofile)"
    ["noswap"]="Wyłącz pliki .swp i backupy (noswapfile, nobackup)"
    ["vimplug"]="Zainstaluj menedżer wtyczek vim-plug (NERDTree + Airline)"
)

# Domyślne wartości (1 = WŁ, 0 = WYŁ)
declare -A STATE=(
    ["syntax"]=1
    ["number"]=1
    ["relativenumber"]=1
    ["expandtab"]=1
    ["smartindent"]=1
    ["search"]=1
    ["mouse"]=1
    ["clipboard"]=1
    ["ui"]=1
    ["undo"]=1
    ["noswap"]=1
    ["vimplug"]=0
)

# Ustawienia wielowartościowe
TAB_SIZES=(2 4 8)
TAB_IDX=1 # Domyślnie 4

COLORSCHEMES=("habamax" "desert" "slate" "elflord" "ron" "default")
COLOR_IDX=0 # Domyślnie habamax

generate_vimrc() {
    local tab="${TAB_SIZES[$TAB_IDX]}"
    local theme="${COLORSCHEMES[$COLOR_IDX]}"

    cat <<EOF
" ============================================================================
" Wygenerowano przez vim_config.sh ($(date '+%Y-%m-%d %H:%M'))
" ============================================================================
set nocompatible
set encoding=utf-8
set backspace=indent,eol,start
EOF

    if [[ ${STATE["syntax"]} -eq 1 ]]; then
        cat <<EOF

" --- Składnia i wygląd ---
syntax on
filetype plugin indent on
set background=dark
silent! colorscheme $theme
EOF
    fi

    if [[ ${STATE["number"]} -eq 1 || ${STATE["relativenumber"]} -eq 1 ]]; then
        echo -e "\n\" --- Numerowanie linii ---"
        [[ ${STATE["number"]} -eq 1 ]] && echo "set number"
        [[ ${STATE["relativenumber"]} -eq 1 ]] && echo "set relativenumber"
    fi

    cat <<EOF

" --- Wcięcia i tabulatory ---
set tabstop=$tab
set softtabstop=$tab
set shiftwidth=$tab
EOF
    [[ ${STATE["expandtab"]} -eq 1 ]] && echo "set expandtab"
    if [[ ${STATE["smartindent"]} -eq 1 ]]; then
        echo "set autoindent"
        echo "set smartindent"
    fi

    if [[ ${STATE["search"]} -eq 1 ]]; then
        cat <<EOF

" --- Wyszukiwanie ---
set incsearch
set hlsearch
set ignorecase
set smartcase
" Spacja + Enter czyści podświetlenie wyszukiwania
nnoremap <silent> <leader><CR> :nohlsearch<CR>
EOF
    fi

    if [[ ${STATE["mouse"]} -eq 1 ]]; then
        echo -e "\n\" --- Mysz ---"
        echo "set mouse=a"
    fi

    if [[ ${STATE["clipboard"]} -eq 1 ]]; then
        cat <<EOF

" --- Schowek systemowy ---
if has('unnamedplus')
    set clipboard=unnamedplus
else
    set clipboard=unnamed
endif
EOF
    fi

    if [[ ${STATE["ui"]} -eq 1 ]]; then
        cat <<EOF

" --- Interfejs ---
set cursorline
set showcmd
set wildmenu
set laststatus=2
set scrolloff=8
set signcolumn=yes
EOF
    fi

    if [[ ${STATE["undo"]} -eq 1 ]]; then
        cat <<EOF

" --- Trwałe Undo ---
set undofile
set undodir=$UNDODIR
EOF
    fi

    if [[ ${STATE["noswap"]} -eq 1 ]]; then
        cat <<EOF

" --- Brak plików tymczasowych ---
set noswapfile
set nobackup
set nowritebackup
EOF
    fi

    if [[ ${STATE["vimplug"]} -eq 1 ]]; then
        cat <<'EOF'

" --- Wtyczki (vim-plug) ---
call plug#begin('~/.vim/plugged')
    Plug 'preservim/nerdtree'
    Plug 'vim-airline/vim-airline'
call plug#end()

" Skrót Ctrl+n otwiera drzewo katalogów NERDTree
nnoremap <C-n> :NERDTreeToggle<CR>
EOF
    fi
}

draw_menu() {
    clear
    echo -e "${CYAN}${BOLD}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}${BOLD}║                    KONFIGURATOR VIM (.vimrc)                 ║${NC}"
    echo -e "${CYAN}${BOLD}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo -e "${DIM}Wpisz numer (lub kilka oddzielonych spacją, np. '3 12'), aby przełączyć.${NC}\n"

    local i=1
    for key in "${KEYS[@]}"; do
        if [[ ${STATE[$key]} -eq 1 ]]; then
            printf "  ${BOLD}%2d)${NC} [${GREEN}✔${NC}] %s\n" "$i" "${LABELS[$key]}"
        else
            printf "  ${BOLD}%2d)${NC} [${RED} ${NC}] ${DIM}%s${NC}\n" "$i" "${LABELS[$key]}"
        fi
        ((i++))
    done

    echo -e "\n${CYAN}─── Parametry ──────────────────────────────────────────────────${NC}"
    printf "  ${BOLD} t)${NC} Szerokość wcięcia : ${YELLOW}%s spacji${NC} (kliknij, aby zmienić)\n" "${TAB_SIZES[$TAB_IDX]}"
    printf "  ${BOLD} c)${NC} Motyw kolorystyczny: ${YELLOW}%s${NC} (kliknij, aby zmienić)\n" "${COLORSCHEMES[$COLOR_IDX]}"

    echo -e "\n${CYAN}─── Akcje ──────────────────────────────────────────────────────${NC}"
    echo -e "  ${BOLD} p)${NC} Podgląd wygenerowanego .vimrc"
    echo -e "  ${BOLD} s)${NC} ${GREEN}Zapisz konfigurację i wyjdź${NC}"
    echo -e "  ${BOLD} q)${NC} ${RED}Wyjdź bez zapisywania${NC}\n"
}

save_config() {
    if [[ -f "$VIMRC" ]]; then
        local backup="${VIMRC}.bak.$(date +%Y%m%d_%H%M%S)"
        cp "$VIMRC" "$backup"
        echo -e "${YELLOW}[i] Utworzono kopię zapasową: $backup${NC}"
    fi

    if [[ ${STATE["undo"]} -eq 1 ]]; then
        mkdir -p "$UNDODIR"
    fi

    generate_vimrc > "$VIMRC"
    echo -e "${GREEN}[✔] Zapisano nową konfigurację w $VIMRC${NC}"

    if [[ ${STATE["vimplug"]} -eq 1 ]]; then
        if ! command -v curl &>/dev/null; then
            echo -e "${RED}[!] Brak 'curl' – pomiń instalację vim-plug lub doinstaluj curl.${NC}"
            return
        fi

        echo -e "${CYAN}[*] Pobieranie vim-plug...${NC}"
        curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

        read -rp "Zainstalować wtyczki od razu przez 'vim +PlugInstall +qall'? [t/N]: " run_plug
        if [[ "$run_plug" =~ ^[tTyY]$ ]]; then
            vim +PlugInstall +qall
        else
            echo -e "${YELLOW}[i] Uruchom ':PlugInstall' wewnątrz Vima, aby pobrać wtyczki.${NC}"
        fi
    fi
}

# Główna pętla
while true; do
    draw_menu
    read -rp "Wybór > " input

    for token in $input; do
        case "$token" in
            [0-9]*)
                if (( token >= 1 && token <= ${#KEYS[@]} )); then
                    key="${KEYS[$((token-1))]}"
                    STATE[$key]=$(( 1 - STATE[$key] ))
                fi
                ;;
            t|T)
                TAB_IDX=$(( (TAB_IDX + 1) % ${#TAB_SIZES[@]} ))
                ;;
            c|C)
                COLOR_IDX=$(( (COLOR_IDX + 1) % ${#COLORSCHEMES[@]} ))
                ;;
            p|P)
                clear
                echo -e "${CYAN}${BOLD}=== PODGLĄD ~/.vimrc ===${NC}\n"
                generate_vimrc
                echo ""
                read -rp "Naciśnij Enter, aby wrócić do menu..."
                ;;
            s|S)
                echo ""
                save_config
                exit 0
                ;;
            q|Q)
                echo -e "${DIM}Anulowano. Plik ~/.vimrc pozostał bez zmian.${NC}"
                exit 0
                ;;
        esac
    done
done
