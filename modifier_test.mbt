// Modifier tests - case-insensitive and other modifiers

///|
test "(?i:...) - case insensitive basic" {
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
    _ => fail("Should match mixed case")
  }
}

///|
test "(?i:...) - single letter" {
  lexmatch "a" {
    "(?i:A)" => ()
    _ => fail("Should match a with A pattern")
  }
  lexmatch "Z" {
    "(?i:z)" => ()
    _ => fail("Should match Z with z pattern")
  }
}

///|
test "(?i:...) - word pattern" {
  lexmatch "hello" {
    "(?i:HELLO)" => ()
    _ => fail("Should match hello with HELLO pattern")
  }
  lexmatch "WORLD" {
    "(?i:world)" => ()
    _ => fail("Should match WORLD with world pattern")
  }
  lexmatch "TeSt" {
    "(?i:test)" => ()
    _ => fail("Should match mixed case")
  }
}

///|
test "(?i:...) - with character classes" {
  lexmatch "ABC123" {
    "(?i:[a-z]+)[[:digit:]]+" => ()
    _ => fail("Should match case insensitive letters with digits")
  }
}

///|
test "(?i:...) - nested in sequence" {
  lexmatch "HTTPs" {
    ("(?i:http)" "s") => ()
    _ => fail("Should match case insensitive HTTP with lowercase s")
  }
}

///|
test "(?i:...) - protocol matching" {
  lexmatch "FTP://server" {
    ("(?i:ftp)" "://" ".*") => ()
    _ => fail("Should match FTP protocol")
  }
  lexmatch "Http://test" {
    ("(?i:http)" "://" ".*") => ()
    _ => fail("Should match HTTP protocol")
  }
}

///|
test "(?i:...) - file extension" {
  lexmatch "file.TXT" {
    ("[[:word:]]+" "\." "(?i:txt)") => ()
    _ => fail("Should match .TXT extension")
  }
  lexmatch "doc.Pdf" {
    ("[[:word:]]+" "\." "(?i:pdf)") => ()
    _ => fail("Should match .Pdf extension")
  }
}

///|
test "(?i:...) - HTML tag" {
  lexmatch "<DIV>" {
    ("<" "(?i:div)" ">") => ()
    _ => fail("Should match DIV tag")
  }
  lexmatch "<Span>" {
    ("<" "(?i:span)" ">") => ()
    _ => fail("Should match Span tag")
  }
}

///|
test "(?i:...) - command matching" {
  lexmatch "SELECT" {
    "(?i:select)" => ()
    _ => fail("Should match SELECT command")
  }
  lexmatch "Insert" {
    "(?i:insert)" => ()
    _ => fail("Should match Insert command")
  }
}

///|
test "(?i:...) - boolean values" {
  lexmatch "TRUE" {
    "(?i:true)" => ()
    _ => fail("Should match TRUE")
  }
  lexmatch "False" {
    "(?i:false)" => ()
    _ => fail("Should match False")
  }
}

///|
test "(?i:...) - hex digits" {
  lexmatch "DEADBEEF" {
    "(?i:deadbeef)" => ()
    _ => fail("Should match hex case insensitively")
  }
  lexmatch "AbCdEf" {
    "(?i:ABCDEF)" => ()
    _ => fail("Should match mixed case hex")
  }
}

///|
test "(?i:...) - with quantifiers" {
  lexmatch "AAAA" {
    "(?i:a)+" => ()
    _ => fail("Should match multiple A's")
  }
  lexmatch "HeLLo" {
    "(?i:hello)" => ()
    _ => fail("Should match with quantifier")
  }
}

///|
test "(?i:...) - email username" {
  lexmatch "USER@example.com" {
    ("(?i:user)" "@" ".*") => ()
    _ => fail("Should match case insensitive username")
  }
}

///|
test "(?i:...) - with capture" {
  lexmatch "Hello" {
    ("(?i:hello)" as word) =>
      if word.to_string() == "Hello" {
        ()
      } else {
        fail("Should capture original case")
      }
    _ => fail("Should match")
  }
}

///|
test "(?i:...) - URL scheme" {
  lexmatch "HTTPS://example.com" {
    ("(?i:https)" "://" ".*") => ()
    _ => fail("Should match HTTPS scheme")
  }
}

///|
test "(?i:...) - with rest variable" {
  lexmatch "TEST123" with longest {
    ("(?i:test)", rest) =>
      if rest.to_string() == "123" {
        ()
      } else {
        fail("Rest should be '123'")
      }
    _ => fail("Should match")
  }
}

