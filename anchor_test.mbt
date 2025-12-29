// Anchor tests - testing ^ (start of input) and $ (end of string) anchors

///|
test "^ anchor matches start of string" {
  lexmatch "hello world" with longest {
    ("^hello" as word, rest) =>
      if word.to_string() == "hello" && rest.to_string() == " world" {
        ()
      } else {
        fail("Should capture 'hello' and ' world'")
      }
    _ => fail("Should match at start")
  }
}

///|
test "^ anchor does not match when not at start" {
  lexmatch "hello world" with longest {
    ("^world", _) => fail("Should not match 'world' with ^ anchor")
    _ => ()
  }
}

///|
test "^ anchor with empty string" {
  lexmatch "" {
    "^$" => ()
    _ => fail("Should match empty string with ^$")
  }
}

///|
test "^ anchor with pattern sequence" {
  lexmatch "123abc" with longest {
    (("^[[:digit:]]+" as nums) ("[[:word:]]+" as letters), rest) =>
      if nums.to_string() == "123" &&
        letters.to_string() == "abc" &&
        rest.to_string() == "" {
        ()
      } else {
        fail("Should capture nums and letters")
      }
    _ => fail("Should match pattern sequence")
  }
}

///|
test "^ anchor with character class" {
  lexmatch "Hello World" with longest {
    ("^[A-Z]+" as first, rest) =>
      if first.to_string() == "H" && rest.to_string() == "ello World" {
        ()
      } else {
        fail("Should capture first uppercase letter")
      }
    _ => fail("Should match")
  }
}

///|
test "^ anchor with quantifier" {
  lexmatch "000123" with longest {
    ("^0+" as zeros, rest) =>
      if zeros.to_string() == "000" && rest.to_string() == "123" {
        ()
      } else {
        fail("Should capture leading zeros")
      }
    _ => fail("Should match")
  }
}

///|
test "^ anchor with digit pattern" {
  lexmatch "42answer" with longest {
    ("^[[:digit:]]+" as num, rest) =>
      if num.to_string() == "42" && rest.to_string() == "answer" {
        ()
      } else {
        fail("Should capture number at start")
      }
    _ => fail("Should match")
  }
}

///|
test "^ anchor with word pattern" {
  lexmatch "hello123" with longest {
    ("^[a-z]+" as word, rest) =>
      if word.to_string() == "hello" && rest.to_string() == "123" {
        ()
      } else {
        fail("Should capture word at start")
      }
    _ => fail("Should match")
  }
}

///|
test "^ anchor does not match after prefix consumption" {
  lexmatch "abc123" with longest {
    ("." "^[[:digit:]]+", _) =>
      fail("^ should not match after consuming a character")
    ("^[[:word:]]+" as all, rest) =>
      if all.to_string() == "abc123" && rest.to_string() == "" {
        ()
      } else {
        fail("Should match entire word from start")
      }
    _ => fail("Should match something")
  }
}

///|
test "^ anchor with URL protocol" {
  lexmatch "http://example.com" with longest {
    (("^[a-z]+" as protocol) "://", rest) =>
      if protocol.to_string() == "http" && rest.to_string() == "example.com" {
        ()
      } else {
        fail("Should capture protocol")
      }
    _ => fail("Should match")
  }
  lexmatch "https://example.com" with longest {
    (("^[a-z]+" as protocol) "://", rest) =>
      if protocol.to_string() == "https" && rest.to_string() == "example.com" {
        ()
      } else {
        fail("Should capture https protocol")
      }
    _ => fail("Should match")
  }
}

///|
test "^ anchor with case insensitive modifier" {
  lexmatch "Hello World" with longest {
    ("^(?i:hello)" as word, rest) =>
      if word.to_string() == "Hello" && rest.to_string() == " World" {
        ()
      } else {
        fail("Should match case-insensitively at start")
      }
    _ => fail("Should match")
  }
}

///|
test "^ anchor with optional pattern" {
  lexmatch "123" with longest {
    ("^[+\-]?" ("[[:digit:]]+" as num), rest) =>
      if num.to_string() == "123" && rest.to_string() == "" {
        ()
      } else {
        fail("Should match unsigned number")
      }
    _ => fail("Should match")
  }
  lexmatch "+456" with longest {
    ("^[+\-]" ("[[:digit:]]+" as num), rest) =>
      if num.to_string() == "456" && rest.to_string() == "" {
        ()
      } else {
        fail("Should match signed number")
      }
    _ => fail("Should match")
  }
}

///|
test "^ anchor with exact repetition" {
  lexmatch "000123" with longest {
    ("^0{3}" as zeros, rest) =>
      if zeros.to_string() == "000" && rest.to_string() == "123" {
        ()
      } else {
        fail("Should match exactly 3 zeros")
      }
    _ => fail("Should match")
  }
}

///|
test "^ anchor with range repetition" {
  lexmatch "aaabbb" with longest {
    ("^a{2,4}" as aaa, rest) =>
      if aaa.to_string() == "aaa" && rest.to_string() == "bbb" {
        ()
      } else {
        fail("Should match 2-4 a's")
      }
    _ => fail("Should match")
  }
}

///|
test "^ anchor matches at string view start" {
  lexmatch "prefix:suffix" with longest {
    (("^[^:]+" as prefix) ":", rest) =>
      if prefix.to_string() == "prefix" && rest.to_string() == "suffix" {
        ()
      } else {
        fail("Should match prefix before colon")
      }
    _ => fail("Should match")
  }
}

///|
test "^ anchor with whitespace pattern" {
  lexmatch "   text" with longest {
    ("^[[:space:]]+" as spaces, rest) =>
      if spaces.to_string() == "   " && rest.to_string() == "text" {
        ()
      } else {
        fail("Should match leading spaces")
      }
    _ => fail("Should match")
  }
}

///|
test "^ anchor with negated character class" {
  lexmatch "abc123" with longest {
    ("^[^[:digit:]]+" as letters, rest) =>
      if letters.to_string() == "abc" && rest.to_string() == "123" {
        ()
      } else {
        fail("Should match non-digits at start")
      }
    _ => fail("Should match")
  }
}

///|
test "^ anchor combined with $ anchor" {
  lexmatch "exactly" {
    "^exactly$" => ()
    _ => fail("Should match entire string with ^...$")
  }
  lexmatch "exactly " {
    "^exactly$" => fail("Should not match with trailing space")
    _ => ()
  }
}

///|
test "^ anchor in lexmatch? expression" {
  if "start here" lexmatch? ("^start" as word, _) with longest {
    if word.to_string() == "start" {
      ()
    } else {
      fail("Should capture 'start'")
    }
  } else {
    fail("Should match at start")
  }
}

///|
test "^ anchor in lexmatch? returns false when not at start" {
  if "not start" lexmatch? ("^start", _) with longest {
    fail("Should not match when pattern is not at start")
  } else {
    ()
  }
}
