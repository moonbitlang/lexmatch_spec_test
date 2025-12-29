///|
test "[abc]" {
  lexmatch "b" {
    "[abc]" => ()
    _ => fail("Should match [abc]")
  }
  lexmatch "d" {
    "[abc]" => fail("Should not match [abc]")
    _ => ()
  }
}

///|
test "[^abc]" {
  lexmatch "d" {
    "[^abc]" => ()
    _ => fail("Should match [^abc]")
  }
  lexmatch "b" {
    "[^abc]" => fail("Should not match [^abc]")
    _ => ()
  }
}

///|
test "[a-zA-Z]" {
  lexmatch "G" {
    "[a-zA-Z]" => ()
    _ => fail("Should match [a-zA-Z]")
  }
  lexmatch "5" {
    "[a-zA-Z]" => fail("Should not match [a-zA-Z]")
    _ => ()
  }
}

///|
test "[[:space:]] - whitespace character class" {
  lexmatch " " {
    "[[:space:]]" => ()
    _ => fail("Should match space")
  }
  lexmatch "\t" {
    "[[:space:]]" => ()
    _ => fail("Should match tab")
  }
  lexmatch "\n" {
    "[[:space:]]" => ()
    _ => fail("Should match newline")
  }
  lexmatch "a" {
    "[[:space:]]" => fail("Should not match non-whitespace")
    _ => ()
  }
}

///|
test "[^[:space:]] - non-whitespace character class" {
  lexmatch "a" {
    "[^[:space:]]" => ()
    _ => fail("Should match non-whitespace")
  }
  lexmatch " " {
    "[^[:space:]]" => fail("Should not match whitespace")
    _ => ()
  }
}

///|
test "[[:digit:]] - digit character class" {
  lexmatch "5" {
    "[[:digit:]]" => ()
    _ => fail("Should match digit")
  }
  lexmatch "0" {
    "[[:digit:]]" => ()
    _ => fail("Should match digit 0")
  }
  lexmatch "9" {
    "[[:digit:]]" => ()
    _ => fail("Should match digit 9")
  }
  lexmatch "a" {
    "[[:digit:]]" => fail("Should not match non-digit")
    _ => ()
  }
}

///|
test "[^[:digit:]] - non-digit character class" {
  lexmatch "a" {
    "[^[:digit:]]" => ()
    _ => fail("Should match non-digit")
  }
  lexmatch "5" {
    "[^[:digit:]]" => fail("Should not match digit")
    _ => ()
  }
}

///|
test "[[:word:]] - word character class" {
  lexmatch "a" {
    "[[:word:]]" => ()
    _ => fail("Should match letter")
  }
  lexmatch "Z" {
    "[[:word:]]" => ()
    _ => fail("Should match uppercase letter")
  }
  lexmatch "5" {
    "[[:word:]]" => ()
    _ => fail("Should match digit")
  }
  lexmatch "_" {
    "[[:word:]]" => ()
    _ => fail("Should match underscore")
  }
  lexmatch " " {
    "[[:word:]]" => fail("Should not match space")
    _ => ()
  }
  lexmatch "-" {
    "[[:word:]]" => fail("Should not match hyphen")
    _ => ()
  }
}

///|
test "[^[:word:]] - non-word character class" {
  lexmatch " " {
    "[^[:word:]]" => ()
    _ => fail("Should match non-word character")
  }
  lexmatch "a" {
    "[^[:word:]]" => fail("Should not match word character")
    _ => ()
  }
}

///|
test "\\n - newline escape" {
  lexmatch "\n" {
    "\n" => ()
    _ => fail("Should match newline")
  }
}

///|
test "\\r - carriage return escape" {
  lexmatch "\r" {
    "\r" => ()
    _ => fail("Should match carriage return")
  }
}

///|
test "\\t - tab escape" {
  lexmatch "\t" {
    "\t" => ()
    _ => fail("Should match tab")
  }
}

///|
test "\\\\ - backslash literal" {
  lexmatch "\\" {
    "\\" => ()
    _ => fail("Should match backslash")
  }
}

///|
test "\\xhh - hex escape" {
  lexmatch "A" {
    "\x41" => ()
    _ => fail("Should match hex 41 (character A)")
  }
  lexmatch "0" {
    "\x30" => ()
    _ => fail("Should match hex 30 (character 0)")
  }
}