///|
test "(?i:...) - multiple modifiers in pattern" {
  lexmatch "HTTP FTP" {
    ("(?i:http)" "[[:space:]]" "(?i:ftp)") => ()
    _ => fail("Should match both case insensitive")
  }
}

///|
test "(?i:...) - keyword matching" {
  lexmatch "Class" {
    "(?i:class)" => ()
    _ => fail("Should match class keyword")
  }
  lexmatch "FUNCTION" {
    "(?i:function)" => ()
    _ => fail("Should match function keyword")
  }
}

///|
test "(?i:...) - month names" {
  lexmatch "JANUARY" {
    "(?i:january)" => ()
    _ => fail("Should match month name")
  }
  lexmatch "February" {
    "(?i:FEBRUARY)" => ()
    _ => fail("Should match February")
  }
}

///|
test "(?i:...) - with alternation in character class" {
  lexmatch "HTTP" {
    "(?i:http)" => ()
    _ => fail("Should match HTTP")
  }
  lexmatch "http" {
    "(?i:HTTP)" => ()
    _ => fail("Should match http")
  }
}

///|
test "Case sensitive outside modifier scope" {
  lexmatch "HTTPtest" {
    ("(?i:http)" "test") => ()
    _ => fail("Should match HTTP (insensitive) then test (sensitive)")
  }
  lexmatch "HTTPTest" {
    ("(?i:http)" "test") => fail("Should not match - test is case sensitive")
    _ => ()
  }
}

///|
test "(?i:...) - SQL keywords" {
  lexmatch "SELECT * FROM table" {
    (
      "(?i:select)"
      "[[:space:]]"
      ".*"
      "[[:space:]]"
      "(?i:from)"
      "[[:space:]]"
      "[[:word:]]+"
    ) => ()
    _ => fail("Should match SQL statement")
  }
}

///|
test "(?i:...) - programming language keywords" {
  lexmatch "IF" {
    "(?i:if)" => ()
    _ => fail("Should match IF")
  }
  lexmatch "Else" {
    "(?i:else)" => ()
    _ => fail("Should match Else")
  }
  lexmatch "while" {
    "(?i:WHILE)" => ()
    _ => fail("Should match while")
  }
}

///|
test "(?i:...) - content type" {
  lexmatch "TEXT/HTML" {
    ("(?i:text)" "/" "(?i:html)") => ()
    _ => fail("Should match content type")
  }
}

///|
test "(?i:...) - yes/no matching" {
  lexmatch "YES" {
    "(?i:yes)" => ()
    _ => fail("Should match YES")
  }
  lexmatch "No" {
    "(?i:no)" => ()
    _ => fail("Should match No")
  }
}

///|
test "(?i:...) - color names" {
  lexmatch "RED" {
    "(?i:red)" => ()
    _ => fail("Should match RED")
  }
  lexmatch "Blue" {
    "(?i:blue)" => ()
    _ => fail("Should match Blue")
  }
}

///|
test "(?i:...) - file types" {
  lexmatch "IMAGE" {
    "(?i:image)" => ()
    _ => fail("Should match IMAGE")
  }
  lexmatch "Video" {
    "(?i:video)" => ()
    _ => fail("Should match Video")
  }
}

///|
test "(?i:...) - with digits unaffected" {
  lexmatch "Test123" {
    "(?i:test)[[:digit:]]+" => ()
    _ => fail("Digits should match normally")
  }
}

///|
test "(?i:...) - platform names" {
  lexmatch "WINDOWS" {
    "(?i:windows)" => ()
    _ => fail("Should match WINDOWS")
  }
  lexmatch "Linux" {
    "(?i:linux)" => ()
    _ => fail("Should match Linux")
  }
  lexmatch "MacOS" {
    "(?i:macos)" => ()
    _ => fail("Should match MacOS")
  }
}

///|
test "(?i:...) - HTTP methods" {
  lexmatch "GET" {
    "(?i:get)" => ()
    _ => fail("Should match GET")
  }
  lexmatch "Post" {
    "(?i:post)" => ()
    _ => fail("Should match Post")
  }
  lexmatch "delete" {
    "(?i:DELETE)" => ()
    _ => fail("Should match delete")
  }
}

///|
test "(?i:...) - with underscore" {
  lexmatch "Test_Case" {
    "(?i:test_case)" => ()
    _ => fail("Should match with underscore")
  }
}

///|
test "(?i:...) - acronyms" {
  lexmatch "HTML" {
    "(?i:html)" => ()
    _ => fail("Should match HTML")
  }
  lexmatch "css" {
    "(?i:CSS)" => ()
    _ => fail("Should match css")
  }
  lexmatch "Json" {
    "(?i:json)" => ()
    _ => fail("Should match Json")
  }
}
