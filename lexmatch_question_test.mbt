// lexmatch? expression tests - testing boolean pattern matching with lexmatch?

///|
test "lexmatch? - simple match returns true" {
  let text = "hello"
  let result = text lexmatch? "hello" with longest
  if result {
    ()
  } else {
    fail("Should return true for matching pattern")
  }
}

///|
test "lexmatch? - no match returns false" {
  let text = "hello"
  let result = text lexmatch? "world" with longest
  if not(result) {
    ()
  } else {
    fail("Should return false for non-matching pattern")
  }
}

///|
test "lexmatch? - with character class" {
  let text = "abc123"
  let result = text lexmatch? ("[a-z]+", _) with longest
  if result {
    ()
  } else {
    fail("Should match letters")
  }
}

///|
test "lexmatch? - with rest variable" {
  let text = "hello world"
  let result = text lexmatch? ("hello", _) with longest
  if result {
    ()
  } else {
    fail("Should match with rest")
  }
}

///|
test "lexmatch? - with capture" {
  let text = "test123"
  let result = text lexmatch? ("[a-z]+" as _word, _) with longest
  if result {
    ()
  } else {
    fail("Should match with capture")
  }
}

///|
test "lexmatch? - digit pattern" {
  let text = "12345"
  if text lexmatch? "[[:digit:]]+" with longest {
    ()
  } else {
    fail("Should match digits")
  }
}

///|
test "lexmatch? - email validation" {
  let email = "test@example.com"
  if email
    lexmatch? ("[[:word:]]+" "@" "[[:word:]]+" "\." "[[:word:]]+") with longest {
    ()
  } else {
    fail("Should match email pattern")
  }
  let invalid = "notanemail"
  if not(
      invalid
      lexmatch? ("[[:word:]]+" "@" "[[:word:]]+" "\." "[[:word:]]+") with longest,
    ) {
    ()
  } else {
    fail("Should not match invalid email")
  }
}

///|
test "lexmatch? - URL protocol check" {
  let url1 = "https://example.com"
  if url1 lexmatch? ("[a-z]+" "://" ".*") with longest {
    ()
  } else {
    fail("Should match URL")
  }
  let url2 = "ftp://server.com"
  if url2 lexmatch? ("[a-z]+" "://" ".*") with longest {
    ()
  } else {
    fail("Should match FTP URL")
  }
}

///|
test "lexmatch? - case insensitive matching" {
  let text = "HTTP"
  if text lexmatch? "(?i:http)" with longest {
    ()
  } else {
    fail("Should match case insensitively")
  }
}

///|
test "lexmatch? - empty string" {
  let text = ""
  if text lexmatch? "" with longest {
    ()
  } else {
    fail("Should match empty string")
  }
}

///|
test "lexmatch? - optional pattern" {
  let text1 = "a"
  let text2 = ""
  if text1 lexmatch? "a?" with longest {
    ()
  } else {
    fail("Should match 'a'")
  }
  if text2 lexmatch? "a?" with longest {
    ()
  } else {
    fail("Should match empty with a?")
  }
}

///|
test "lexmatch? - phone number validation" {
  let phone = "(123)456-7890"
  if phone
    lexmatch? ("\(" "[[:digit:]]{3}" "\)" "[[:digit:]]{3}" "-" "[[:digit:]]{4}") with longest {
    ()
  } else {
    fail("Should match phone number")
  }
}

///|
test "lexmatch? - IP address validation" {
  let ip = "192.168.1.1"
  if ip
    lexmatch? (
      "[[:digit:]]{1,3}"
      "\."
      "[[:digit:]]{1,3}"
      "\."
      "[[:digit:]]{1,3}"
      "\."
      "[[:digit:]]{1,3}"
    ) with longest {
    ()
  } else {
    fail("Should match IP address")
  }
}

///|
test "lexmatch? - hex color validation" {
  let color1 = "#FF00AA"
  if color1 lexmatch? ("#" "[0-9A-Fa-f]{6}") with longest {
    ()
  } else {
    fail("Should match hex color")
  }
  let color2 = "#FFF"
  if color2 lexmatch? ("#" "[0-9A-Fa-f]{3}") with longest {
    ()
  } else {
    fail("Should match short hex color")
  }
}

