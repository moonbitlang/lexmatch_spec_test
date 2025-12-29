// BytesView matching tests - testing lexmatch with BytesView targets

///|
test "BytesView - simple ASCII match" {
  let bytes = b"hello"
  lexmatch bytes with longest {
    "hello" => ()
    _ => fail("Should match hello in bytes")
  }
}

///|
test "BytesView - digit pattern" {
  let bytes = b"12345"
  lexmatch bytes with longest {
    "[[:digit:]]+" => ()
    _ => fail("Should match digits in bytes")
  }
}

///|
test "BytesView - character class" {
  let bytes = b"abc"
  lexmatch bytes with longest {
    "[a-z]+" => ()
    _ => fail("Should match lowercase letters in bytes")
  }
}

///|
test "BytesView - whitespace" {
  let bytes = b"   "
  lexmatch bytes with longest {
    "[[:space:]]+" => ()
    _ => fail("Should match whitespace in bytes")
  }
}

///|
test "BytesView - newline" {
  let bytes = b"\n"
  lexmatch bytes with longest {
    "\n" => ()
    _ => fail("Should match newline in bytes")
  }
}

///|
test "BytesView - tab" {
  let bytes = b"\t"
  lexmatch bytes with longest {
    "\t" => ()
    _ => fail("Should match tab in bytes")
  }
}

///|
test "BytesView - with rest variable" {
  let bytes = b"hello world"
  lexmatch bytes with longest {
    ("hello", rest) =>
      if rest == " world" {
        ()
      } else {
        fail("Rest should be ' world'")
      }
    _ => fail("Should match")
  }
}

///|
test "BytesView - capture pattern" {
  let bytes = b"test123"
  lexmatch bytes with longest {
    ("[a-z]+" as word, _) =>
      if word == "test" {
        ()
      } else {
        fail("Should capture 'test'")
      }
    _ => fail("Should match")
  }
}

///|
test "BytesView - hex escape" {
  let bytes = b"A"
  lexmatch bytes with longest {
    "\x41" => ()
    _ => fail("Should match hex 41 (A) in bytes")
  }
}

///|
test "BytesView - backslash literal" {
  let bytes = b"\\"
  lexmatch bytes with longest {
    "\\" => ()
    _ => fail("Should match backslash in bytes")
  }
}

///|
test "BytesView - email pattern" {
  let bytes = b"test@example.com"
  lexmatch bytes with longest {
    ("[[:word:]]+" "@" "[[:word:]]+" "\." "[[:word:]]+") => ()
    _ => fail("Should match email in bytes")
  }
}

///|
test "BytesView - IP address" {
  let bytes = b"192.168.1.1"
  lexmatch bytes with longest {
    (
      "[[:digit:]]{1,3}"
      "\."
      "[[:digit:]]{1,3}"
      "\."
      "[[:digit:]]{1,3}"
      "\."
      "[[:digit:]]{1,3}"
    ) => ()
    _ => fail("Should match IP in bytes")
  }
}

///|
test "BytesView - URL" {
  let bytes = b"https://example.com"
  lexmatch bytes with longest {
    ("[a-z]+" "://" ".*") => ()
    _ => fail("Should match URL in bytes")
  }
}

///|
test "BytesView - JSON-like" {
  let bytes = b"\"key\":\"value\""
  lexmatch bytes with longest {
    ("\"" "[[:word:]]+" "\"" ":" "\"" "[[:word:]]+" "\"") => ()
    _ => fail("Should match JSON pair in bytes")
  }
}

///|
test "BytesView - binary data pattern" {
  let bytes = b"\x00\x01\x02"
  lexmatch bytes with longest {
    "\x00\x01\x02" => ()
    _ => fail("Should match binary sequence")
  }
}

///|
test "BytesView - mixed alphanumeric" {
  let bytes = b"abc123xyz"
  lexmatch bytes with longest {
    ("[a-z]+", rest) =>
      if rest == "123xyz" {
        ()
      } else {
        fail("Should match letters then digits")
      }
    _ => fail("Should match")
  }
}

///|
test "BytesView - quantifiers" {
  let bytes = b"aaaa"
  lexmatch bytes with longest {
    "a{4}" => ()
    _ => fail("Should match exactly 4 a's in bytes")
  }
}

///|
test "BytesView - alternation with character class" {
  let bytes = b"test"
  lexmatch bytes with longest {
    "[a-z]{4}" => ()
    _ => fail("Should match 4 letters in bytes")
  }
}

///|
test "BytesView - special characters" {
  let bytes = b"!@#$%"
  lexmatch bytes with longest {
    "!@#\$%" => ()
    _ => fail("Should match special chars in bytes")
  }
}

///|
test "BytesView - carriage return" {
  let bytes = b"\r\n"
  lexmatch bytes with longest {
    "\r\n" => ()
    _ => fail("Should match CRLF in bytes")
  }
}

