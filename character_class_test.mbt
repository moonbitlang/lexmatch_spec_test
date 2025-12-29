// Character class tests - comprehensive coverage of character classes and their combinations

///|
test "[[:space:]]+ multiple whitespace" {
  lexmatch "   " {
    "[[:space:]]+" => ()
    _ => fail("Should match multiple spaces")
  }
  lexmatch " \t\n" {
    "[[:space:]]+" => ()
    _ => fail("Should match mixed whitespace")
  }
}

///|
test "[[:digit:]]+ multiple digits" {
  lexmatch "12345" {
    "[[:digit:]]+" => ()
    _ => fail("Should match multiple digits")
  }
  lexmatch "0" {
    "[[:digit:]]+" => ()
    _ => fail("Should match single digit")
  }
}

///|
test "[[:word:]]+ word sequence" {
  lexmatch "abc123_XYZ" {
    "[[:word:]]+" => ()
    _ => fail("Should match word characters")
  }
}

///|
test "[[:digit:][:word:]] - digit or word character" {
  lexmatch "5" {
    "[[:digit:][:word:]]" => ()
    _ => fail("Should match digit")
  }
  lexmatch "a" {
    "[[:digit:][:word:]]" => ()
    _ => fail("Should match letter")
  }
  lexmatch "_" {
    "[[:digit:][:word:]]" => ()
    _ => fail("Should match underscore")
  }
}

///|
test "[[:space:][:digit:]] - whitespace or digit" {
  lexmatch " " {
    "[[:space:][:digit:]]" => ()
    _ => fail("Should match space")
  }
  lexmatch "5" {
    "[[:space:][:digit:]]" => ()
    _ => fail("Should match digit")
  }
  lexmatch "\t" {
    "[[:space:][:digit:]]" => ()
    _ => fail("Should match tab")
  }
  lexmatch "a" {
    "[[:space:][:digit:]]" => fail("Should not match letter")
    _ => ()
  }
}

///|
test "[[:word:][:space:]]+ - word or whitespace sequence" {
  lexmatch "hello world" {
    "[[:word:][:space:]]+" => ()
    _ => fail("Should match words with spaces")
  }
  lexmatch "test_123 \t value" {
    "[[:word:][:space:]]+" => ()
    _ => fail("Should match complex sequence")
  }
}

///|
test "[^[:digit:]] - not a digit" {
  lexmatch "a" {
    "[^[:digit:]]" => ()
    _ => fail("Should match non-digit")
  }
  lexmatch " " {
    "[^[:digit:]]" => ()
    _ => fail("Should match space")
  }
  lexmatch "5" {
    "[^[:digit:]]" => fail("Should not match digit")
    _ => ()
  }
}

///|
test "[^[:space:][:digit:]] - not whitespace or digit" {
  lexmatch "a" {
    "[^[:space:][:digit:]]" => ()
    _ => fail("Should match letter")
  }
  lexmatch "_" {
    "[^[:space:][:digit:]]" => ()
    _ => fail("Should match underscore")
  }
  lexmatch "5" {
    "[^[:space:][:digit:]]" => fail("Should not match digit")
    _ => ()
  }
  lexmatch " " {
    "[^[:space:][:digit:]]" => fail("Should not match space")
    _ => ()
  }
}

///|
test "[a-z[:digit:]] - lowercase letter or digit" {
  lexmatch "a" {
    "[a-z[:digit:]]" => ()
    _ => fail("Should match lowercase")
  }
  lexmatch "5" {
    "[a-z[:digit:]]" => ()
    _ => fail("Should match digit")
  }
  lexmatch "A" {
    "[a-z[:digit:]]" => fail("Should not match uppercase")
    _ => ()
  }
}

///|
test "[A-Z[:space:]] - uppercase or whitespace" {
  lexmatch "A" {
    "[A-Z[:space:]]" => ()
    _ => fail("Should match uppercase")
  }
  lexmatch " " {
    "[A-Z[:space:]]" => ()
    _ => fail("Should match space")
  }
  lexmatch "a" {
    "[A-Z[:space:]]" => fail("Should not match lowercase")
    _ => ()
  }
}

///|
test "[0-9a-fA-F] - hexadecimal digit" {
  lexmatch "0" {
    "[0-9a-fA-F]" => ()
    _ => fail("Should match hex digit 0")
  }
  lexmatch "9" {
    "[0-9a-fA-F]" => ()
    _ => fail("Should match hex digit 9")
  }
  lexmatch "a" {
    "[0-9a-fA-F]" => ()
    _ => fail("Should match hex digit a")
  }
  lexmatch "F" {
    "[0-9a-fA-F]" => ()
    _ => fail("Should match hex digit F")
  }
  lexmatch "g" {
    "[0-9a-fA-F]" => fail("Should not match g")
    _ => ()
  }
}