///|
test "lexmatch? - date format validation" {
  let date = "2024-01-15"
  if date
    lexmatch? ("[[:digit:]]{4}" "-" "[[:digit:]]{2}" "-" "[[:digit:]]{2}") with longest {
    ()
  } else {
    fail("Should match date format")
  }
}

///|
test "lexmatch? - time format validation" {
  let time = "14:30:45"
  if time
    lexmatch? ("[[:digit:]]{2}" ":" "[[:digit:]]{2}" ":" "[[:digit:]]{2}") with longest {
    ()
  } else {
    fail("Should match time format")
  }
}

///|
test "lexmatch? - version string validation" {
  let version = "1.2.3"
  if version
    lexmatch? ("[[:digit:]]+" "\." "[[:digit:]]+" "\." "[[:digit:]]+") with longest {
    ()
  } else {
    fail("Should match version format")
  }
}

///|
test "lexmatch? - UUID validation" {
  let uuid = "550e8400-e29b-41d4-a716-446655440000"
  if uuid
    lexmatch? (
      "[[:digit:]a-f]{8}"
      "-"
      "[[:digit:]a-f]{4}"
      "-"
      "[[:digit:]a-f]{4}"
      "-"
      "[[:digit:]a-f]{4}"
      "-"
      "[[:digit:]a-f]{12}"
    ) with longest {
    ()
  } else {
    fail("Should match UUID format")
  }
}

///|
test "lexmatch? - MAC address validation" {
  let mac = "AA:BB:CC:DD:EE:FF"
  if mac
    lexmatch? (
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
    ) with longest {
    ()
  } else {
    fail("Should match MAC address")
  }
}

///|
test "lexmatch? - identifier validation" {
  let id1 = "myVar"
  if id1 lexmatch? "[a-zA-Z_][[:word:]]*" with longest {
    ()
  } else {
    fail("Should match identifier")
  }
  let id2 = "123invalid"
  if not(id2 lexmatch? "[a-zA-Z_][[:word:]]*" with longest) {
    ()
  } else {
    fail("Should not match identifier starting with digit")
  }
}

///|
test "lexmatch? - boolean literal check" {
  let text1 = "true"
  let text2 = "false"
  if text1 lexmatch? "(?i:true)" with longest {
    ()
  } else {
    fail("Should match true")
  }
  if text2 lexmatch? "(?i:false)" with longest {
    ()
  } else {
    fail("Should match false")
  }
}

///|
test "lexmatch? - number format check" {
  let int_num = "123"
  if int_num lexmatch? "[[:digit:]]+" with longest {
    ()
  } else {
    fail("Should match integer")
  }
  let float_num = "3.14"
  if float_num lexmatch? ("[[:digit:]]+" "\." "[[:digit:]]+") with longest {
    ()
  } else {
    fail("Should match float")
  }
}

///|
test "lexmatch? - signed number check" {
  let pos = "+123"
  let neg = "-456"
  if pos lexmatch? ("[+\-]" "[[:digit:]]+") with longest {
    ()
  } else {
    fail("Should match positive number")
  }
  if neg lexmatch? ("[+\-]" "[[:digit:]]+") with longest {
    ()
  } else {
    fail("Should match negative number")
  }
}

///|
test "lexmatch? - comment line check" {
  let comment = "// this is a comment"
  if comment lexmatch? ("//" ".*") with longest {
    ()
  } else {
    fail("Should match comment")
  }
}

///|
test "lexmatch? - quoted string check" {
  let quoted = "\"hello\""
  if quoted lexmatch? ("\"" "[^\"]*" "\"") with longest {
    ()
  } else {
    fail("Should match quoted string")
  }
}

///|
test "lexmatch? - file extension check" {
  let file = "document.pdf"
  if file lexmatch? ("[[:word:]]+" "\." "(?i:pdf)") with longest {
    ()
  } else {
    fail("Should match PDF file")
  }
}

///|
test "lexmatch? - path validation" {
  let path = "/usr/local/bin"
  if path
    lexmatch? ("/" "[[:word:]]+" "/" "[[:word:]]+" "/" "[[:word:]]+") with longest {
    ()
  } else {
    fail("Should match path")
  }
}

