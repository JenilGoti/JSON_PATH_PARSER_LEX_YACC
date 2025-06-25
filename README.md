# 🧪 Little JSONPath Parser (Based on PostgreSQL Lex/Yacc)

This is a small, simplified JSONPath parser written in **C**, using **Flex** (Lex) and **Bison** (Yacc), inspired by PostgreSQL’s internal JSONPath parser.

It supports basic JSONPath expressions like:
```
$.store.book[0].title
$.items[*]
```
---

## 📦 Requirements

Make sure the following packages are installed on your system:

- **Flex** – Lexical analyzer
- **Bison** – Parser generator
- **GCC** – C compiler
- **Make** – Build tool

### ✅ Install on Ubuntu/Debian

```bash
sudo apt update
sudo apt install flex bison gcc make
```
### ✅ Install on Fedora
```
sudo dnf install flex bison gcc make
```
### ✅ Install on Arch
```
sudo pacman -S flex bison gcc make
```
### ✅ Install on macOS (Homebrew)

```
brew install flex bison gcc make
```
Note (macOS): After installation, you may need to set the path:
```
export PATH="/opt/homebrew/opt/bison/bin:$PATH"
export PATH="/opt/homebrew/opt/flex/bin:$PATH"
```
# 🚀 Getting Started
## 1. Clone the repository
```
git clone https://github.com/JenilGoti/JSON_PATH_PARSER_LEX_YACC/
cd jsonpath-parser
```
## 2. Build the parser
```
make
```
## 3. Run the parser
```
./jsonpath
```
You will be prompted to enter a JSONPath expression:
```
Enter JSONPath: $.store.book[0].title
✅ Valid JSONPath expression
Parsed Path: $.store.book[0].title
```
## 🧹 Clean the build
```
make clean
```
# 📁 Project Structure
```
jsonpath-parser/
├── jsonpath.l         # Lex file (token definitions)
├── jsonpath.y         # Yacc file (grammar rules)
├── main.c             # Main program to run the parser
├── Makefile           # Build instructions
└── README.md          # Project documentation
```
# 📘 Reference
This project is inspired by the JSONPath parser from the PostgreSQL source code:

* [jsonpath.l](jsonpath.l)

* [jsonpath.y](jsonpath.y)

