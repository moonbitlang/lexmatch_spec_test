// Capture tests - comprehensive tests for 'as' keyword capture patterns

///|
test "Simple string capture" {
  lexmatch "hello" {
    ("hello" as word) =>
      if word.to_string() == "hello" {
        ()
      } else {
        fail("Should capture 'hello'")
      }
    _ => fail("Should match")
  }
}

///|
test "Digit capture" {
  lexmatch "5" {
    ("[[:digit:]]" as digit) =>
      if digit == '5' {
        ()
      } else {
        fail("Should capture digit 5")
      }
    _ => fail("Should match")
  }
}

///|
test "Multiple digit capture" {
  lexmatch "123" {
    ("[[:digit:]]+" as number) =>
      if number.to_string() == "123" {
        ()
      } else {
        fail("Should capture '123'")
      }
    _ => fail("Should match")
  }
}

///|
test "Letter capture" {
  lexmatch "x" {
    ("[a-z]" as letter) =>
      if letter == 'x' {
        ()
      } else {
        fail("Should capture 'x'")
      }
    _ => fail("Should match")
  }
}

///|
test "Word capture with character class" {
  lexmatch "test" {
    ("[[:word:]]+" as word) =>
      if word.to_string() == "test" {
        ()
      } else {
        fail("Should capture 'test'")
      }
    _ => fail("Should match")
  }
}

///|
test "Sign character capture" {
  lexmatch "+" {
    ("[+\-]" as sign) =>
      if sign == '+' {
        ()
      } else {
        fail("Should capture plus sign")
      }
    _ => fail("Should match")
  }
  lexmatch "-" {
    ("[+\-]" as sign) =>
      if sign == '-' {
        ()
      } else {
        fail("Should capture minus sign")
      }
    _ => fail("Should match")
  }
}

///|
test "Hex digit capture" {
  lexmatch "a" {
    ("[0-9a-f]" as hex) =>
      if hex == 'a' {
        ()
      } else {
        fail("Should capture hex digit")
      }
    _ => fail("Should match")
  }
}

///|
test "Capture with quantifier {n}" {
  lexmatch "abc" {
    ("[a-z]{3}" as chars) =>
      if chars.to_string() == "abc" {
        ()
      } else {
        fail("Should capture 3 chars")
      }
    _ => fail("Should match")
  }
}

///|
test "Capture with quantifier {n,m}" {
  lexmatch "hello" {
    ("[a-z]{3,6}" as word) =>
      if word.to_string() == "hello" {
        ()
      } else {
        fail("Should capture word")
      }
    _ => fail("Should match")
  }
}

///|
test "Capture email username" {
  lexmatch "user123@example.com" {
    (("[[:word:]]+" as user) "@" "[[:word:]]+" "." "[[:word:]]+") =>
      if user.to_string() == "user123" {
        ()
      } else {
        fail("Should capture username")
      }
    _ => fail("Should match")
  }
}

///|
test "Capture email domain" {
  lexmatch "test@domain.com" {
    ("[[:word:]]+" "@" ("[[:word:]]+" as domain) "." "[[:word:]]+") =>
      if domain.to_string() == "domain" {
        ()
      } else {
        fail("Should capture domain")
      }
    _ => fail("Should match")
  }
}

///|
test "Capture with rest variable" {
  lexmatch "hello world" {
    ("hello" as greeting, rest) =>
      if greeting.to_string() == "hello" && rest.to_string() == " world" {
        ()
      } else {
        fail("Should capture greeting and rest")
      }
    _ => fail("Should match")
  }
}

///|
test "Capture number with rest" {
  lexmatch "123abc" {
    ("[[:digit:]]+" as num, rest) =>
      if num.to_string() == "123" && rest.to_string() == "abc" {
        ()
      } else {
        fail("Should capture number and rest")
      }
    _ => fail("Should match")
  }
}

///|
test "Capture identifier" {
  lexmatch "myVar123" {
    ("[a-zA-Z_][[:word:]]*" as id) =>
      if id.to_string() == "myVar123" {
        ()
      } else {
        fail("Should capture identifier")
      }
    _ => fail("Should match")
  }
}

///|
test "Capture quoted string content" {
  lexmatch "\"hello\"" {
    ("\"" ("[^\"]*" as content) "\"") =>
      if content.to_string() == "hello" {
        ()
      } else {
        fail("Should capture string content")
      }
    _ => fail("Should match")
  }
}

///|
test "Capture IP address parts - first octet" {
  lexmatch "192.168.1.1" {
    (
      ("[[:digit:]]{1,3}" as first)
      "."
      "[[:digit:]]{1,3}"
      "."
      "[[:digit:]]{1,3}"
      "."
      "[[:digit:]]{1,3}"
    ) =>
      if first.to_string() == "192" {
        ()
      } else {
        fail("Should capture first octet")
      }
    _ => fail("Should match")
  }
}

///|
test "Capture file extension" {
  lexmatch "file.txt" {
    ("[[:word:]]+" "." ("[[:word:]]+" as ext)) =>
      if ext.to_string() == "txt" {
        ()
      } else {
        fail("Should capture extension")
      }
    _ => fail("Should match")
  }
}