///|
test "lexmatch? - credit card pattern" {
  let card = "4111-1111-1111-1111"
  if card
    lexmatch? (
      "[[:digit:]]{4}"
      "-"
      "[[:digit:]]{4}"
      "-"
      "[[:digit:]]{4}"
      "-"
      "[[:digit:]]{4}"
    ) with longest {
    ()
  } else {
    fail("Should match card number")
  }
}

///|
test "lexmatch? - BytesView matching" {
  let bytes = b"hello"
  if bytes lexmatch? "hello" with longest {
    ()
  } else {
    fail("Should match BytesView")
  }
}

///|
test "lexmatch? - BytesView with pattern" {
  let bytes = b"test@example.com"
  if bytes
    lexmatch? ("[[:word:]]+" "@" "[[:word:]]+" "\." "[[:word:]]+") with longest {
    ()
  } else {
    fail("Should match email in BytesView")
  }
}

///|
test "lexmatch? - used in conditional" {
  let text = "abc123"
  if text lexmatch? "[a-z]+" with longest {
    fail("Should not match entirely")
  } else if text lexmatch? ("a[a-z]*", _) with longest {
    ()
  } else {
    fail("Should match with rest")
  }
}

///|
test "lexmatch? - negation check" {
  let text = "abc"
  if not(text lexmatch? "[[:digit:]]+" with longest) {
    ()
  } else {
    fail("Should not match digits")
  }
}

///|
test "lexmatch? - whitespace check" {
  let spaces = "   "
  if spaces lexmatch? "[[:space:]]+" with longest {
    ()
  } else {
    fail("Should match whitespace")
  }
  let nospace = "abc"
  if not(nospace lexmatch? "[[:space:]]+" with longest) {
    ()
  } else {
    fail("Should not match non-whitespace")
  }
}

///|
test "lexmatch? - wildcard pattern" {
  let text = "anything"
  if text lexmatch? ".*" with longest {
    ()
  } else {
    fail("Should match with .*")
  }
}

///|
test "lexmatch? - exact match only" {
  let text = "hello"
  if text lexmatch? "hello" with longest {
    ()
  } else {
    fail("Should match exactly")
  }
  if not(text lexmatch? "hello world" with longest) {
    ()
  } else {
    fail("Should not match longer pattern")
  }
}

///|
test "lexmatch? - prefix match with rest" {
  let text = "hello world"
  if text lexmatch? ("hello", _) with longest {
    ()
  } else {
    fail("Should match prefix")
  }
}

///|
test "lexmatch? - HTML tag detection" {
  let tag = "<div>"
  if tag lexmatch? ("<" "[[:word:]]+" ">") with longest {
    ()
  } else {
    fail("Should match HTML tag")
  }
}

///|
test "lexmatch? - JSON structure check" {
  let json_key = "\"name\":"
  if json_key lexmatch? ("\"" "[[:word:]]+" "\"" ":") with longest {
    ()
  } else {
    fail("Should match JSON key")
  }
}

///|
test "lexmatch? - SQL keyword check" {
  let sql = "SELECT"
  if sql lexmatch? "(?i:select)" with longest {
    ()
  } else {
    fail("Should match SELECT keyword")
  }
}

///|
test "lexmatch? - environment variable check" {
  let env = "$HOME"
  if env lexmatch? ("\$" "[A-Z_][[:word:]]*") with longest {
    ()
  } else {
    fail("Should match env variable")
  }
}

///|
test "lexmatch? - CSV format check" {
  let csv = "a,b,c"
  if csv lexmatch? ("[[:word:]]" "," "[[:word:]]" "," "[[:word:]]") with longest {
    ()
  } else {
    fail("Should match CSV pattern")
  }
}

///|
test "lexmatch? - currency amount check" {
  let price = "$99.99"
  if price lexmatch? ("\$" "[[:digit:]]+" "\." "[[:digit:]]{2}") with longest {
    ()
  } else {
    fail("Should match currency format")
  }
}

///|
test "lexmatch? - percentage check" {
  let percent = "75%"
  if percent lexmatch? ("[[:digit:]]+" "%") with longest {
    ()
  } else {
    fail("Should match percentage")
  }
}