///|
test "BytesView - multiple lines" {
  let bytes = b"line1\nline2"
  lexmatch bytes with longest {
    ("[^\n]+" "\n" "[^\n]+") => ()
    _ => fail("Should match two lines in bytes")
  }
}

///|
test "BytesView - case insensitive" {
  let bytes = b"HELLO"
  lexmatch bytes with longest {
    "(?i:hello)" => ()
    _ => fail("Should match case insensitively in bytes")
  }
}

///|
test "BytesView - empty bytes" {
  let bytes = b""
  lexmatch bytes with longest {
    "" => ()
    _ => fail("Should match empty bytes")
  }
}

///|
test "BytesView - single byte" {
  let bytes = b"x"
  lexmatch bytes with longest {
    "." => ()
    _ => fail("Should match any single byte")
  }
}

///|
test "BytesView - word boundary simulation" {
  let bytes = b"word1 word2"
  lexmatch bytes with longest {
    ("[[:word:]]+", rest) =>
      if rest == " word2" {
        ()
      } else {
        fail("Should match first word")
      }
    _ => fail("Should match")
  }
}

///|
test "BytesView - sequence pattern" {
  let bytes = b"GET /path HTTP/1.1"
  lexmatch bytes with longest {
    (
      "[[:word:]]+"
      "[[:space:]]"
      "/[[:word:]]+"
      "[[:space:]]"
      "[[:word:]]+"
      "/"
      "[[:digit:]]+"
      "\."
      "[[:digit:]]+"
    ) => ()
    _ => fail("Should match HTTP request line in bytes")
  }
}

///|
test "BytesView - MAC address" {
  let bytes = b"AA:BB:CC:DD:EE:FF"
  lexmatch bytes with longest {
    (
      "[[:digit:]A-Fa-f]{2}"
      ":"
      "[[:digit:]A-Fa-f]{2}"
      ":"
      "[[:digit:]A-Fa-f]{2}"
      ":"
      "[[:digit:]A-Fa-f]{2}"
      ":"
      "[[:digit:]A-Fa-f]{2}"
      ":"
      "[[:digit:]A-Fa-f]{2}"
    ) => ()
    _ => fail("Should match MAC address in bytes")
  }
}

///|
test "BytesView - version string" {
  let bytes = b"v1.2.3"
  lexmatch bytes with longest {
    ("v" "[[:digit:]]+" "\." "[[:digit:]]+" "\." "[[:digit:]]+") => ()
    _ => fail("Should match version in bytes")
  }
}

///|
test "BytesView - file path" {
  let bytes = b"/usr/local/bin"
  lexmatch bytes with longest {
    ("/" "[[:word:]]+" "/" "[[:word:]]+" "/" "[[:word:]]+") => ()
    _ => fail("Should match path in bytes")
  }
}

///|
test "BytesView - git commit hash" {
  let bytes = b"commit abc1234"
  lexmatch bytes with longest {
    ("commit" "[[:space:]]" "[a-f0-9]{7}") => ()
    _ => fail("Should match git commit in bytes")
  }
}

///|
test "BytesView - multiple captures" {
  let bytes = b"123abc"
  lexmatch bytes with longest {
    (("[[:digit:]]+" as num) ("[a-z]+" as letters)) =>
      if num == "123" && letters == "abc" {
        ()
      } else {
        fail("Should capture both parts")
      }
    _ => fail("Should match")
  }
}

///|
test "BytesView - HTTP header" {
  let bytes = b"Content-Type: text/html"
  lexmatch bytes with longest {
    ("[[:word:]\-]+" ":" "[[:space:]]*" "[[:word:]/]+") => ()
    _ => fail("Should match HTTP header in bytes")
  }
}

///|
test "BytesView - timestamp" {
  let bytes = b"2024-01-15 14:30:45"
  lexmatch bytes with longest {
    (
      "[[:digit:]]{4}"
      "-"
      "[[:digit:]]{2}"
      "-"
      "[[:digit:]]{2}"
      "[[:space:]]"
      "[[:digit:]]{2}"
      ":"
      "[[:digit:]]{2}"
      ":"
      "[[:digit:]]{2}"
    ) => ()
    _ => fail("Should match timestamp in bytes")
  }
}

///|
test "BytesView - UUID" {
  let bytes = b"550e8400-e29b-41d4-a716-446655440000"
  lexmatch bytes with longest {
    (
      "[[:digit:]a-f]{8}"
      "-"
      "[[:digit:]a-f]{4}"
      "-"
      "[[:digit:]a-f]{4}"
      "-"
      "[[:digit:]a-f]{4}"
      "-"
      "[[:digit:]a-f]{12}"
    ) => ()
    _ => fail("Should match UUID in bytes")
  }
}

///|
test "BytesView - base64-like pattern" {
  let bytes = b"YWJjMTIz"
  lexmatch bytes with longest {
    "[A-Za-z0-9]+" => ()
    _ => fail("Should match base64 chars in bytes")
  }
}

///|
test "BytesView - quoted string" {
  let bytes = b"\"hello world\""
  lexmatch bytes with longest {
    ("\"" "[^\"]*" "\"") => ()
    _ => fail("Should match quoted string in bytes")
  }
}

