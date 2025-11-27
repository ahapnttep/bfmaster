#!/usr/bin/env bash

###############################################################################
# bfmaster.sh – Brainfuck Interpreter + Encoder (Shell Script)
# License: DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE (WTFPL)
#
# What is Brainfuck?
# Brainfuck is an esoteric programming language (an "esolang") designed to be
# extremely minimal and intentionally hard to write. It operates on a simple tape
# of memory cells using only eight commands, yet it is Turing-complete.
#
# SECURITY WARNING:
# This script should **never** be executed as root. There is absolutely no need,
# and running untrusted scripts as root can compromise your system. Always use
# your normal user account.
#
# Quick usage:
#   chmod +x bfmaster.sh
#   ./bfmaster.sh
#   Have fun :)
###############################################################################

# Installation directory (user-level only, no root required)
INSTALL_DIR="$HOME/bf_tool"
SCRIPT_NAME="brainfuck_tool.sh"
MESSAGE_BF_NAME="secret.txt"
SCRIPT_PATH="$INSTALL_DIR/$SCRIPT_NAME"
MESSAGE_BF_PATH="$INSTALL_DIR/$MESSAGE_BF_NAME"
ALIAS_NAME="bfmaster"

# Optional predefined Brainfuck message.
# You may place a BF-encoded message here if you want the script to load
# something by default. This is completely optional and leaving it empty will not
# affect any functionality, since the tool already includes a full encoder and
# interpreter.
MESSAGE_BF=""

###############################################################################
# Environment setup: create directory, copy script, and save optional message.
mkdir -p "$INSTALL_DIR"

if [ ! -f "$SCRIPT_PATH" ]; then
    cp "$0" "$SCRIPT_PATH"
    chmod +x "$SCRIPT_PATH"
fi

echo "$MESSAGE_BF" > "$MESSAGE_BF_PATH"
chmod 644 "$MESSAGE_BF_PATH"

BASH_RC="$HOME/.bashrc"
ZSH_RC="$HOME/.zshrc"

touch "$BASH_RC" "$ZSH_RC"
chmod 644 "$BASH_RC" "$ZSH_RC"

# Warn the user if they're running a shell other than Bash or Zsh.
check_shell_warning() {
    if [[ "$SHELL" != *"bash"* && "$SHELL" != *"zsh"* ]]; then
        echo "Your shell ($SHELL) is not Bash or Zsh."
        echo "If you want to enable the alias manually, add:"
        echo "alias $ALIAS_NAME=\"$SCRIPT_PATH\""
    fi
}

# Add alias to shell configuration file if not already present.
add_alias() {
    local file="$1"
    if ! grep -q "alias $ALIAS_NAME=" "$file"; then
        echo "# Brainfuck Tool alias" >> "$file"
        echo "alias $ALIAS_NAME=\"$SCRIPT_PATH\"" >> "$file"
    fi
}

add_alias "$BASH_RC"
add_alias "$ZSH_RC"

###############################################################################
# Normalize accented characters to ASCII-only equivalents.
normalize_input() {
    echo "$1" | sed -e 's/[áàãâ]/a/g' -e 's/[éèê]/e/g' -e 's/[íï]/i/g' \
                   -e 's/[óòõô]/o/g' -e 's/[úùü]/u/g' -e 's/[ç]/c/g' \
                   -e 's/[ÁÀÃÂ]/A/g' -e 's/[ÉÈÊ]/E/g' -e 's/[ÍÏ]/I/g' \
                   -e 's/[ÓÒÕÔ]/O/g' -e 's/[ÚÙÜ]/U/g' -e 's/[Ç]/C/g'
}

###############################################################################
# Display section titles in a consistent format.
show_title() {
    local title="$1"
    echo "=== $title ==="
    echo
}

###############################################################################
# Pause execution until the user presses Enter.
return_to_menu() {
    echo
    echo "Press Enter to return to the menu."
    read -r
    clear
}