///|
test "[0-9a-fA-F]+ - hex number sequence" {
  lexmatch "1a2B3c" {
    "[0-9a-fA-F]+" => ()
    _ => fail("Should match hex sequence")
  }
  lexmatch "DEADBEEF" {
    "[0-9a-fA-F]+" => ()
    _ => fail("Should match hex constant")
  }
}

///|
test "[^a-zA-Z] - not a letter" {
  lexmatch "5" {
    "[^a-zA-Z]" => ()
    _ => fail("Should match digit")
  }
  lexmatch "_" {
    "[^a-zA-Z]" => ()
    _ => fail("Should match underscore")
  }
  lexmatch "a" {
    "[^a-zA-Z]" => fail("Should not match letter")
    _ => ()
  }
}

///|
test "[[:digit:]][[:digit:]][[:digit:]] - exactly three digits" {
  lexmatch "123" {
    "[[:digit:]][[:digit:]][[:digit:]]" => ()
    _ => fail("Should match three digits")
  }
  lexmatch "12" {
    "[[:digit:]][[:digit:]][[:digit:]]" => fail("Should not match two digits")
    _ => ()
  }
}

///|
test "[[:word:]][[:digit:]][[:word:]] - word-digit-word pattern" {
  lexmatch "a5b" {
    "[[:word:]][[:digit:]][[:word:]]" => ()
    _ => fail("Should match pattern")
  }
  lexmatch "_9Z" {
    "[[:word:]][[:digit:]][[:word:]]" => ()
    _ => fail("Should match with underscore and uppercase")
  }
}

///|
test "[[:digit:]a-f]+ - hex lowercase with digits" {
  lexmatch "12ab" {
    "[[:digit:]a-f]+" => ()
    _ => fail("Should match hex lowercase")
  }
  lexmatch "ff00" {
    "[[:digit:]a-f]+" => ()
    _ => fail("Should match hex number")
  }
  lexmatch "12AB" {
    "[[:digit:]a-f]+" => fail("Should not match uppercase hex")
    _ => ()
  }
}

///|
test "[[:space:]]|[^[:space:]] - any character (whitespace or non-whitespace)" {
  lexmatch "a" {
    "[[:space:]]|[^[:space:]]" => ()
    _ => fail("Should match letter")
  }
  lexmatch " " {
    "[[:space:]]|[^[:space:]]" => ()
    _ => fail("Should match space")
  }
  lexmatch "\n" {
    "[[:space:]]|[^[:space:]]" => ()
    _ => fail("Should match newline")
  }
}

///|
test "[[:digit:]|[^[:digit:]] - any character (digit or non-digit)" {
  lexmatch "5" {
    "[[:digit:]]|[^[:digit:]]" => ()
    _ => fail("Should match digit")
  }
  lexmatch "x" {
    "[[:digit:]]|[^[:digit:]]" => ()
    _ => fail("Should match non-digit")
  }
}

///|
test "[[:word:]|[^[:word:]] - any character (word or non-word)" {
  lexmatch "a" {
    "[[:word:]]|[^[:word:]]" => ()
    _ => fail("Should match word char")
  }
  lexmatch "!" {
    "[[:word:]]|[^[:word:]]" => ()
    _ => fail("Should match non-word char")
  }
}

///|
test "[^[:space:]]+ - non-whitespace sequence" {
  lexmatch "hello" {
    "[^[:space:]]+" => ()
    _ => fail("Should match word without spaces")
  }
  lexmatch "a1b2c3" {
    "[^[:space:]]+" => ()
    _ => fail("Should match alphanumeric")
  }
}

///|
test "[^[:digit:]]+ - non-digit sequence" {
  lexmatch "abc" {
    "[^[:digit:]]+" => ()
    _ => fail("Should match letters")
  }
  lexmatch "   " {
    "[^[:digit:]]+" => ()
    _ => fail("Should match spaces")
  }
}

///|
test "[^[:word:]]+ - non-word character sequence" {
  lexmatch "   " {
    "[^[:word:]]+" => ()
    _ => fail("Should match spaces")
  }
  lexmatch "!@#" {
    "[^[:word:]]+" => ()
    _ => fail("Should match punctuation")
  }
}