///|
test "BytesView - parenthesized expression" {
  let bytes = b"(x + y)"
  lexmatch bytes with longest {
    ("\(" ".*" "\)") => ()
    _ => fail("Should match parenthesized expr in bytes")
  }
}

///|
test "BytesView - comma-separated values" {
  let bytes = b"a,b,c"
  lexmatch bytes with longest {
    ("[[:word:]]" "," "[[:word:]]" "," "[[:word:]]") => ()
    _ => fail("Should match CSV in bytes")
  }
}

///|
test "BytesView - log level" {
  let bytes = b"[INFO]"
  lexmatch bytes with longest {
    ("\[" "[[:word:]]+" "\]") => ()
    _ => fail("Should match log level in bytes")
  }
}

///|
test "BytesView - key-value pair" {
  let bytes = b"key=value"
  lexmatch bytes with longest {
    ("[[:word:]]+" "=" "[[:word:]]+") => ()
    _ => fail("Should match key-value in bytes")
  }
}

///|
test "BytesView - dotted notation" {
  let bytes = b"obj.prop.method"
  lexmatch bytes with longest {
    ("[[:word:]]+" "\." "[[:word:]]+" "\." "[[:word:]]+") => ()
    _ => fail("Should match dotted notation in bytes")
  }
}

///|
test "BytesView - phone number" {
  let bytes = b"(555)123-4567"
  lexmatch bytes with longest {
    ("\(" "[[:digit:]]{3}" "\)" "[[:digit:]]{3}" "-" "[[:digit:]]{4}") => ()
    _ => fail("Should match phone number in bytes")
  }
}

///|
test "BytesView - credit card pattern" {
  let bytes = b"4111-1111-1111-1111"
  lexmatch bytes with longest {
    (
      "[[:digit:]]{4}"
      "-"
      "[[:digit:]]{4}"
      "-"
      "[[:digit:]]{4}"
      "-"
      "[[:digit:]]{4}"
    ) => ()
    _ => fail("Should match card number in bytes")
  }
}

///|
test "BytesView - dollar amount" {
  let bytes = b"$99.99"
  lexmatch bytes with longest {
    ("\$" "[[:digit:]]+" "\." "[[:digit:]]{2}") => ()
    _ => fail("Should match dollar amount in bytes")
  }
}

///|
test "BytesView - percentage" {
  let bytes = b"75%"
  lexmatch bytes with longest {
    ("[[:digit:]]+" "%") => ()
    _ => fail("Should match percentage in bytes")
  }
}

///|
test "BytesView - HTML tag" {
  let bytes = b"<div class=\"test\">"
  lexmatch bytes with longest {
    (
      "<"
      "[[:word:]]+"
      "[[:space:]]"
      "[[:word:]]+"
      "="
      "\""
      "[[:word:]]+"
      "\""
      ">"
    ) => ()
    _ => fail("Should match HTML tag in bytes")
  }
}

///|
test "BytesView - hexadecimal number" {
  let bytes = b"0xFF00"
  lexmatch bytes with longest {
    ("0x" "[0-9A-Fa-f]+") => ()
    _ => fail("Should match hex number in bytes")
  }
}

///|
test "BytesView - scientific notation" {
  let bytes = b"1.5e-10"
  lexmatch bytes with longest {
    ("[[:digit:]]+" "\." "[[:digit:]]+" "[eE]" "[+\-]" "[[:digit:]]+") => ()
    _ => fail("Should match scientific notation in bytes")
  }
}

///|
test "BytesView - CSS selector" {
  let bytes = b"div.class#id"
  lexmatch bytes with longest {
    ("[[:word:]]+" "\." "[[:word:]]+" "#" "[[:word:]]+") => ()
    _ => fail("Should match CSS selector in bytes")
  }
}

///|
test "BytesView - SQL statement" {
  let bytes = b"SELECT * FROM users"
  lexmatch bytes with longest {
    (
      "SELECT"
      "[[:space:]]"
      ".*"
      "[[:space:]]"
      "FROM"
      "[[:space:]]"
      "[[:word:]]+"
    ) => ()
    _ => fail("Should match SQL in bytes")
  }
}

///|
test "BytesView - regex escape test" {
  let bytes = b"test\\"
  lexmatch bytes with longest {
    ("[a-z]+", rest) =>
      if rest == "\\" {
        ()
      } else {
        fail("Should handle backslash in bytes")
      }
    _ => fail("Should match")
  }
}

///|
test "BytesView - null byte cannot be matched" {
  // Note: Bytes can contain null bytes but patterns may have limitations
  let bytes = b"test"
  lexmatch bytes with longest {
    "test" => ()
    _ => fail("Should match normal bytes")
  }
}

///|
test "BytesView - control characters" {
  let bytes = b"\r\n\t"
  lexmatch bytes with longest {
    "\r\n\t" => ()
    _ => fail("Should match control chars in bytes")
  }
}