###############################################################################
# Brainfuck Interpreter
interpret() {
    local code="$1"

    # Reject non-Brainfuck characters.
    if [[ "$code" =~ [^<>+\-.,\[\]] ]]; then
        echo "Invalid Brainfuck code detected."
        echo "Options:"
        echo "  a) Try again"
        echo "  b) Return to menu"
        while true; do
            read -r choice
            choice=$(echo "$choice" | tr 'A-Z' 'a-z')
            case "$choice" in
                a)
                    echo "Enter Brainfuck code:"
                    read -r bf_code
                    interpret "$bf_code"
                    return ;;
                b)
                    return ;;
                *)
                    echo "Invalid option. Please type 'a' or 'b'." ;; 
            esac
        done
    fi

    # Initialize memory tape.
    local -a memory
    for (( i=0; i<30000; i++ )); do
        memory[i]=0
    done

    local ptr=0
    local output=""
    local i=0
    local code_len=${#code}

    # Interpreter loop.
    while (( i < code_len )); do
        case "${code:i:1}" in
            '>') ((ptr++)) ;;
            '<') ((ptr--)) ;;
            '+') ((memory[ptr]++)) ;;
            '-') ((memory[ptr]--)) ;;
            '.') output+=$(printf "\$(printf "%03o" ${memory[ptr]})") ;;
            '[')
                if (( memory[ptr] == 0 )); then
                    local depth=1
                    while (( depth > 0 )); do
                        (( i++ ))
                        case "${code:i:1}" in
                            '[') ((depth++)) ;;
                            ']') ((depth--)) ;;
                        esac
                    done
                fi ;;
            ']')
                if (( memory[ptr] != 0 )); then
                    local depth=1
                    while (( depth > 0 )); do
                        (( i-- ))
                        case "${code:i:1}" in
                            '[') ((depth--)) ;;
                            ']') ((depth++)) ;;
                        esac
                    done
                fi ;;
        esac
        (( i++ ))
    done

    echo "Output:"
    echo "$output"
}

###############################################################################
# Brainfuck Encoder – Converts ASCII text into Brainfuck instructions.
encode_brainfuck() {
    local input="$1"
    local prev=0
    local bf_code=""

    for (( i=0; i<${#input}; i++ )); do
        local char="${input:$i:1}"
        local ascii_val=$(printf "%d" "'$char")
        local diff=$(( ascii_val - prev ))

        if (( diff > 0 )); then
            bf_code+=$(printf '%*s' "$diff" | tr ' ' '+')
        elif (( diff < 0 )); then
            bf_code+=$(printf '%*s' "$((-diff))" | tr ' ' '-')
        fi

        bf_code+="."
        prev=$ascii_val
    done

    echo "$bf_code"
}

###############################################################################
# Wrapper for encoder: prompt user, normalize text, and show output.
run_encoder() {
    echo "Enter text to encode:"
    read -r user_input
    local normalized_input=$(normalize_input "$user_input")
    local bf_code=$(encode_brainfuck "$normalized_input")
    echo "Encoded Brainfuck:"
    echo "$bf_code"
    return_to_menu
}

###############################################################################
# Main menu
menu() {
    while true; do
        clear
        echo "=== Brainfuck Tool ==="
        echo "1) Interpreter"
        echo "2) Encoder"
        echo "3) Terms"
        echo "4) Exit"
        read -r option

        case "$option" in
            1)
                show_title "Interpreter"
                read -r bf_code
                interpret "$bf_code"
                return_to_menu ;;
            2)
                show_title "Encoder"
                run_encoder ;;
            3)
                show_title "Terms"
                echo "This tool is licensed under the WTFPL. Use it however you like."
                return_to_menu ;;
            4)
                exit 0 ;;
            *)
                echo "Invalid option."
                return_to_menu ;;
        esac
    done
}

# Launch menu
menu
