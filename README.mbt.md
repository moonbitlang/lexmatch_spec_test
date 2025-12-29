# lexmatch Spec Test Suite

This repository serves as the spec test suite for the `lexmatch` feature in the MoonBit language.

## Introduction to lexmatch

MoonBit is committed to being the perfect language for data processing tasks. Currently, the `match` expression is the primary way to destructure and analyze data. However, when it comes to string processing, it is not as powerful as regular expressions. The `lexmatch` feature combines the capabilities of `match` and regular expressions, providing a more flexible and powerful way to analyze and destructure strings.

The lexmatch feature in MoonBit comes in two forms: `lexmatch` expressions and `lexmatch?` expressions.

- **`lexmatch` expression**: Similar to the existing `match` expression, but the patterns in `lexmatch` expressions are "lex patterns" which differ from ordinary patterns. These patterns can be used to match `StringView` and `BytesView` types and can capture substrings during matching.

- **`lexmatch?` expression**: Similar to the existing `is` expression, but the pattern on the right side is a "lex pattern" used to check whether a value of `StringView` or `BytesView` type conforms to a certain lexical structure, and can capture substrings. The overall result of the expression is a boolean value indicating whether the match succeeded.

### Examples

#### Word Count

```mbt check
///|
pub fn wordcount(
  input : BytesView,
  lines : Int,
  words : Int,
  chars : Int,
) -> (Int, Int, Int) {
  struct State {
    lines : Int
    words : Int
    chars : Int
    data : BytesView
  }
  for state = { lines, words, chars, data: input } {
    lexmatch state.data with longest {
      ("\n", rest) => continue { ..state, lines: state.lines + 1, data: rest }
      ("[^ \t\r\n]+" as word, rest) =>
        continue {
            ..state,
            words: state.words + 1,
            chars: state.chars + word.length(),
            data: rest,
          }
      (".", rest) => continue { ..state, chars: state.chars + 1, data: rest }
      "" => break (state.lines, state.words, state.chars)
      _ => panic()
    }
  }
}
```
```mbt check
///|
test {
  inspect(
    wordcount("Hello World\nThis is MoonBit.", 0, 0, 0),
    content="(1, 5, 27)",
  )
}
```
The above example demonstrates how to use the `lexmatch` expression to perform lexical analysis on `input`, counting the number of lines, words, and characters. The patterns here include the ability to capture substrings, for example, the pattern `("[^ \t\r\n]+" as word, rest)` can match a sequence of non-whitespace characters and capture it as `word`.

#### Downloadable Protocol Extractor

```mbt check
///|
pub fn downloadable_protocol(url : StringView) -> StringView? {
  if url lexmatch? (("(?i:ftp|http(s)?)" as protocol) "://", _) with longest {
    Some(protocol)
  } else {
    None
  }
}
```

```mbt check
///|
test {
  @json.inspect(downloadable_protocol("https://example.com"), content=["https"])
  @json.inspect(downloadable_protocol("FTP://example.com"), content=["FTP"])
}
```

This example demonstrates how to use the `lexmatch?` expression to check whether a `url` starts with a downloadable protocol (ftp, http, https) and capture that protocol. This also demonstrates the use of the case-insensitive modifier `(?i:...)`.

#### Search Logs

This example shows how to use `lexmatch` to parse structured log data and extract error entries with their timestamps and messages. The pattern uses a wildcard prefix `_` to skip over non-matching content before finding `ERROR` lines.

