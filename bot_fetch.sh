#!/bin/bash

# -------------------------------
# CONFIGURATION
# -------------------------------
MODE="bash"  # default
LOGFILE="chat_log.txt"
URL_CACHE_FILE="url_cache.txt"

# Colors
BLUE=$'\033[34m'   # ghost mode prefix
CYAN=$'\033[36m'   # Bash & links
PINK=$'\033[35m'   # Hot Date
GREEN=$'\033[32m'  # Yoga
MAGENTA=$'\033[95m' # Paul
RESET=$'\033[0m'

SECRET_MODE=false

declare -A RESPONSES
declare -A URL_CACHE

# GitHub raw URLs for triggers
BASH_TRIGGER_URL="https://raw.githubusercontent.com/1nam/chatbot-triggers/main/triggers.txt"
HOTDATE_TRIGGER_URL="https://raw.githubusercontent.com/1nam/chatbot-triggers/main/hotdate_triggers.txt"
YOGA_TRIGGER_URL="https://raw.githubusercontent.com/1nam/chatbot-triggers/main/yoga_triggers.txt"
PAUL_TRIGGER_URL="https://raw.githubusercontent.com/1nam/chatbot-triggers/main/paul_triggers.txt"

# -------------------------------
# FUNCTIONS
# -------------------------------

load_url_cache() {
    [[ -f "$URL_CACHE_FILE" ]] || touch "$URL_CACHE_FILE"
    while IFS="=" read -r long short; do
        [[ -z "$long" || -z "$short" ]] && continue
        URL_CACHE["$long"]="$short"
    done < "$URL_CACHE_FILE"
}

shorten_url() {
    local long_url="$1"
    if [[ -n "${URL_CACHE[$long_url]}" ]]; then
        echo "${URL_CACHE[$long_url]}"
        return
    fi
    local short_url
    short_url=$(curl -s "https://tinyurl.com/api-create.php?url=$long_url")
    URL_CACHE["$long_url"]="$short_url"
    echo "$long_url=$short_url" >> "$URL_CACHE_FILE"
    echo "$short_url"
}

load_triggers() {
    local file="$1"
    RESPONSES=()
    [[ -f "$file" ]] || touch "$file"
    while IFS="=" read -r key value; do
        [[ -z "$key" || -z "$value" ]] && continue
        RESPONSES["$key"]="$value"
    done < "$file"
}

fetch_triggers_from_github() {
    local url="$1"
    local target_file="$2"
    if curl -s "$url" -o "$target_file"; then
        echo "✅ Fetched triggers from GitHub for $target_file."
    else
        echo "⚠️ Could not fetch triggers from GitHub for $target_file. Using local copy if available."
    fi
    load_triggers "$target_file"
}

pick_random_response() {
    local key="$1"
    IFS='|' read -ra options <<< "${RESPONSES[$key]}"
    local index=$((RANDOM % ${#options[@]}))
    echo "${options[$index]}"
}

process_urls() {
    local text="$1"
    for url in $(echo "$text" | grep -o -E 'https?://[^ ]+'); do
        short_url=$(shorten_url "$url")
        text="${text//$url/$short_url}"
    done
    echo "$text"
}

slow_echo() {
    local text="$1"
    local delay="${2:-0.05}"
    local i=0
    while (( i < ${#text} )); do
        if [[ "${text:$i}" =~ ^(https?://[^\ ]+) ]]; then
            url="${BASH_REMATCH[1]}"
            printf "%b" "$CYAN$url$RESET"
            ((i+=${#url}))
        else
            printf "%b" "${text:$i:1}"
            ((i++))
            sleep "$delay"
        fi
    done
    echo
}

funny_fallback() {
    local FALLBACKS=(
        "Wow… did you just invent a new command? 😆"
        "I… don't even know where to start, but okay!"
        "The internet collectively shrugs at this question 🤷‍♂️"
        "Bizarre, but I'll give it a shot!"
        "Hmm… your question made the quantum foam blush 😳"
    )
    local INDEX=$((RANDOM % ${#FALLBACKS[@]}))
    echo "${FALLBACKS[$INDEX]} Here's a hint: https://www.wikibooks.org/wiki/Bash_Shell_Scripting"
}

# -------------------------------
# MAIN
# -------------------------------
load_url_cache
fetch_triggers_from_github "$BASH_TRIGGER_URL" "triggers.txt"

echo "🤖 Modular Personality Bot ready!"
echo "Available modes: bash, hotdate, yoga, paul"
echo "Type 'mode <name>' to switch, 'quit' to exit."

while true; do
    read -p "You: " USER_INPUT
    echo "You: $USER_INPUT" >> "$LOGFILE"

    [[ "$USER_INPUT" == "quit" ]] && { echo "🤖 Goodbye!" | tee -a "$LOGFILE"; break; }

    # Mode switch
    if [[ "${USER_INPUT,,}" =~ ^mode\ (bash|hotdate|yoga|paul)$ ]]; then
        MODE="${BASH_REMATCH[1]}"
        echo "Switching to $MODE mode..."
        case "$MODE" in
            bash) fetch_triggers_from_github "$BASH_TRIGGER_URL" "triggers.txt";;
            hotdate) fetch_triggers_from_github "$HOTDATE_TRIGGER_URL" "hotdate_triggers.txt";;
            yoga) fetch_triggers_from_github "$YOGA_TRIGGER_URL" "yoga_triggers.txt";;
            paul) fetch_triggers_from_github "$PAUL_TRIGGER_URL" "paul_triggers.txt";;
        esac
        continue
    fi

    # Ghost mode toggle
    if [[ "${USER_INPUT,,}" == "ghost" ]]; then
        SECRET_MODE=true
        echo -e "${BLUE}👻 Ghost mode activated!${RESET}"
        continue
    fi
    if [[ "${USER_INPUT,,}" == "unghost" ]]; then
        SECRET_MODE=false
        echo "Ghost mode deactivated."
        continue
    fi

    # Default replies per mode
    case "$MODE" in
        bash) DEFAULT_REPLY="You can learn Bash here: https://www.wikibooks.org/wiki/Bash_Shell_Scripting"; COLOR=$CYAN;;
        hotdate) DEFAULT_REPLY="You're looking good today! 💖"; COLOR=$PINK;;
        yoga) DEFAULT_REPLY="Take a deep breath and stretch slowly. 🧘‍♂️"; COLOR=$GREEN;;
        paul) DEFAULT_REPLY="Ah, the cosmos is vast and full of enigmas. 🌌"; COLOR=$MAGENTA;;
    esac

    # --- Dynamic trigger matching ---
    MATCH_FOUND=false
    for key in "${!RESPONSES[@]}"; do
        if [[ "${USER_INPUT,,}" == *"${key,,}"* ]]; then
            BOT_REPLY=$(pick_random_response "$key")
            MATCH_FOUND=true
            break
        fi
    done

    # If nothing matched, use funny fallback
    if ! $MATCH_FOUND; then
        BOT_REPLY=$(funny_fallback)
    fi

    # Shorten URLs in the reply
    BOT_REPLY=$(process_urls "$BOT_REPLY")

    # Print response
    if $SECRET_MODE; then
        printf "%b" "$BLUE""Bot: ""$RESET"
        slow_echo "$COLOR$BOT_REPLY$RESET" 0.05
    else
        echo -e "Bot: $COLOR$BOT_REPLY$RESET"
    fi

    # Log plain response
    echo "Bot: $BOT_REPLY" >> "$LOGFILE"
done