///|
test "lexmatch? - range check" {
  let range = "1-10"
  if range lexmatch? ("[[:digit:]]+" "-" "[[:digit:]]+") with longest {
    ()
  } else {
    fail("Should match range")
  }
}

///|
test "lexmatch? - network port check" {
  let address = "localhost:8080"
  if address lexmatch? ("[[:word:]]+" ":" "[[:digit:]]+") with longest {
    ()
  } else {
    fail("Should match host:port")
  }
}

///|
test "lexmatch? - git hash check" {
  let commit = "commit abc1234"
  if commit lexmatch? ("commit" "[[:space:]]" "[a-f0-9]{7}") with longest {
    ()
  } else {
    fail("Should match git commit")
  }
}

///|
test "lexmatch? - markdown heading check" {
  let heading = "### Title"
  if heading lexmatch? ("#{1,6}" "[[:space:]]" ".*") with longest {
    ()
  } else {
    fail("Should match markdown heading")
  }
}

///|
test "lexmatch? - method chaining" {
  let code = "obj.method1().method2()"
  if code
    lexmatch? (
      "[[:word:]]+"
      "\."
      "[[:word:]]+"
      "\("
      "\)"
      "\."
      "[[:word:]]+"
      "\("
      "\)"
    ) with longest {
    ()
  } else {
    fail("Should match method chaining")
  }
}

///|
test "lexmatch? - array index check" {
  let access = "arr[5]"
  if access lexmatch? ("[[:word:]]+" "\[" "[[:digit:]]+" "\]") with longest {
    ()
  } else {
    fail("Should match array access")
  }
}

///|
test "lexmatch? - ternary operator check" {
  let ternary = "a ? b : c"
  if ternary
    lexmatch? (
      "[[:word:]]"
      "[[:space:]]*"
      "\?"
      "[[:space:]]*"
      "[[:word:]]"
      "[[:space:]]*"
      ":"
      "[[:space:]]*"
      "[[:word:]]"
    ) with longest {
    ()
  } else {
    fail("Should match ternary operator")
  }
}

///|
test "lexmatch? - lambda arrow check" {
  let lambda = "() => x"
  if lambda
    lexmatch? ("\(" "\)" "[[:space:]]*" "=>" "[[:space:]]*" "[[:word:]]") with longest {
    ()
  } else {
    fail("Should match lambda arrow")
  }
}

///|
test "lexmatch? - type annotation check" {
  let annotation = "x: Int"
  if annotation
    lexmatch? ("[[:word:]]" ":" "[[:space:]]*" "[[:word:]]+") with longest {
    ()
  } else {
    fail("Should match type annotation")
  }
}

///|
test "lexmatch? - generic type check" {
  let generic = "List<Int>"
  if generic lexmatch? ("[[:word:]]+" "<" "[[:word:]]+" ">") with longest {
    ()
  } else {
    fail("Should match generic type")
  }
}

///|
test "lexmatch? - combining multiple checks" {
  fn is_valid_email(s : String) -> Bool {
    s
    lexmatch? ("[[:word:]]+" "@" "[[:word:]]+" "\." "[[:word:]]+") with longest
  }

  if is_valid_email("test@example.com") {
    ()
  } else {
    fail("Should validate email")
  }
  if not(is_valid_email("invalid")) {
    ()
  } else {
    fail("Should reject invalid email")
  }
}

///|
test "lexmatch? - protocol detection function" {
  fn get_protocol_type(url : String) -> String {
    if url lexmatch? ("(?i:https)" "://" ".*") with longest {
      "secure"
    } else if url lexmatch? ("(?i:http)" "://" ".*") with longest {
      "insecure"
    } else if url lexmatch? ("(?i:ftp)" "://" ".*") with longest {
      "file-transfer"
    } else {
      "unknown"
    }
  }

  if get_protocol_type("https://example.com") == "secure" {
    ()
  } else {
    fail("Should detect HTTPS")
  }
  if get_protocol_type("http://example.com") == "insecure" {
    ()
  } else {
    fail("Should detect HTTP")
  }
  if get_protocol_type("ftp://server.com") == "file-transfer" {
    ()
  } else {
    fail("Should detect FTP")
  }
}