```mbt check
///|
test {
  let log =
    #|INFO 2024-01-01 12:00:00 Starting service
    #|ERROR 2024-01-01 12:05:00 Failed to start service
    #|WARN 2024-01-01 12:10:00 Low memory
    #|INFO 2024-01-01 12:15:00 Service started successfully
    #|ERROR 2024-01-01 12:20:00 Service crashed unexpectedly
    #|ERROR 2024-01-01 12:25:00 Failed to restart service
  let error_logs : Array[Json] = []
  for curr = log[:] {
    lexmatch curr {
      (
        _,
        "ERROR[ ]*"
        (
          "[[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2} [[:digit:]]{2}:[[:digit:]]{2}:[[:digit:]]{2}" as timestamp
        )
        "[ ]*"
        ("[^\n]*" as message)
        "\n",
        next
      ) => {
        error_logs.push({ "timestamp": timestamp, "message": message })
        continue next
      }
      _ => break
    }
  }
  @json.inspect(error_logs, content=[
    { "timestamp": "2024-01-01 12:05:00", "message": "Failed to start service" },
    {
      "timestamp": "2024-01-01 12:20:00",
      "message": "Service crashed unexpectedly",
    },
  ])
}
```

### Core Concepts

#### Terminology

- **Target**: The `StringView` or `BytesView` being matched by `lexmatch`.

- **Match Strategy**: The strategy used to match patterns.
  - **Default** (without `with` clause): Uses first match semantics — branches are tried in order and the first matching branch is taken. This is the most common form for general string processing.
  - `with longest`: Uses longest match semantics — all branches are evaluated and the branch whose regex matches the **longest prefix** is selected. If multiple branches match the same length, the first one wins. This is primarily used for building **programming language lexers** where maximal munch is desired.


- **Catch-all case**: A branch whose left side is a variable or wildcard `_`, which can match any target. It must be placed at the end of the `lexmatch` branches to handle unmatched cases.

- **Lex Pattern**: The pattern part on the left side of the `lexmatch` branch (before `=>`), which differs from the guard part (currently `lexmatch` does not support guards).

  A lex pattern can be one of the following forms:

  | Form | Syntax | Anchoring | Availability |
  |------|--------|-----------|---------------|
  | **Bare regex** | `regex` | Left + Right | All strategies |
  | **Two-part** | `(regex, rest)` | Left only | All strategies |
  | **Three-part** | `(prefix, regex, rest)` | None | Default only (not with `longest`) |

  - **Bare regex**: Matches the entire target (both start and end anchored)
  - **Two-part**: Matches a prefix of the target; `rest` binds to the remaining suffix
  - **Three-part**: `prefix` binds to the content skipped before `regex`; `rest` binds to the suffix after `regex`. **Note:** This form is only available without `with longest`.

  The rest variable can be a variable name or wildcard `_`.

  **Examples:**
  - `""` — matches empty string (entire target must be empty)
  - `"[[:digit:]]+"` — matches if entire target consists of digits
  - `("[[:digit:]]+", rest)` — matches digits at the start; `rest` gets the remainder
  - `(_, "ERROR" ("[[:digit:]]+" as code), rest)` — finds "ERROR" followed by digits anywhere in the target; captures the digits as `code`

#### Lex Pattern Forms - Examples

The following examples demonstrate the three lex pattern forms and their anchoring behavior.

**Bare regex (left + right anchored)** — must match the entire target:

```mbt check
///|
test {
  // Bare regex matches entire target
  let result = if "12345" lexmatch? "[[:digit:]]+" {
    "all digits"
  } else {
    "not all digits"
  }
  inspect(result, content="all digits")

  // Fails if there's extra content
  let result2 = if "123abc" lexmatch? "[[:digit:]]+" {
    "all digits"
  } else {
    "not all digits"
  }
  inspect(result2, content="not all digits")

  // Empty string pattern matches empty target
  let result3 = if "" lexmatch? "" { "empty" } else { "not empty" }
  inspect(result3, content="empty")
}
```

**Two-part (left anchored only)** — matches prefix, rest captures remainder:

```mbt check
///|
test {
  // Two-part: matches prefix, captures rest
  lexmatch "123abc" with longest {
    ("[[:digit:]]+" as digits, rest) => {
      inspect(digits, content="123")
      inspect(rest, content="abc")
    }
    _ => fail("should match")
  }

  // Two-part must start from beginning
  let matched = "abc123" lexmatch? ("[[:digit:]]+", _) with longest
  inspect(matched, content="false") // digits not at start
}
```