///|
test "Capture protocol from URL" {
  lexmatch "https://example.com" {
    (("[a-z]+" as protocol) "://" ".*") =>
      if protocol.to_string() == "https" {
        ()
      } else {
        fail("Should capture protocol")
      }
    _ => fail("Should match")
  }
}

///|
test "Capture phone number area code" {
  lexmatch "(123)456-7890" {
    ("\(" ("[[:digit:]]{3}" as area) "\)" "[[:digit:]]{3}" "-" "[[:digit:]]{4}") =>
      if area.to_string() == "123" {
        ()
      } else {
        fail("Should capture area code")
      }
    _ => fail("Should match")
  }
}

///|
test "Capture version major number" {
  lexmatch "1.2.3" {
    (("[[:digit:]]+" as major) "." "[[:digit:]]+" "." "[[:digit:]]+") =>
      if major.to_string() == "1" {
        ()
      } else {
        fail("Should capture major version")
      }
    _ => fail("Should match")
  }
}

///|
test "Capture hexadecimal color code" {
  lexmatch "#FF00AA" {
    ("#" ("[0-9A-Fa-f]{6}" as color)) =>
      if color.to_string() == "FF00AA" {
        ()
      } else {
        fail("Should capture color code")
      }
    _ => fail("Should match")
  }
}

///|
test "Capture date year" {
  lexmatch "2024-01-15" {
    (("[[:digit:]]{4}" as year) "-" "[[:digit:]]{2}" "-" "[[:digit:]]{2}") =>
      if year.to_string() == "2024" {
        ()
      } else {
        fail("Should capture year")
      }
    _ => fail("Should match")
  }
}

///|
test "Capture date month" {
  lexmatch "2024-12-31" {
    ("[[:digit:]]{4}" "-" ("[[:digit:]]{2}" as month) "-" "[[:digit:]]{2}") =>
      if month.to_string() == "12" {
        ()
      } else {
        fail("Should capture month")
      }
    _ => fail("Should match")
  }
}

///|
test "Capture time hours" {
  lexmatch "14:30:45" {
    (("[[:digit:]]{2}" as hours) ":" "[[:digit:]]{2}" ":" "[[:digit:]]{2}") =>
      if hours.to_string() == "14" {
        ()
      } else {
        fail("Should capture hours")
      }
    _ => fail("Should match")
  }
}

///|
test "Capture variable name from assignment" {
  lexmatch "x = 5" {
    (("[a-zA-Z_][[:word:]]*" as varname) "[[:space:]]*" "=" ".*") =>
      if varname.to_string() == "x" {
        ()
      } else {
        fail("Should capture variable name")
      }
    _ => fail("Should match")
  }
}

///|
test "Capture function name from call" {
  lexmatch "print()" {
    (("[a-zA-Z_][[:word:]]*" as funcname) "\(" ".*" "\)") =>
      if funcname.to_string() == "print" {
        ()
      } else {
        fail("Should capture function name")
      }
    _ => fail("Should match")
  }
}

///|
test "Capture comment text" {
  lexmatch "// this is a comment" {
    ("//" "[[:space:]]*" ("[^\n]*" as comment)) =>
      if comment.to_string() == "this is a comment" {
        ()
      } else {
        fail("Should capture comment text")
      }
    _ => fail("Should match")
  }
}

///|
test "Capture MAC address part" {
  lexmatch "AA:BB:CC:DD:EE:FF" {
    (
      ("[[:digit:]A-Fa-f]{2}" as part1)
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
    ) =>
      if part1.to_string() == "AA" {
        ()
      } else {
        fail("Should capture first MAC part")
      }
    _ => fail("Should match")
  }
}

///|
test "Capture integer from expression" {
  lexmatch "x + 42" {
    (
      "[[:word:]]+"
      "[[:space:]]*"
      "[+\-*/]"
      "[[:space:]]*"
      ("[[:digit:]]+" as num)
    ) =>
      if num.to_string() == "42" {
        ()
      } else {
        fail("Should capture number")
      }
    _ => fail("Should match")
  }
}

///|
test "Capture UUID part" {
  lexmatch "550e8400-e29b-41d4-a716-446655440000" {
    (
      ("[[:digit:]a-f]{8}" as part1)
      "-"
      "[[:digit:]a-f]{4}"
      "-"
      "[[:digit:]a-f]{4}"
      "-"
      "[[:digit:]a-f]{4}"
      "-"
      "[[:digit:]a-f]{12}"
    ) =>
      if part1.to_string() == "550e8400" {
        ()
      } else {
        fail("Should capture UUID first part")
      }
    _ => fail("Should match")
  }
}

///|
test "Capture whitespace-separated word" {
  lexmatch "  hello  " {
    ("[[:space:]]*" ("[[:word:]]+" as word) "[[:space:]]*") =>
      if word.to_string() == "hello" {
        ()
      } else {
        fail("Should capture word")
      }
    _ => fail("Should match")
  }
}

///|
test "Capture number with optional sign" {
  lexmatch "+123" {
    (("[+\-]" as sign) ("[[:digit:]]+" as num)) =>
      if sign == '+' && num.to_string() == "123" {
        ()
      } else {
        fail("Should capture sign and number")
      }
    _ => fail("Should match")
  }
}

