# 🤖 Modular Personality Bash Chatbot

A playful, multi-personality Bash chatbot with dynamic triggers, colorful responses, and fun modes — perfect for learning Bash, testing triggers, or just having a laugh.

---

## Features

- **Multiple personalities:**  
  - **Bash Tutor** – 80’s valley girl style responses  
  - **Hot Date** – sassy, flirty responses  
  - **Yoga Teacher** – overly nice, calming responses  
  - **Paul the Alien** – scientific, quantum-inspired big words  
- **Ghost Mode:** Slow typing with blue text for dramatic effect  
- **Dynamic triggers:** Fetches personality triggers from GitHub so updates are automatic  
- **Funny fallback responses:** When a user’s input is unusual or “bizarre”  
- **TinyURL integration:** Long links automatically shortened  
- **Logging:** All conversations stored in a single log file

---

## Getting Started

### Prerequisites

- Bash (tested on Bash 4+)  
- `curl` installed (for fetching GitHub triggers and shortening URLs)

---

### Installation

1. Clone the repository:

```bash
git clone https://github.com/<yourusername>/<repo-name>.git
cd <repo-name>
```

2. Make the bot executable:

```bash
chmod +x chatbot.sh
```

3. Run the chatbot:

```bash
./chatbot.sh
```

---

## Usage

- **Switch personalities:**

```bash
mode bash     # Bash tutor (80's valley girl)
mode hotdate  # Sassy, flirty responses
mode yoga     # Overly nice yoga teacher
mode paul     # Paul the Alien, scientific responses
```

- **Ghost Mode:**

```bash
ghost    # Activate slow, blue typing
unghost  # Deactivate ghost mode
```

- **Quit chatbot:**

```bash
quit
```

- **Trigger responses:**  
  Just type words or phrases that match triggers (like `hello`, `bash tutorial`, `stretch`, `quantum`). The bot will reply accordingly.

---

## Triggers

- Stored in GitHub and automatically fetched by the bot:  
  - `triggers.txt` – Bash tutor  
  - `hotdate_triggers.txt` – Hot Date  
  - `yoga_triggers.txt` – Yoga teacher  
  - `paul_triggers.txt` – Paul the Alien

- **Dynamic updates:**  
  Add or edit triggers on GitHub; the bot will fetch the latest versions when switching modes.

---

## Logging

All conversations are stored in `chat_log.txt` in the same directory. You can review or analyze past conversations anytime.

---

## Contribution

Feel free to:  
- Add new trigger words  
- Improve personalities  
- Suggest new Easter eggs or fun features

**Pull requests:**  
- Fork the repo  
- Create a new branch  
- Make your changes  
- Submit a pull request

---

## License

MIT License – free to use, modify, and distribute.

---

## Example Conversation

```text
You: hello
Bot: Oh my gosh! Like, hi! So totally rad to see you!

You: bash tutorial
Bot: Like, you HAVE to check this Bash thingy! It’s, like, super cool!

You: ghost
👻 Ghost mode activated!

You: hi
Bot: (slow blue typing) hi

You: quantum
Bot: Quantum superposition is fundamentally counterintuitive to classical observers.
```

---

This README gives your repo all the info users need: installation, usage, personalities, triggers, ghost mode, logging, and examples.