**Three-part (no anchoring)** — prefix skips content, regex matches anywhere.

**Note:** Three-part form is only available without `with longest`:

```mbt check
///|
test {
  // Three-part: prefix binds the skipped content, find pattern anywhere (no 'with longest')
  lexmatch "hello ERROR123 world" {
    (prefix, "ERROR" ("[[:digit:]]+" as code), rest) => {
      inspect(prefix, content="hello ")
      inspect(code, content="123")
      inspect(rest, content=" world")
    }
    _ => fail("should not match")
  }

  // Three-part can find pattern in middle of string
  lexmatch "prefix>>>MARKER<<<suffix" {
    (prefix, "MARKER", rest) => {
      inspect(prefix, content="prefix>>>")
      inspect(rest, content="<<<suffix")
    }
    _ => fail("should not match")
  }
}
```

#### Match Strategy Examples

**Default (without `with` clause)** — the standard form for general string processing:

```mbt check
///|
test {
  // Default strategy: first match, patterns tried in order
  lexmatch "hello world" {
    ("hello", rest) => inspect(rest, content=" world")
    _ => fail("should match")
  }

  // Three-part form is available in default mode
  lexmatch "abc123def" {
    (prefix, "[[:digit:]]+" as digits, rest) => {
      inspect(prefix, content="abc")
      inspect(digits, content="123")
      inspect(rest, content="def")
    }
    _ => fail("should match")
  }
}
```

**`with longest`** — specialized for programming language lexers:

```mbt check
///|
test {
  // With longest: all branches are checked, longest match wins
  // Here "[a-z]+" matches "ifx" (3 chars) vs "if" matches only 2 chars
  // So the second branch is selected because it matches longer
  lexmatch "ifx" with longest {
    ("if", _) => fail("should not match - 'if' is only 2 chars")
    ("[a-z]+" as id, rest) => {
      inspect(id, content="ifx") // matched all 3 chars
      inspect(rest, content="")
    }
    _ => fail("should match")
  }

  // Compare with default (first match): "if" branch would win
  lexmatch "ifx" {
    ("if", rest) => inspect(rest, content="x") // first match wins
    ("[a-z]+", _) => fail("should not reach - first branch matched")
    _ => fail("should match")
  }
}
```

- **Regex Pattern**: Regex patterns have three forms:
  - **Regex literal**: A string literal representing a regex pattern. Example: `"[^ \t\r\n]+"`. Note that regex literals must be enclosed in double quotes and do not require double escaping. For example, to match a backslash character, use `"\\"` instead of `"\\\\"`.
  - **Capture**: A regex pattern followed by `as` and a variable name to capture the matched substring. Example: `"[^ \t\r\n]+" as word`. If the lex pattern is a bare regex pattern of this form, parentheses are required.
  - **Sequence**: A sequence of regex patterns separated by spaces. Example: `"//" ("[^\r\n]*" as comment)`. If the lex pattern is a bare regex pattern of this form, parentheses are required.

  Regex patterns can be nested to form more complex patterns.

#### Regex Literal Syntax Quick Reference