///|
test "Capture decimal number parts" {
  lexmatch "3.14" {
    (("[[:digit:]]+" as intpart) "." ("[[:digit:]]+" as fracpart)) =>
      if intpart.to_string() == "3" && fracpart.to_string() == "14" {
        ()
      } else {
        fail("Should capture integer and fractional parts")
      }
    _ => fail("Should match")
  }
}

///|
test "Capture escaped character" {
  lexmatch "\\n" {
    ("\\" ("[nrt]" as esc)) =>
      if esc == 'n' {
        ()
      } else {
        fail("Should capture escape character")
      }
    _ => fail("Should match")
  }
}

///|
test "Capture HTML tag name" {
  lexmatch "<div>" {
    ("<" ("[a-zA-Z][[:word:]]*" as tagname) ">") =>
      if tagname.to_string() == "div" {
        ()
      } else {
        fail("Should capture tag name")
      }
    _ => fail("Should match")
  }
}

///|
test "Capture CSS class name" {
  lexmatch ".my-class" {
    ("\." ("[[:word:]\-]+" as classname)) =>
      if classname.to_string() == "my-class" {
        ()
      } else {
        fail("Should capture class name")
      }
    _ => fail("Should match")
  }
}

///|
test "Capture JSON key" {
  lexmatch "\"name\": \"value\"" {
    ("\"" ("[[:word:]]+" as key) "\"" ":" ".*") =>
      if key.to_string() == "name" {
        ()
      } else {
        fail("Should capture key")
      }
    _ => fail("Should match")
  }
}

///|
test "Capture environment variable" {
  lexmatch "$HOME" {
    ("\$" ("[A-Z_][[:word:]]*" as envvar)) =>
      if envvar.to_string() == "HOME" {
        ()
      } else {
        fail("Should capture env var")
      }
    _ => fail("Should match")
  }
}

///|
test "Capture path component" {
  lexmatch "/usr/local/bin" {
    ("/" ("[^/]+" as dir) "/.*") =>
      if dir.to_string() == "usr" {
        ()
      } else {
        fail("Should capture directory")
      }
    _ => fail("Should match")
  }
}

///|
test "Capture operator from expression" {
  lexmatch "a + b" {
    (
      "[[:word:]]+"
      "[[:space:]]*"
      ("[+\-*/]" as op)
      "[[:space:]]*"
      "[[:word:]]+"
    ) => if op == '+' { () } else { fail("Should capture operator") }
    _ => fail("Should match")
  }
}

///|
test "Capture git hash prefix" {
  lexmatch "commit abc1234" {
    ("commit" " " ("[a-f0-9]{7}" as hash)) =>
      if hash.to_string() == "abc1234" {
        ()
      } else {
        fail("Should capture hash")
      }
    _ => fail("Should match")
  }
}

///|
test "Capture username from email" {
  lexmatch "john.doe@example.com" {
    (("[[:word:]\.]+" as username) "@" "[[:word:]]+" "." "[[:word:]]+") =>
      if username.to_string() == "john.doe" {
        ()
      } else {
        fail("Should capture username with dot")
      }
    _ => fail("Should match")
  }
}

///|
test "Capture port from URL" {
  lexmatch "localhost:8080" {
    ("[[:word:]]+" ":" ("[[:digit:]]+" as port)) =>
      if port.to_string() == "8080" {
        ()
      } else {
        fail("Should capture port")
      }
    _ => fail("Should match")
  }
}

///|
test "Capture scientific notation exponent" {
  lexmatch "1.5e-10" {
    ("[[:digit:]]+" "." "[[:digit:]]+" "[eE]" "[+\-]" ("[[:digit:]]+" as exp)) =>
      if exp.to_string() == "10" {
        ()
      } else {
        fail("Should capture exponent")
      }
    _ => fail("Should match")
  }
}

///|
test "Capture array index" {
  lexmatch "arr[5]" {
    ("[[:word:]]+" "\[" ("[[:digit:]]+" as index) "\]") =>
      if index.to_string() == "5" {
        ()
      } else {
        fail("Should capture index")
      }
    _ => fail("Should match")
  }
}

///|
test "Capture CSS hex color short form" {
  lexmatch "#FFF" {
    ("#" ("[0-9A-Fa-f]{3}" as color)) =>
      if color.to_string() == "FFF" {
        ()
      } else {
        fail("Should capture short color")
      }
    _ => fail("Should match")
  }
}

///|
test "Capture query parameter name" {
  lexmatch "?name=value" {
    ("\?" ("[[:word:]]+" as param) "=" ".*") =>
      if param.to_string() == "name" {
        ()
      } else {
        fail("Should capture parameter name")
      }
    _ => fail("Should match")
  }
}

///|
test "Capture markdown heading level" {
  lexmatch "### Title" {
    (("#{1,6}" as level) "[[:space:]]" ".*") =>
      if level.to_string() == "###" {
        ()
      } else {
        fail("Should capture heading markers")
      }
    _ => fail("Should match")
  }
}