///|
test "\\uhhhh - unicode escape" {
  lexmatch "A" {
    "\u0041" => ()
    _ => fail("Should match unicode 0041 (character A)")
  }
}

///|
test "\\u{h...} - unicode escape with braces" {
  lexmatch "😀" {
    "\u{1F600}" => ()
    _ => fail("Should match unicode 1F600 (emoji)")
  }
}

///|
test "Escaped special characters" {
  lexmatch "." {
    "\." => ()
    _ => fail("Should match literal dot")
  }
  lexmatch "*" {
    "\*" => ()
    _ => fail("Should match literal asterisk")
  }
  lexmatch "+" {
    "\+" => ()
    _ => fail("Should match literal plus")
  }
  lexmatch "?" {
    "\?" => ()
    _ => fail("Should match literal question mark")
  }
  lexmatch "[" {
    "\[" => ()
    _ => fail("Should match literal left bracket")
  }
  lexmatch "]" {
    "\]" => ()
    _ => fail("Should match literal right bracket")
  }
  lexmatch "(" {
    "\(" => ()
    _ => fail("Should match literal left paren")
  }
  lexmatch ")" {
    "\)" => ()
    _ => fail("Should match literal right paren")
  }
  lexmatch "{" {
    "[{]" => ()
    _ => fail("Should match literal left brace")
  }
  lexmatch "}" {
    "[}]" => ()
    _ => fail("Should match literal right brace")
  }
  lexmatch "|" {
    "\|" => ()
    _ => fail("Should match literal pipe")
  }
  lexmatch "^" {
    "\^" => ()
    _ => fail("Should match literal caret")
  }
  lexmatch "$" {
    "\$" => ()
    _ => fail("Should match literal dollar")
  }
}

///|
test "* quantifier - zero or more" {
  lexmatch "" {
    "a*" => ()
    _ => fail("Should match zero occurrences")
  }
  lexmatch "a" {
    "a*" => ()
    _ => fail("Should match one occurrence")
  }
  lexmatch "aaa" {
    "a*" => ()
    _ => fail("Should match multiple occurrences")
  }
}

///|
test "+ quantifier - one or more" {
  lexmatch "" {
    "a+" => fail("Should not match zero occurrences")
    _ => ()
  }
  lexmatch "a" {
    "a+" => ()
    _ => fail("Should match one occurrence")
  }
  lexmatch "aaaa" {
    "a+" => ()
    _ => fail("Should match multiple occurrences")
  }
}

///|
test "? quantifier - zero or one" {
  lexmatch "" {
    "a?" => ()
    _ => fail("Should match zero occurrences")
  }
  lexmatch "a" {
    "a?" => ()
    _ => fail("Should match one occurrence")
  }
}

///|
test "{n} quantifier - exactly n times" {
  lexmatch "aa" {
    "a{2}" => ()
    _ => fail("Should match exactly 2 occurrences")
  }
  lexmatch "a" {
    "a{2}" => fail("Should not match 1 occurrence")
    _ => ()
  }
  lexmatch "aaa" {
    "a{2}" => fail("Should not match 3 occurrences")
    _ => ()
  }
}

///|
test "{n,} quantifier - at least n times" {
  lexmatch "aa" {
    "a{2,}" => ()
    _ => fail("Should match exactly 2 occurrences")
  }
  lexmatch "aaaa" {
    "a{2,}" => ()
    _ => fail("Should match 4 occurrences")
  }
  lexmatch "a" {
    "a{2,}" => fail("Should not match 1 occurrence")
    _ => ()
  }
}

///|
test "{n,m} quantifier - between n and m times" {
  lexmatch "aa" {
    "a{2,4}" => ()
    _ => fail("Should match 2 occurrences")
  }
  lexmatch "aaa" {
    "a{2,4}" => ()
    _ => fail("Should match 3 occurrences")
  }
  lexmatch "aaaa" {
    "a{2,4}" => ()
    _ => fail("Should match 4 occurrences")
  }
  lexmatch "a" {
    "a{2,4}" => fail("Should not match 1 occurrence")
    _ => ()
  }
  lexmatch "aaaaa" {
    "a{2,4}" => fail("Should not match 5 occurrences")
    _ => ()
  }
}

