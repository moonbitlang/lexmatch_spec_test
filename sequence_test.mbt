// Sequence pattern tests - testing space-separated regex sequences

///|
test "Two literal sequences" {
  lexmatch "ab" {
    ("a" "b") => ()
    _ => fail("Should match ab sequence")
  }
}

///|
test "Three literal sequences" {
  lexmatch "abc" {
    ("a" "b" "c") => ()
    _ => fail("Should match abc sequence")
  }
}

///|
test "Digit followed by letter" {
  lexmatch "5a" {
    ("[[:digit:]]" "[a-z]") => ()
    _ => fail("Should match digit-letter sequence")
  }
}

///|
test "Letter followed by digit" {
  lexmatch "a5" {
    ("[a-z]" "[[:digit:]]") => ()
    _ => fail("Should match letter-digit sequence")
  }
}

///|
test "Protocol URL sequence" {
  lexmatch "http://example.com" {
    ("http" "://" ".*") => ()
    _ => fail("Should match URL pattern")
  }
}

///|
test "Comment sequence" {
  lexmatch "//comment" {
    ("//" ".*") => ()
    _ => fail("Should match comment")
  }
}

///|
test "Variable assignment sequence" {
  lexmatch "x=5" {
    ("[[:word:]]" "=" "[[:digit:]]") => ()
    _ => fail("Should match assignment")
  }
}

///|
test "Email basic sequence" {
  lexmatch "a@b.c" {
    ("[[:word:]]" "@" "[[:word:]]" "\." "[[:word:]]") => ()
    _ => fail("Should match simple email")
  }
}

///|
test "Phone number sequence" {
  lexmatch "(123)456-7890" {
    ("\(" "[[:digit:]]{3}" "\)" "[[:digit:]]{3}" "-" "[[:digit:]]{4}") => ()
    _ => fail("Should match phone number")
  }
}

///|
test "Date sequence YYYY-MM-DD" {
  lexmatch "2024-01-15" {
    ("[[:digit:]]{4}" "-" "[[:digit:]]{2}" "-" "[[:digit:]]{2}") => ()
    _ => fail("Should match date")
  }
}

///|
test "Time sequence HH:MM:SS" {
  lexmatch "14:30:45" {
    ("[[:digit:]]{2}" ":" "[[:digit:]]{2}" ":" "[[:digit:]]{2}") => ()
    _ => fail("Should match time")
  }
}

///|
test "IP address sequence" {
  lexmatch "192.168.1.1" {
    (
      "[[:digit:]]{1,3}"
      "\."
      "[[:digit:]]{1,3}"
      "\."
      "[[:digit:]]{1,3}"
      "\."
      "[[:digit:]]{1,3}"
    ) => ()
    _ => fail("Should match IP")
  }
}

///|
test "Version number sequence" {
  lexmatch "1.2.3" {
    ("[[:digit:]]+" "\." "[[:digit:]]+" "\." "[[:digit:]]+") => ()
    _ => fail("Should match version")
  }
}

///|
test "Hex color sequence" {
  lexmatch "#FF00AA" {
    ("#" "[0-9A-Fa-f]{6}") => ()
    _ => fail("Should match hex color")
  }
}

///|
test "Quoted string sequence" {
  lexmatch "\"hello\"" {
    ("\"" "[^\"]*" "\"") => ()
    _ => fail("Should match quoted string")
  }
}

///|
test "Array access sequence" {
  lexmatch "arr[0]" {
    ("[[:word:]]+" "\[" "[[:digit:]]+" "\]") => ()
    _ => fail("Should match array access")
  }
}

///|
test "Function call sequence" {
  lexmatch "func()" {
    ("[[:word:]]+" "\(" "\)") => ()
    _ => fail("Should match empty function call")
  }
}

///|
test "Method call sequence" {
  lexmatch "obj.method()" {
    ("[[:word:]]+" "\." "[[:word:]]+" "\(" "\)") => ()
    _ => fail("Should match method call")
  }
}

///|
test "Namespace sequence" {
  lexmatch "std::vector" {
    ("[[:word:]]+" "::" "[[:word:]]+") => ()
    _ => fail("Should match namespace")
  }
}

///|
test "File extension sequence" {
  lexmatch "file.txt" {
    ("[[:word:]]+" "\." "[[:word:]]+") => ()
    _ => fail("Should match filename")
  }
}

///|
test "MAC address sequence" {
  lexmatch "AA:BB:CC:DD:EE:FF" {
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
    _ => fail("Should match MAC address")
  }
}

///|
test "Currency amount sequence" {
  lexmatch "$123.45" {
    ("\$" "[[:digit:]]+" "\." "[[:digit:]]{2}") => ()
    _ => fail("Should match currency")
  }
}

