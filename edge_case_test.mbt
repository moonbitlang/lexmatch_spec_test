// Edge case tests - testing boundary conditions, special characters, empty strings

///|
test "Edge - empty string match" {
  let text = ""
  if text lexmatch? "" with longest {
    ()
  } else {
    fail("Should match empty string")
  }
}

///|
test "Edge - empty pattern alternation" {
  let text = "hello"
  lexmatch text with longest {
    rest => if rest == "hello" { () } else { fail("Rest should capture all") }
  }
}

///|
test "Edge - single character" {
  let text = "a"
  if text lexmatch? "[[:word:]]" with longest {
    ()
  } else {
    fail("Should match single char")
  }
}

///|
test "Edge - only whitespace" {
  let text = "   "
  if text lexmatch? "[[:space:]]+" with longest {
    ()
  } else {
    fail("Should match whitespace")
  }
}

///|
test "Edge - newline character" {
  let text = "\n"
  if text lexmatch? "\n" with longest {
    ()
  } else {
    fail("Should match newline")
  }
}

///|
test "Edge - tab character" {
  let text = "\t"
  if text lexmatch? "\t" with longest {
    ()
  } else {
    fail("Should match tab")
  }
}

///|
test "Edge - carriage return" {
  let text = "\r"
  if text lexmatch? "\r" with longest {
    ()
  } else {
    fail("Should match carriage return")
  }
}

///|
test "Edge - backslash literal" {
  let text = "\\\\"
  if text lexmatch? "\\\\" with longest {
    ()
  } else {
    fail("Should match backslash")
  }
}

///|
test "Edge - quote in string" {
  let text = "\""
  if text lexmatch? "\"" with longest {
    ()
  } else {
    fail("Should match quote")
  }
}

///|
test "Edge - dollar sign" {
  let text = "$"
  if text lexmatch? "\$" with longest {
    ()
  } else {
    fail("Should match dollar sign")
  }
}

///|
test "Edge - dot matches any character" {
  let text = "x"
  if text lexmatch? "." with longest {
    ()
  } else {
    fail("Dot should match any char")
  }
}

///|
test "Edge - asterisk quantifier zero times" {
  let text = ""
  if text lexmatch? "a*" with longest {
    ()
  } else {
    fail("Should match zero occurrences")
  }
}

///|
test "Edge - plus quantifier requires one" {
  let text = ""
  if not(text lexmatch? "a+" with longest) {
    ()
  } else {
    fail("Plus should not match empty")
  }
}

///|
test "Edge - question mark zero times" {
  let text = ""
  if text lexmatch? "a?" with longest {
    ()
  } else {
    fail("Should match zero with ?")
  }
}

///|
test "Edge - exact quantifier zero" {
  let text = ""
  if text lexmatch? "a{0}" with longest {
    ()
  } else {
    fail("Should match zero times")
  }
}

///|
test "Edge - range quantifier min is max" {
  let text = "aaa"
  if text lexmatch? "a{3,3}" with longest {
    ()
  } else {
    fail("Should match exactly 3")
  }
}

///|
test "Edge - character class with single char" {
  let text = "a"
  if text lexmatch? "[a]" with longest {
    ()
  } else {
    fail("Should match single char class")
  }
}

///|
test "Edge - negated character class" {
  let text = "b"
  if text lexmatch? "[^a]" with longest {
    ()
  } else {
    fail("Should match negated class")
  }
}

///|
test "Edge - empty character class range" {
  let text = "5"
  if text lexmatch? "[0-9]" with longest {
    ()
  } else {
    fail("Should match digit range")
  }
}

///|
test "Edge - special chars in character class" {
  let text = "-"
  if text lexmatch? "[\-]" with longest {
    ()
  } else {
    fail("Should match hyphen")
  }
}

///|
test "Edge - capture empty string" {
  let text = ""
  lexmatch text with longest {
    ("" as captured) =>
      if captured == "" {
        ()
      } else {
        fail("Should capture empty")
      }
    _ => fail("Should match")
  }
}