///|
test ". metacharacter - any single character" {
  lexmatch "a" {
    "." => ()
    _ => fail("Should match letter")
  }
  lexmatch "5" {
    "." => ()
    _ => fail("Should match digit")
  }
  lexmatch " " {
    "." => ()
    _ => fail("Should match space")
  }
  lexmatch "\n" {
    "." => ()
    _ => fail("Should match newline")
  }
}

///|
test "$ anchor - end of string" {
  lexmatch "abc" {
    "abc$" => ()
    _ => fail("Should match end of string")
  }
  lexmatch "abc\n" {
    "abc$" => fail("Should not match when followed by newline")
    _ => ()
  }
}

///|
test "(?i:...) - case insensitive modifier" {
  lexmatch "abc" {
    "(?i:ABC)" => ()
    _ => fail("Should match case insensitively")
  }
  lexmatch "ABC" {
    "(?i:abc)" => ()
    _ => fail("Should match case insensitively")
  }
  lexmatch "AbC" {
    "(?i:aBc)" => ()
    _ => fail("Should match case insensitively")
  }
}

///|
test "Capture with 'as' keyword" {
  lexmatch "hello" {
    ("hello" as captured) =>
      if captured.to_string() == "hello" {
        ()
      } else {
        fail("Captured value should be 'hello'")
      }
    _ => fail("Should match and capture")
  }
}

///|
test "Capture single character returns Char" {
  lexmatch "+" {
    ("[+\-]" as sign) =>
      // sign should be a Char type when matching single character
      if sign == '+' {
        ()
      } else {
        fail("Should capture + character")
      }
    _ => fail("Should match sign character")
  }
}

///|
test "Sequence pattern" {
  lexmatch "//" {
    ("//" ".*") => ()
    _ => fail("Should match sequence")
  }
  lexmatch "//comment" {
    ("//" ".*") => ()
    _ => fail("Should match comment pattern")
  }
}

///|
test "Pattern with rest variable" {
  lexmatch "hello world" {
    ("hello" as word, rest) =>
      if word.to_string() == "hello" && rest.to_string() == " world" {
        ()
      } else {
        fail("Should capture word and rest correctly")
      }
    _ => fail("Should match pattern with rest")
  }
}

///|
test "Pattern with rest using longest strategy" {
  lexmatch "abc123def" with longest {
    ("[a-z]+", rest) =>
      if rest.to_string() == "123def" {
        ()
      } else {
        fail("Should match longest letters prefix")
      }
    _ => fail("Should match with longest strategy")
  }
}

///|
test "Character set combinations - [[:digit:][:space:]]" {
  lexmatch "5" {
    "[[:digit:][:space:]]" => ()
    _ => fail("Should match digit")
  }
  lexmatch " " {
    "[[:digit:][:space:]]" => ()
    _ => fail("Should match space")
  }
  lexmatch "\t" {
    "[[:digit:][:space:]]" => ()
    _ => fail("Should match tab")
  }
  lexmatch "a" {
    "[[:digit:][:space:]]" => fail("Should not match letter")
    _ => ()
  }
}

///|
test "Complex pattern - identifier matching" {
  lexmatch "var123" {
    "[a-zA-Z_][[:word:]]*" => ()
    _ => fail("Should match identifier")
  }
  lexmatch "_test" {
    "[a-zA-Z_][[:word:]]*" => ()
    _ => fail("Should match identifier starting with underscore")
  }
  lexmatch "123abc" {
    "[a-zA-Z_][[:word:]]*" =>
      fail("Should not match identifier starting with digit")
    _ => ()
  }
}

///|
test "Multiple captures in sequence" {
  lexmatch "123abc" {
    (("[[:digit:]]+" as num) ("[a-z]+" as word)) =>
      if num.to_string() == "123" && word.to_string() == "abc" {
        ()
      } else {
        fail("Should capture both number and word")
      }
    _ => fail("Should match pattern")
  }
}

///|
test "Empty string matching" {
  lexmatch "" {
    "" => ()
    _ => fail("Should match empty string")
  }
}

///|
test "Wildcard pattern in lexmatch" {
  lexmatch "anything" {
    "specific" => fail("Should not match specific pattern")
    _ => ()
  }
}