///|
test "Percentage sequence" {
  lexmatch "95%" {
    ("[[:digit:]]+" "%") => ()
    _ => fail("Should match percentage")
  }
}

///|
test "Signed number sequence" {
  lexmatch "+123" {
    ("[+\-]" "[[:digit:]]+") => ()
    _ => fail("Should match signed number")
  }
}

///|
test "Decimal number sequence" {
  lexmatch "3.14" {
    ("[[:digit:]]+" "\." "[[:digit:]]+") => ()
    _ => fail("Should match decimal")
  }
}

///|
test "Scientific notation sequence" {
  lexmatch "1.5e10" {
    ("[[:digit:]]+" "\." "[[:digit:]]+" "[eE]" "[[:digit:]]+") => ()
    _ => fail("Should match scientific notation")
  }
}

///|
test "Range sequence" {
  lexmatch "1-10" {
    ("[[:digit:]]+" "-" "[[:digit:]]+") => ()
    _ => fail("Should match range")
  }
}

///|
test "Port number sequence" {
  lexmatch "localhost:8080" {
    ("[[:word:]]+" ":" "[[:digit:]]+") => ()
    _ => fail("Should match host:port")
  }
}

///|
test "XML tag sequence" {
  lexmatch "<tag>" {
    ("<" "[[:word:]]+" ">") => ()
    _ => fail("Should match XML tag")
  }
}

///|
test "CSS selector sequence" {
  lexmatch "div.class" {
    ("[[:word:]]+" "\." "[[:word:]]+") => ()
    _ => fail("Should match CSS selector")
  }
}

///|
test "Path separator sequence" {
  lexmatch "path/to/file" {
    ("[[:word:]]+" "/" "[[:word:]]+" "/" "[[:word:]]+") => ()
    _ => fail("Should match path")
  }
}

///|
test "Query string sequence" {
  lexmatch "?key=value" {
    ("\?" "[[:word:]]+" "=" "[[:word:]]+") => ()
    _ => fail("Should match query string")
  }
}

///|
test "Environment variable sequence" {
  lexmatch "$VAR" {
    ("\$" "[A-Z_][[:word:]]*") => ()
    _ => fail("Should match env var")
  }
}

///|
test "Git hash sequence" {
  lexmatch "commit abc1234" {
    ("commit" "[[:space:]]" "[a-f0-9]{7}") => ()
    _ => fail("Should match git commit")
  }
}

///|
test "License plate sequence" {
  lexmatch "ABC-1234" {
    ("[A-Z]{3}" "-" "[[:digit:]]{4}") => ()
    _ => fail("Should match license plate")
  }
}

///|
test "ISBN sequence" {
  lexmatch "978-3-16-148410-0" {
    (
      "[[:digit:]]{3}"
      "-"
      "[[:digit:]]"
      "-"
      "[[:digit:]]{2}"
      "-"
      "[[:digit:]]{6}"
      "-"
      "[[:digit:]]"
    ) => ()
    _ => fail("Should match ISBN")
  }
}

///|
test "Credit card sequence (simplified)" {
  lexmatch "1234-5678-9012-3456" {
    (
      "[[:digit:]]{4}"
      "-"
      "[[:digit:]]{4}"
      "-"
      "[[:digit:]]{4}"
      "-"
      "[[:digit:]]{4}"
    ) => ()
    _ => fail("Should match card number")
  }
}

///|
test "UUID sequence" {
  lexmatch "550e8400-e29b-41d4-a716-446655440000" {
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
    _ => fail("Should match UUID")
  }
}

///|
test "Coordinates sequence" {
  lexmatch "40.7128,-74.0060" {
    (
      "[[:digit:]]+"
      "\."
      "[[:digit:]]+"
      ","
      "-"
      "[[:digit:]]+"
      "\."
      "[[:digit:]]+"
    ) => ()
    _ => fail("Should match coordinates")
  }
}

///|
test "HTTP status sequence" {
  lexmatch "200 OK" {
    ("[[:digit:]]{3}" "[[:space:]]" "[[:word:]]+") => ()
    _ => fail("Should match HTTP status")
  }
}

///|
test "Package version sequence" {
  lexmatch "package@1.2.3" {
    ("[[:word:]]+" "@" "[[:digit:]]+" "\." "[[:digit:]]+" "\." "[[:digit:]]+") =>
      ()
    _ => fail("Should match package version")
  }
}

///|
test "Markdown link sequence" {
  lexmatch "[text](url)" {
    ("\[" "[^\]]+" "\]" "\(" "[^\)]+" "\)") => ()
    _ => fail("Should match markdown link")
  }
}