///|
test "[a-zA-Z0-9_] - equivalent to [[:word:]]" {
  lexmatch "a" {
    "[a-zA-Z0-9_]" => ()
    _ => fail("Should match lowercase")
  }
  lexmatch "Z" {
    "[a-zA-Z0-9_]" => ()
    _ => fail("Should match uppercase")
  }
  lexmatch "5" {
    "[a-zA-Z0-9_]" => ()
    _ => fail("Should match digit")
  }
  lexmatch "_" {
    "[a-zA-Z0-9_]" => ()
    _ => fail("Should match underscore")
  }
}

///|
test "[ \\t\\r\\n] - equivalent to [[:space:]]" {
  lexmatch " " {
    "[ \t\r\n]" => ()
    _ => fail("Should match space")
  }
  lexmatch "\t" {
    "[ \t\r\n]" => ()
    _ => fail("Should match tab")
  }
  lexmatch "\r" {
    "[ \t\r\n]" => ()
    _ => fail("Should match carriage return")
  }
  lexmatch "\n" {
    "[ \t\r\n]" => ()
    _ => fail("Should match newline")
  }
}

///|
test "[0-9] - equivalent to [[:digit:]]" {
  lexmatch "0" {
    "[0-9]" => ()
    _ => fail("Should match 0")
  }
  lexmatch "5" {
    "[0-9]" => ()
    _ => fail("Should match 5")
  }
  lexmatch "9" {
    "[0-9]" => ()
    _ => fail("Should match 9")
  }
}

///|
test "[[:space:]]*[[:word:]]+[[:space:]]* - word with optional surrounding whitespace" {
  lexmatch "hello" {
    "[[:space:]]*[[:word:]]+[[:space:]]*" => ()
    _ => fail("Should match word without spaces")
  }
  lexmatch " hello " {
    "[[:space:]]*[[:word:]]+[[:space:]]*" => ()
    _ => fail("Should match word with spaces")
  }
  lexmatch "test" {
    "[[:space:]]*[[:word:]]+[[:space:]]*" => ()
    _ => fail("Should match word")
  }
}

///|
test "[[:digit:]]+\\.[[:digit:]]+ - decimal number pattern" {
  lexmatch "3.14" {
    "[[:digit:]]+\.[[:digit:]]+" => ()
    _ => fail("Should match decimal")
  }
  lexmatch "123.456" {
    "[[:digit:]]+\.[[:digit:]]+" => ()
    _ => fail("Should match multi-digit decimal")
  }
}

///|
test "[+\\-]?[[:digit:]]+ - optional sign with digits" {
  lexmatch "123" {
    "[+\-]?[[:digit:]]+" => ()
    _ => fail("Should match unsigned number")
  }
  lexmatch "+123" {
    "[+\-]?[[:digit:]]+" => ()
    _ => fail("Should match positive number")
  }
  lexmatch "-456" {
    "[+\-]?[[:digit:]]+" => ()
    _ => fail("Should match negative number")
  }
}

///|
test "[[:space:]]+[a-zA-Z]+[[:space:]]+ - word surrounded by whitespace" {
  lexmatch " hello " {
    "[[:space:]]+[a-zA-Z]+[[:space:]]+" => ()
    _ => fail("Should match word with spaces")
  }
  lexmatch "\tworld\n" {
    "[[:space:]]+[a-zA-Z]+[[:space:]]+" => ()
    _ => fail("Should match word with tab and newline")
  }
}

///|
test "[a-z][a-z0-9]* - identifier starting with lowercase" {
  lexmatch "var" {
    "[a-z][a-z0-9]*" => ()
    _ => fail("Should match lowercase identifier")
  }
  lexmatch "test123" {
    "[a-z][a-z0-9]*" => ()
    _ => fail("Should match identifier with numbers")
  }
}

///|
test "[A-Z][a-zA-Z0-9]* - identifier starting with uppercase" {
  lexmatch "MyClass" {
    "[A-Z][a-zA-Z0-9]*" => ()
    _ => fail("Should match class name")
  }
  lexmatch "Test123Value" {
    "[A-Z][a-zA-Z0-9]*" => ()
    _ => fail("Should match mixed case identifier")
  }
}

///|
test "[a-zA-Z_][a-zA-Z0-9_]* - full identifier pattern" {
  lexmatch "variable" {
    "[a-zA-Z_][a-zA-Z0-9_]*" => ()
    _ => fail("Should match variable name")
  }
  lexmatch "_private" {
    "[a-zA-Z_][a-zA-Z0-9_]*" => ()
    _ => fail("Should match identifier starting with underscore")
  }
  lexmatch "my_var_123" {
    "[a-zA-Z_][a-zA-Z0-9_]*" => ()
    _ => fail("Should match snake_case identifier")
  }
}