- **Literal Characters**: Characters other than special characters (`\`, `[`, `]`, `(`, `)`, `{`, `}`, `.`, `*`, `+`, `?`, `|`, `^`, `$`) match their literal value. Examples: `a`, `Z`, `0`, `@`, etc.
- `.`: Matches any single character, including newlines
- **Escape Characters**:
  - `\n`: Newline character
  - `\r`: Carriage return character
  - `\t`: Tab character
  - `\\`: Backslash character
  - `\[`, `\]`, `\(`, `\)`, `\{`, `\}`, `\.`, `\*`, `\+`, `\?`, `\|`, `\^`, `\$`: Match the corresponding literal character
  - `\xhh`: Matches a character with hexadecimal value `hh` (`hh` is two hexadecimal digits)
  - `\uhhhh`: Matches a character with Unicode code point `hhhh` (`hhhh` is four hexadecimal digits). Note that this escape sequence is invalid when the target is `BytesView`.
  - `\u{h...}`: Matches a character with Unicode code point `h...` (`h...` is one or more hexadecimal digits). Note that this escape sequence is invalid when the target is `BytesView`.
- **Character Classes (deprecated escapes and POSIX alternatives)**:
  - Note: The common escape sequences `\s`, `\S`, `\d`, `\D`, `\w`, and `\W` are deprecated in `lexmatch` regexes. Use the POSIX-style classes below instead. All POSIX classes here operate on the ASCII range only.
  - Supported POSIX character classes (only recognized inside a bracket expression `[...]`):
    - `[:ascii:]` — ASCII characters U+0000..U+007F. Example: `[[:ascii:]]` matches any ASCII codepoint.
    - `[:lower:]` — ASCII lowercase letters `a`–`z`. Example: `[[:lower:]]` matches `a`, `b`, ..., `z`.
    - `[:upper:]` — ASCII uppercase letters `A`–`Z`. Example: `[[:upper:]]` matches `A`, `B`, ..., `Z`.
    - `[:alpha:]` — ASCII letters, equivalent to `[[:lower:][:upper:]]`.
    - `[:digit:]` — ASCII digits `0`–`9`. Example: `[[:digit:]]` matches `0`..`9`.
    - `[:xdigit:]` — ASCII hexadecimal digits `0`–`9`, `A`–`F`, `a`–`f` (equivalent to `[0-9A-Fa-f]`).
    - `[:alnum:]` — ASCII alphanumeric characters, equivalent to `[[:alpha:][:digit:]]`.
    - `[:blank:]` — ASCII horizontal whitespace: space and tab (equivalent to `[ \t]`).
    - `[:space:]` — ASCII whitespace characters (space, tab, newline, carriage return, form feed, vertical tab) — use for matching general ASCII whitespace.
    - `[:word:]` — ASCII word characters, equivalent to `[A-Za-z0-9_]`.
  - Important usage rule: POSIX classes are only recognized when placed inside a character class. Use `[[:digit:]]`, not `[:digit:]` alone; the latter is not a valid character class.
  - Common mappings (for porting existing patterns):
    - `\d`  → `[[:digit:]]`
    - `\D`  → `[^[:digit:]]`
    - `\s`  → `[[:space:]]`
    - `\S`  → `[^[:space:]]`
    - `\w`  → `[[:word:]]`
    - `\W`  → `[^[:word:]]`
  - Examples and tips:
    - Match a single hex digit: `[[:xdigit:]]` (equivalent to `[0-9A-Fa-f]`).
    - Match one or more ASCII letters: `[[:alpha:]]+`.
    - Combine classes: `[[:alpha:][:digit:]]` matches any ASCII letter or digit (same as `[[:alnum:]]`).
    - Negation: `[^[:space:]]` matches any character that is not ASCII whitespace.
  - Rationale: restricting these classes to ASCII keeps `lexmatch` behavior predictable for `BytesView` targets and avoids locale/Unicode category complexity.
- **Character Sets**:
  - `[abc]`: Matches character `a`, `b`, or `c`
  - `[a-z]`: Matches any character from `a` to `z`
  - `[^abc]`: Matches any character except `a`, `b`, and `c`
  - `[^a-z]`: Matches any character not in the range `a` to `z`
  - `[[:digit:][:space:]]`: Matches any digit or whitespace character (use POSIX classes inside the brackets)
- **Quantifiers**:
  - `*`: Matches the preceding sub-expression zero or more times (greedy)
  - `+`: Matches the preceding sub-expression one or more times (greedy)
  - `?`: Matches the preceding sub-expression zero or one time (greedy)
  - `{n}`: Matches the preceding sub-expression exactly n times
  - `{n,}`: Matches the preceding sub-expression at least n times (greedy)
  - `{n,m}`: Matches the preceding sub-expression at least n times, but no more than m times (greedy)
- **Non-greedy quantifiers** (only available with first match strategy, i.e., without `with longest`):
  - `*?`: Matches the preceding sub-expression zero or more times (non-greedy)
  - `+?`: Matches the preceding sub-expression one or more times (non-greedy)
  - `??`: Matches the preceding sub-expression zero or one time (non-greedy)
  - `{n}?`: Matches the preceding sub-expression exactly n times (non-greedy)
  - `{n,}?`: Matches the preceding sub-expression at least n times (non-greedy)
  - `{n,m}?`: Matches the preceding sub-expression at least n times, but no more than m times (non-greedy)

  **Semantics**: Greedy quantifiers match as much as possible while still allowing the overall pattern to succeed, whereas non-greedy (lazy) quantifiers match as little as possible while still allowing the overall pattern to succeed. For example:
  - With greedy `.*`, the pattern `"<.*>"` matches from the first `<` to the last `>` in `"<a><b>"`, capturing `"<a><b>"`.
  - With non-greedy `.*?`, the pattern `"<.*?>"` matches from the first `<` to the first `>` in `"<a><b>"`, capturing `"<a>"`.
- **Anchors**:
  - `$`: Matches the end position of the input string
- **Scoped Modifiers**:
  - `(?i:...)`: Case-insensitive matching for the sub-expression within the parentheses

#### Semantics

The `lexmatch` expression works similarly to the `match` expression, but with the following differences:

1. The target of a `lexmatch` expression must be `StringView` or `BytesView`.
2. Except for the catch-all branch, the left side of each `lexmatch` branch must be a lex pattern.
3. A match strategy can optionally be specified after the `with` keyword. Without it, the default first-match strategy is used. Use `with longest` for lexer-style longest match semantics.
4. **Anchoring behavior**:
   - **Bare regex** `regex`: Must match the entire target (implicitly anchored at both start and end).
   - **Two-part** `(regex, rest)`: The regex must match starting from the beginning of the target (left-anchored); `rest` captures whatever remains.
   - **Three-part** `(prefix, regex, rest)`: The `prefix` consumes content before `regex`; `regex` can match anywhere after the prefix; `rest` captures what follows. **Note:** This form is only available without `with longest`.
5. If a regex pattern matches, any capture variables (`as name`) in the pattern will be bound to the corresponding matched substrings.
6. If no lex pattern matches the target, the catch-all branch will be executed.

#### Special Notes

- When capturing a single character, the matched substring is a `Char` or `Byte`, not a `StringView` or `BytesView`. Example: `"[+\-]" as sign`

- Regex literals are essentially equivalent to JavaScript regular expression syntax with the v flag enabled, but with the following differences:
  - The `"(abc)"` regex pattern does not introduce a capture group. To capture a matched substring, use the `as` syntax. Example: `"abc" as group` instead of `"(abc)"`.
  - Non-multiline mode by default (multiline mode is not currently supported), `$` matches the end of the string. `.` matches all characters, including newlines.
  - Scoped modifier syntax (like `(?i:...)`) can only enable one modifier per group. For example, `(?im:...)` is not currently supported. Negated modifiers like `(?-i:...)` are also not supported. Currently, the only supported modifier is `i` (case-insensitive).
  - For future consideration of adding interpolation support, regex literals do not support using "\{" to match the left brace character. Similarly, the right brace character does not support using "\}" to match. If you need to match brace characters, please use literal characters `[{]` and `[}]`.

### FAQ

**Q: Why not use regex patterns directly in `match` expressions?**

A: `match` expressions are designed for structural pattern matching, while `lexmatch` expressions are designed for lexical analysis. Mixing these two concepts can lead to confusion and complexity. By introducing a separate expression for lexical analysis, we can maintain semantic clarity and focus.