///|
test "HTML attribute sequence" {
  lexmatch "id=\"value\"" {
    ("[[:word:]]+" "=" "\"" "[^\"]*" "\"") => ()
    _ => fail("Should match HTML attribute")
  }
}

///|
test "JSON key-value sequence" {
  lexmatch "\"key\":\"value\"" {
    ("\"" "[[:word:]]+" "\"" ":" "\"" "[[:word:]]+" "\"") => ()
    _ => fail("Should match JSON pair")
  }
}

///|
test "CSS property sequence" {
  lexmatch "color: red;" {
    ("[[:word:]]+" ":" "[[:space:]]*" "[[:word:]]+" ";") => ()
    _ => fail("Should match CSS property")
  }
}

///|
test "Import statement sequence" {
  lexmatch "import x from y" {
    (
      "import"
      "[[:space:]]"
      "[[:word:]]+"
      "[[:space:]]"
      "from"
      "[[:space:]]"
      "[[:word:]]+"
    ) => ()
    _ => fail("Should match import")
  }
}

///|
test "SQL select sequence" {
  lexmatch "SELECT * FROM table" {
    (
      "SELECT"
      "[[:space:]]"
      ".*"
      "[[:space:]]"
      "FROM"
      "[[:space:]]"
      "[[:word:]]+"
    ) => ()
    _ => fail("Should match SELECT")
  }
}

///|
test "RGB color sequence" {
  lexmatch "rgb(255,0,128)" {
    (
      "rgb"
      "\("
      "[[:digit:]]{1,3}"
      ","
      "[[:digit:]]{1,3}"
      ","
      "[[:digit:]]{1,3}"
      "\)"
    ) => ()
    _ => fail("Should match RGB color")
  }
}

///|
test "File permission sequence" {
  lexmatch "rwxr-xr-x" {
    ("[\-rwx]{3}" "[\-rwx]{3}" "[\-rwx]{3}") => ()
    _ => fail("Should match permissions")
  }
}

///|
test "Shebang sequence" {
  lexmatch "#!/bin/bash" {
    ("#!" "/" "[[:word:]]+" "/" "[[:word:]]+") => ()
    _ => fail("Should match shebang")
  }
}

///|
test "Docker image sequence" {
  lexmatch "image:tag" {
    ("[[:word:]]+" ":" "[[:word:]]+") => ()
    _ => fail("Should match image:tag")
  }
}

///|
test "Git reference sequence" {
  lexmatch "refs/heads/main" {
    ("refs" "/" "[[:word:]]+" "/" "[[:word:]]+") => ()
    _ => fail("Should match git ref")
  }
}

///|
test "Binary operator sequence" {
  lexmatch "a + b" {
    ("[[:word:]]" "[[:space:]]*" "[+\-*/]" "[[:space:]]*" "[[:word:]]") => ()
    _ => fail("Should match binary operation")
  }
}

///|
test "Comparison operator sequence" {
  lexmatch "x == y" {
    ("[[:word:]]" "[[:space:]]*" "==" "[[:space:]]*" "[[:word:]]") => ()
    _ => fail("Should match comparison")
  }
}

///|
test "Ternary operator sequence" {
  lexmatch "a ? b : c" {
    (
      "[[:word:]]"
      "[[:space:]]*"
      "\?"
      "[[:space:]]*"
      "[[:word:]]"
      "[[:space:]]*"
      ":"
      "[[:space:]]*"
      "[[:word:]]"
    ) => ()
    _ => fail("Should match ternary")
  }
}

///|
test "Lambda arrow sequence" {
  lexmatch "() => x" {
    ("\(" "\)" "[[:space:]]*" "=>" "[[:space:]]*" "[[:word:]]") => ()
    _ => fail("Should match lambda")
  }
}

///|
test "Property access sequence" {
  lexmatch "obj.prop.value" {
    ("[[:word:]]+" "\." "[[:word:]]+" "\." "[[:word:]]+") => ()
    _ => fail("Should match nested property")
  }
}

///|
test "Type annotation sequence" {
  lexmatch "x: Int" {
    ("[[:word:]]" ":" "[[:space:]]*" "[[:word:]]+") => ()
    _ => fail("Should match type annotation")
  }
}

///|
test "Generic type sequence" {
  lexmatch "List<Int>" {
    ("[[:word:]]+" "<" "[[:word:]]+" ">") => ()
    _ => fail("Should match generic type")
  }
}

///|
test "Angle brackets sequence" {
  lexmatch "<tag>" {
    ("<" "[a-z]+" ">") => ()
    _ => fail("Should match angle brackets")
  }
}
