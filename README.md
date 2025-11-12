# lexmatch Spec Test Suite

This repository serves as the spec test suite for the `lexmatch` feature in the MoonBit language.

## Introduction to lexmatch

MoonBit is committed to being the perfect language for data processing tasks. Currently, the `match` expression is the primary way to destructure and analyze data. However, when it comes to string processing, it is not as powerful as regular expressions. The `lexmatch` feature combines the capabilities of `match` and regular expressions, providing a more flexible and powerful way to analyze and destructure strings.

The lexmatch feature in MoonBit comes in two forms: `lexmatch` expressions and `lexmatch?` expressions.

- **`lexmatch` expression**: Similar to the existing `match` expression, but the patterns in `lexmatch` expressions are "lex patterns" which differ from ordinary patterns. These patterns can be used to match `StringView` and `BytesView` types and can capture substrings during matching.

- **`lexmatch?` expression**: Similar to the existing `is` expression, but the pattern on the right side is a "lex pattern" used to check whether a value of `StringView` or `BytesView` type conforms to a certain lexical structure, and can capture substrings. The overall result of the expression is a boolean value indicating whether the match succeeded.

### Examples

#### Word Count

```moonbit
///|
pub fn wordcount(
  input : BytesView,
  lines : Int,
  words : Int,
  chars : Int,
) -> (Int, Int, Int) {
  lexmatch input with longest {
    ("\n", rest) => wordcount(rest, lines + 1, words, chars)
    ("[^ \t\r\n]+" as word, rest) =>
      wordcount(rest, lines, words + 1, chars + word.length())
    (".", rest) => wordcount(rest, lines, words, chars + 1)
    "" => (lines, words, chars)
    _ => panic()
  }
}
```

The above example demonstrates how to use the `lexmatch` expression to perform lexical analysis on `input`, counting the number of lines, words, and characters. The patterns here include the ability to capture substrings, for example, the pattern `("[^ \t\r\n]+" as word, rest)` can match a sequence of non-whitespace characters and capture it as `word`.

#### Downloadable Protocol Extractor

```moonbit
///|
pub fn downloadable_protocol(url: StringView) -> StringView? {
  if url lexmatch? (("(?i:ftp|http(s)?)" as protocol) "://", _) with longest {
    Some(protocol)
  } else {
    None
  }
}
```

This example demonstrates how to use the `lexmatch?` expression to check whether a `url` starts with a downloadable protocol (ftp, http, https) and capture that protocol. This also demonstrates the use of the case-insensitive modifier `(?i:...)`.

### Core Concepts

#### Terminology

- **Target**: The `StringView` or `BytesView` being matched by `lexmatch`.

- **Match Strategy**: The strategy used to match patterns, which can be `longest` (longest match) or `first` (first match, default, currently unavailable). This proposal focuses on the `longest` match strategy.

- **Catch-all case**: A branch whose left side is a variable or wildcard `_`, which can match any target. It must be placed at the end of the `lexmatch` branches to handle unmatched cases.

- **Lex Pattern**: The pattern part on the left side of the `lexmatch` branch (before `=>`), which differs from the guard part (currently `lexmatch` does not support guards).

  A lex pattern can be one of the following forms:
  - **Bare regex pattern**: A regex pattern that matches the entire target. Example: `""`
  - **Regex pattern + rest variable**: A regex pattern that matches a prefix of the target, with the rest variable bound to the remaining suffix. The rest variable can be a variable or wildcard `_`. This form requires parentheses for readability. Example: `("\n", rest)`

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
- **Character Classes**:
  - `\s`: Matches any whitespace character in the ASCII range, equivalent to `[ \t\r\n\f\v]`
  - `\S`: Matches any non-whitespace character in the ASCII range, equivalent to `[^ \t\r\n\f\v]`
  - `\d`: Matches any digit character in the ASCII range, equivalent to `[0-9]`
  - `\D`: Matches any non-digit character in the ASCII range, equivalent to `[^0-9]`
  - `\w`: Matches any word character in the ASCII range, equivalent to `[a-zA-Z0-9_]`
  - `\W`: Matches any non-word character in the ASCII range, equivalent to `[^a-zA-Z0-9_]`
- **Character Sets**:
  - `[abc]`: Matches character `a`, `b`, or `c`
  - `[a-z]`: Matches any character from `a` to `z`
  - `[^abc]`: Matches any character except `a`, `b`, and `c`
  - `[^a-z]`: Matches any character not in the range `a` to `z`
  - `[\d\s]`: Matches any digit or whitespace character
- **Quantifiers**:
  - `*`: Matches the preceding sub-expression zero or more times
  - `+`: Matches the preceding sub-expression one or more times
  - `?`: Matches the preceding sub-expression zero or one time
  - `{n}`: Matches the preceding sub-expression exactly n times
  - `{n,}`: Matches the preceding sub-expression at least n times
  - `{n,m}`: Matches the preceding sub-expression at least n times, but no more than m times
- **Anchors**:
  - `$`: Matches the end position of the input string
- **Scoped Modifiers**:
  - `(?i:...)`: Case-insensitive matching for the sub-expression within the parentheses

#### Semantics

The `lexmatch` expression works similarly to the `match` expression, but with the following differences:

1. The target of a `lexmatch` expression must be `StringView` or `BytesView`.
2. Except for the catch-all branch, the left side of each `lexmatch` branch must be a lex pattern.
3. A match strategy can be specified after the `with` keyword. If not specified, the default strategy is `first` (currently unavailable).
4. Regex patterns in lex patterns match the target using the specified match strategy.
5. If a regex pattern matches the target, any capture variables in the pattern will be bound to the corresponding matched substrings.
6. If a regex pattern followed by a comma and rest variable matches the target, the regex pattern will match a prefix of the target, and the rest variable will be bound to the remaining suffix.
7. If no lex pattern matches the target, the catch-all branch will be executed.

#### Special Notes

- When capturing a single character, the matched substring is a `Char` or `Byte`, not a `StringView` or `BytesView`. Example: `"[+\-]" as sign`

- Regex literals are essentially equivalent to JavaScript regular expression syntax with the v flag enabled, but with the following differences:
  - The `"(abc)"` regex pattern does not introduce a capture group. To capture a matched substring, use the `as` syntax. Example: `"abc" as group` instead of `"(abc)"`.
  - Non-multiline mode by default (multiline mode is not currently supported), `$` matches the end of the string. `.` matches all characters, including newlines.
  - Scoped modifier syntax (like `(?i:...)`) can only enable one modifier per group. For example, `(?im:...)` is not currently supported. Negated modifiers like `(?-i:...)` are also not supported. Currently, the only supported modifier is `i` (case-insensitive).
  - For future consideration of adding interpolation support, regex literals do not support using "\{" to match the left brace character. Similarly, the right brace character does not support using "\}" to match. If you need to match brace characters, please use literal characters `[{]` and `[}]`.

### Usage Tips

#### Searching for a Marker in a String

```moonbit
pub fn search_marker(str: StringView) -> StringView? {
  for curr = str {
    lexmatch curr with longest {
      "" => return None
      ("MARKER", right) => return Some(right)
      (".", rest) => continue rest
      _ => panic()
    }
  }
}
```

### FAQ

**Q: Why not use regex patterns directly in `match` expressions?**

A: `match` expressions are designed for structural pattern matching, while `lexmatch` expressions are designed for lexical analysis. Mixing these two concepts can lead to confusion and complexity. By introducing a separate expression for lexical analysis, we can maintain semantic clarity and focus.