///|
test "[[:digit:]]{1,3}\\.[[:digit:]]{1,3}\\.[[:digit:]]{1,3}\\.[[:digit:]]{1,3} - IP address pattern" {
  lexmatch "192.168.1.1" {
    "[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}" =>
      ()
    _ => fail("Should match IP address")
  }
  lexmatch "0.0.0.0" {
    "[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}" =>
      ()
    _ => fail("Should match zero IP")
  }
}

///|
test "[[:digit:]a-fA-F]{2}:[[:digit:]a-fA-F]{2} - hex byte pair pattern" {
  lexmatch "FF:00" {
    "[[:digit:]a-fA-F]{2}:[[:digit:]a-fA-F]{2}" => ()
    _ => fail("Should match hex byte pair")
  }
  lexmatch "12:ab" {
    "[[:digit:]a-fA-F]{2}:[[:digit:]a-fA-F]{2}" => ()
    _ => fail("Should match lowercase hex pair")
  }
}

///|
test "[[:word:]]+@[[:word:]]+\\.[[:word:]]+ - simple email pattern" {
  lexmatch "user@example.com" {
    "[[:word:]]+@[[:word:]]+\.[[:word:]]+" => ()
    _ => fail("Should match simple email")
  }
  lexmatch "test123@domain.org" {
    "[[:word:]]+@[[:word:]]+\.[[:word:]]+" => ()
    _ => fail("Should match email with numbers")
  }
}

///|
test "[a-z]+[0-9]+ - letters followed by numbers" {
  lexmatch "abc123" {
    "[a-z]+[0-9]+" => ()
    _ => fail("Should match pattern")
  }
  lexmatch "test99" {
    "[a-z]+[0-9]+" => ()
    _ => fail("Should match variable with number suffix")
  }
}

///|
test "[0-9]+[a-z]+ - numbers followed by letters" {
  lexmatch "123abc" {
    "[0-9]+[a-z]+" => ()
    _ => fail("Should match pattern")
  }
  lexmatch "42test" {
    "[0-9]+[a-z]+" => ()
    _ => fail("Should match number prefix")
  }
}

///|
test "[[:digit:]]+[eE][+\\-]?[[:digit:]]+ - scientific notation exponent" {
  lexmatch "123e10" {
    "[[:digit:]]+[eE][+\-]?[[:digit:]]+" => ()
    _ => fail("Should match exponent")
  }
  lexmatch "5E+3" {
    "[[:digit:]]+[eE][+\-]?[[:digit:]]+" => ()
    _ => fail("Should match positive exponent")
  }
  lexmatch "2e-5" {
    "[[:digit:]]+[eE][+\-]?[[:digit:]]+" => ()
    _ => fail("Should match negative exponent")
  }
}

///|
test "[[:word:]\\-]+ - word characters and hyphens" {
  lexmatch "hello-world" {
    "[[:word:]\-]+" => ()
    _ => fail("Should match hyphenated word")
  }
  lexmatch "test_value-123" {
    "[[:word:]\-]+" => ()
    _ => fail("Should match complex identifier")
  }
}

///|
test "[[:word:]\\.]+ - word characters and dots" {
  lexmatch "file.txt" {
    "[[:word:]\.]+" => ()
    _ => fail("Should match filename")
  }
  lexmatch "my.package.name" {
    "[[:word:]\.]+" => ()
    _ => fail("Should match package name")
  }
}

///|
test "[[:digit:],]+ - digits and commas" {
  lexmatch "1,234,567" {
    "[[:digit:],]+" => ()
    _ => fail("Should match formatted number")
  }
  lexmatch "1000" {
    "[[:digit:],]+" => ()
    _ => fail("Should match plain number")
  }
}

///|
test "[[:space:]]*[+\\-*/][[:space:]]* - operator with optional spaces" {
  lexmatch "+" {
    "[[:space:]]*[+\-*/][[:space:]]*" => ()
    _ => fail("Should match plus")
  }
  lexmatch " - " {
    "[[:space:]]*[+\-*/][[:space:]]*" => ()
    _ => fail("Should match minus with spaces")
  }
  lexmatch "*" {
    "[[:space:]]*[+\-*/][[:space:]]*" => ()
    _ => fail("Should match multiply")
  }
  lexmatch "  /  " {
    "[[:space:]]*[+\-*/][[:space:]]*" => ()
    _ => fail("Should match divide with spaces")
  }
}