///|
test "Edge - rest variable with complete match" {
  let text = "hello"
  lexmatch text with longest {
    ("hello", rest) =>
      if rest == "" {
        ()
      } else {
        fail("Rest should be empty")
      }
    _ => fail("Should match")
  }
}

///|
test "Edge - rest variable only" {
  let text = "hello"
  lexmatch text with longest {
    rest => if rest == "hello" { () } else { fail("Rest should capture all") }
  }
}

///|
test "Edge - very long string" {
  let text = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
  if text lexmatch? "a{64}" with longest {
    ()
  } else {
    fail("Should match long string")
  }
}

///|
test "Edge - Unicode character" {
  let text = "你好"
  if text lexmatch? ".*" with longest {
    ()
  } else {
    fail("Should match Unicode")
  }
}

///|
test "Edge - mixed ASCII and Unicode" {
  let text = "hello世界"
  if text lexmatch? (".*" as all) with longest {
    if all == "hello世界" {
      ()
    } else {
      fail("Should match mixed text")
    }
  } else {
    fail("Should match")
  }
}

///|
test "Edge - number at boundary" {
  let text = "0"
  if text lexmatch? "[[:digit:]]" with longest {
    ()
  } else {
    fail("Should match zero")
  }
}

///|
test "Edge - number nine" {
  let text = "9"
  if text lexmatch? "[[:digit:]]" with longest {
    ()
  } else {
    fail("Should match nine")
  }
}

///|
test "Edge - lowercase a" {
  let text = "a"
  if text lexmatch? "[a-z]" with longest {
    ()
  } else {
    fail("Should match lowercase a")
  }
}

///|
test "Edge - lowercase z" {
  let text = "z"
  if text lexmatch? "[a-z]" with longest {
    ()
  } else {
    fail("Should match lowercase z")
  }
}

///|
test "Edge - uppercase A" {
  let text = "A"
  if text lexmatch? "[A-Z]" with longest {
    ()
  } else {
    fail("Should match uppercase A")
  }
}

///|
test "Edge - uppercase Z" {
  let text = "Z"
  if text lexmatch? "[A-Z]" with longest {
    ()
  } else {
    fail("Should match uppercase Z")
  }
}

///|
test "Edge - underscore in word class" {
  let text = "_"
  if text lexmatch? "[[:word:]]" with longest {
    ()
  } else {
    fail("Should match underscore")
  }
}

///|
test "Edge - space is not word char" {
  let text = " "
  if not(text lexmatch? "[[:word:]]" with longest) {
    ()
  } else {
    fail("Space should not match [[:word:]]")
  }
}

///|
test "Edge - newline is whitespace" {
  let text = "\n"
  if text lexmatch? "[[:space:]]" with longest {
    ()
  } else {
    fail("Newline should match [[:space:]]")
  }
}

///|
test "Edge - letter is not whitespace" {
  let text = "a"
  if not(text lexmatch? "[[:space:]]" with longest) {
    ()
  } else {
    fail("Letter should not match [[:space:]]")
  }
}

///|
test "Edge - letter is not digit" {
  let text = "a"
  if not(text lexmatch? "[[:digit:]]" with longest) {
    ()
  } else {
    fail("Letter should not match [[:digit:]]")
  }
}

///|
test "Edge - case sensitive by default" {
  let text = "HELLO"
  if not(text lexmatch? "hello" with longest) {
    ()
  } else {
    fail("Should be case sensitive")
  }
}

///|
test "Edge - case insensitive with modifier" {
  let text = "HELLO"
  if text lexmatch? "(?i:hello)" with longest {
    ()
  } else {
    fail("Should match case insensitively")
  }
}

///|
test "Edge - BytesView empty" {
  let bytes = b""
  if bytes lexmatch? "" with longest {
    ()
  } else {
    fail("Should match empty BytesView")
  }
}

///|
test "Edge - BytesView single byte" {
  let bytes = b"a"
  if bytes lexmatch? "a" with longest {
    ()
  } else {
    fail("Should match single byte")
  }
}

///|
test "Edge - sequence with empty components" {
  let text = ""
  if text lexmatch? ("" "") with longest {
    ()
  } else {
    fail("Should match empty sequence")
  }
}
