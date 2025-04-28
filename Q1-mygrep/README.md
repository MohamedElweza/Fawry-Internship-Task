# 🛠️ MyGrep Script

Welcome!  
This repository contains `mygrep.sh`, a **mini version** of the Unix `grep` command, developed as part of a DevOps Internship Task.

The script searches for a **search string** inside a **text file** with support for the following options:
- `-n`: Display line numbers alongside matching lines.
- `-v`: Invert the match; show lines that do **not** contain the search string.
- `--help`: Display the usage/help instructions.

---

## 🚀 How to Use

```bash
./mygrep.sh [options] search_string filename
```

### Options:

| Option     | Description                                              |
|------------|----------------------------------------------------------|
| `-n`       | Show line numbers with matching lines.                  |
| `-v`       | Invert the match: show lines that **do not** match.      |
| `--help`   | Display help message and exit.                           |

✅ You can combine options like `-nv`, `-vn`, or use them separately: `-n -v`.

---

## 📂 Examples

- **Normal match**:
  ```bash
  ./mygrep.sh "error" logfile.txt

  ```
![Screenshot (393)](https://github.com/user-attachments/assets/10ffeb6d-f575-4ca8-b174-1be732d76bd6)

- **Match with line numbers**:
  ```bash
  ./mygrep.sh -n "error" logfile.txt
  ```
![Screenshot (394)](https://github.com/user-attachments/assets/66b5828e-8aa5-49f8-974e-3eca875b8706)

- **Invert match (show lines that do not contain "error")**:
  ```bash
  ./mygrep.sh -v "error" logfile.txt
  ```
![Screenshot (395)](https://github.com/user-attachments/assets/9c997011-6691-411b-b0e2-5f2bf4156ac9)

- **Invert match with line numbers**:
  ```bash
  ./mygrep.sh -vn "error" logfile.txt
  ```
![Screenshot (396)](https://github.com/user-attachments/assets/fc1a3563-d42c-436a-8e2e-abb785af4729)

---

## 🧠 Reflective Section

### 1. Breakdown: How the Script Handles Arguments and Options

- The script first checks if the provided arguments are sufficient (after parsing options).
- It then loops through the arguments that start with `-` to handle options:
  - If the option is `-n`, it enables line numbers.
  - If the option is `-v`, it enables inverted matching.
  - If `--help` is passed, it immediately displays the help message and exits.
  - If an invalid option is detected, an error message is printed, and the script exits.
- After parsing options, the script expects exactly **two arguments**:
  1. The **search string**.
  2. The **filename**.
- If the file does not exist, the script prints an error and exits.
- It reads the file line-by-line, performs a case-insensitive search, applies the invert match if necessary, and prints results accordingly.

---

### 2. How the Structure Would Change for Regex or Additional Options (`-i`, `-c`, `-l`)

If I were to add support for regex matching or options like:
- `-i` (ignore case)
- `-c` (count number of matches)
- `-l` (list files with matches)

I would:
- Introduce additional boolean flags (e.g., `ignore_case`, `count_matches`, `list_files`).
- Expand the options parsing logic to set these flags when encountered.
- Adjust the file reading loop to:
  - Use `grep -E` or `[[ "$line" =~ $regex ]]` for regex support.
  - Keep a counter if `-c` is enabled.
  - Stop after the first match if `-l` is enabled.
- Modularize the matching logic into a function to avoid repeating code.

This modular approach would make the script **easier to extend** and **easier to maintain**.

---

### 3. Hardest Part and Why

The most challenging part for me was **handling combined options** like `-nv` or `-vn` in one single argument.

It was my first time writing a parser that splits a combined flag (e.g., parsing each character individually from `-nv`).  
Ensuring that options are correctly understood **regardless of the order** they were written (`-v -n` or `-vn`) was a new and exciting challenge.

This experience strengthened my understanding of how CLI tools parse and handle user inputs flexibly, which is an important skill for a DevOps Engineer.

---

## 📎 Notes

- This script is fully case-insensitive.
- Proper input validation is implemented.
- Error messages are descriptive to improve usability.

---

