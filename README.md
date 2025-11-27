# **BFMaster - A Minimalist Brainfuck Interpreter & Encoder (Shell Script)**

**BFMaster** is a lightweight, POSIX‑friendly Brainfuck interpreter and encoder written entirely in pure Shell.
It runs fully in userspace (no root required - and never recommended) and can be used either as a standalone utility or installed as a global alias.

This project originally began as a small, playful birthday gift - a nod to the name *bf*, referencing both **Brainfuck** and **boyfriend** - and eventually evolved into a clean, functional tool ready for public use.

---

## **What Is Brainfuck?**

**Brainfuck** is a minimalist *esoteric programming language* (esolang) created by Urban Müller in 1993. Despite its extremely small instruction set, it models a clean and elegant abstract machine based on direct memory manipulation and pointer arithmetic.

### **Technical Overview**

Brainfuck operates on two core components:

* A **tape** of memory cells (commonly bytes initialized to zero)
* A **data pointer** that moves left and right across this tape

Programs are composed entirely of eight single-character instructions that manipulate the tape, control flow, and I/O.

### **Instruction Set**

```
>   Move the data pointer to the right
<   Move the data pointer to the left
+   Increment the value at the current cell
-   Decrement the value at the current cell
.   Output the value at the current cell as ASCII
,   Read one byte of input into the current cell
[   If current cell == 0, jump forward to the matching ]
]   If current cell != 0, jump back to the matching [
```

### **Execution Model**

The `[` and `]` instructions implement loop constructs similar to a low-level `while` loop:

* `[` acts as “jump forward if the current cell is zero”
* `]` acts as “jump backward if the current cell is non-zero”

Interpreters typically precompute a **jump table** to efficiently map each `[` to its corresponding `]`.

### **Why It Matters**

Even with only eight commands, Brainfuck is **Turing-complete**, meaning it can represent any computable algorithm given enough tape.
Its simplicity makes it a common teaching tool for:

* Interpreter design
* Parsing and token execution
* Memory architecture concepts
* Manual pointer manipulation
* Minimal instruction-set computation
* Esoteric language experimentation

### **BFMaster provides:**

* A Brainfuck interpreter (executes BF programs)
* A Brainfuck encoder (converts text into BF instructions)
* Optional support for pre-loaded BF messages

---

## **Features**

* Fully POSIX‑compliant shell script
* No external dependencies
* Works on Bash, Zsh, and other POSIX shells
* Lightweight (under ~300 lines without comments)
* Clear, user‑friendly menu interface
* Encodes arbitrary text into Brainfuck
* Decodes and executes Brainfuck programs
* Optional alias installation (`bfmaster`)
* Safe local usage — *no root privileges required*

---

## **Security Notice**

This script **must never be executed with sudo or as root**.
Running arbitrary shell scripts as root is a major security risk.

A good general rule:

> If a script from the Internet tells you to use `sudo` without explanation, close the tab.

BFMaster is safe, but always protect your system.

---

## **Installation**

### **1. Download the script**

Using `curl`:

```sh
curl -O https://raw.githubusercontent.com/<your-user>/<your-repo>/main/bfmaster.sh
chmod +x bfmaster.sh
```

Or download directly via GitHub Web.

### **2. (Optional) Install the `bfmaster` alias**

You can add it manually:

```sh
echo "alias bfmaster=\"$HOME/s2/brainfuckmaster.sh\"" >> ~/.bashrc
```

Reload your shell:

```sh
source ~/.bashrc
```

Then simply run:

```sh
bfmaster
```

---

## **Usage**

Launch the script:

```sh
./bfmaster.sh
```

### **Menu Options**

#### **Interpreter**

Paste Brainfuck code and it will execute.

#### **Encoder**

Enter a string and receive the equivalent Brainfuck.

#### **Terms**

Displays notes about optional pre‑loaded messages.

#### **Info**

Simple informational message.

#### **Exit**

Gracefully closes the script.

---

## **Predefined Brainfuck Message (Optional)**

The script includes an optional variable:

```sh
MESSAGE_BF=""
```

This field is intentionally blank in the public version.
Users may insert any BF program or encoded message for demonstration or distribution.
The interpreter does *not* depend on this value.

---

## **Examples**

### **Encoding “Hello”**

Output may look like:

```
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++.
+++++++++++++++++++++++++++++++.
+++++++.
+++.
-------------------------------------------------------------------.
```

### **Interpreting a BF Program**

Input:

```
++++++++++[>+++++++>++++++++++>+++>+<<<<-]>>>++.>+.+++++++..+++.
```

Output:

```
Hello
```

---

## **Project Structure**

```
bfmaster.sh       # main script
README.md         # documentation
LICENSE           # WTFPL license
```

---

## **License — WTFPL v2**

```
DO WHAT THE F*** YOU WANT TO PUBLIC LICENSE
Version 2, December 2004

Copyright (C) <you>

Everyone is permitted to copy and distribute verbatim or modified
copies of this license document, and changing it is allowed as long
as the name is changed.

DO WHAT YOU WANT TO.
```

A full copy is included in the repository.

---

## **Contributing**

Contributions are welcome:

* POSIX improvements
* Cleaner parsing logic
* Performance tweaks
* Extra esolang support
* Test cases

Feel free to open issues or PRs.

---

## **❤️ Acknowledgments**

This script began as a simple, lighthearted birthday idea - and grew into a compact reference implementation of a Brainfuck interpreter and encoder in pure shell.

Thanks to everyone who keeps esolangs fun, weird, and alive.

*All my love for the reffered one.*
