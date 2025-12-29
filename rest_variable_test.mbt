// Rest variable tests - testing patterns with rest variables and longest matching

///|
test "Simple rest variable" {
  lexmatch "hello world" {
    ("hello", rest) =>
      if rest.to_string() == " world" {
        ()
      } else {
        fail("Rest should be ' world'")
      }
    _ => fail("Should match")
  }
}

///|
test "Rest variable with longest match" {
  lexmatch "abc123" with longest {
    ("[a-z]+", rest) =>
      if rest.to_string() == "123" {
        ()
      } else {
        fail("Rest should be '123'")
      }
    _ => fail("Should match")
  }
}

///|
test "Empty rest variable" {
  lexmatch "test" {
    ("test", rest) =>
      if rest.to_string() == "" {
        ()
      } else {
        fail("Rest should be empty")
      }
    _ => fail("Should match")
  }
}

///|
test "Digit prefix with rest" {
  lexmatch "123abc" with longest {
    ("[[:digit:]]+", rest) =>
      if rest.to_string() == "abc" {
        ()
      } else {
        fail("Rest should be 'abc'")
      }
    _ => fail("Should match")
  }
}

///|
test "Word prefix with rest" {
  lexmatch "hello123" with longest {
    ("[[:word:]]+", rest) =>
      if rest.to_string() == "" {
        ()
      } else {
        fail("[[:word:]]+ should match everything")
      }
    _ => fail("Should match")
  }
}

///|
test "Whitespace prefix with rest" {
  lexmatch "   text" with longest {
    ("[[:space:]]+", rest) =>
      if rest.to_string() == "text" {
        ()
      } else {
        fail("Rest should be 'text'")
      }
    _ => fail("Should match")
  }
}

///|
test "Single character with rest" {
  lexmatch "abcdef" {
    (".", rest) =>
      if rest.to_string() == "bcdef" {
        ()
      } else {
        fail("Rest should be 'bcdef'")
      }
    _ => fail("Should match")
  }
}

///|
test "Multiple character pattern with rest" {
  lexmatch "abcdef" {
    ("abc", rest) =>
      if rest.to_string() == "def" {
        ()
      } else {
        fail("Rest should be 'def'")
      }
    _ => fail("Should match")
  }
}

///|
test "Newline prefix with rest" {
  lexmatch "\nhello" {
    ("\n", rest) =>
      if rest.to_string() == "hello" {
        ()
      } else {
        fail("Rest should be 'hello'")
      }
    _ => fail("Should match")
  }
}

///|
test "URL protocol with rest" {
  lexmatch "https://example.com" with longest {
    ("[a-z]+://", rest) =>
      if rest.to_string() == "example.com" {
        ()
      } else {
        fail("Rest should be 'example.com'")
      }
    _ => fail("Should match")
  }
}

///|
test "Comment marker with rest" {
  lexmatch "// comment text" {
    ("//", rest) =>
      if rest.to_string() == " comment text" {
        ()
      } else {
        fail("Rest should be ' comment text'")
      }
    _ => fail("Should match")
  }
}

///|
test "Hash prefix with rest" {
  lexmatch "#FF00AA" {
    ("#", rest) =>
      if rest.to_string() == "FF00AA" {
        ()
      } else {
        fail("Rest should be 'FF00AA'")
      }
    _ => fail("Should match")
  }
}

///|
test "At sign with rest" {
  lexmatch "@username" {
    ("@", rest) =>
      if rest.to_string() == "username" {
        ()
      } else {
        fail("Rest should be 'username'")
      }
    _ => fail("Should match")
  }
}

///|
test "Underscore wildcard with rest" {
  lexmatch "test123" {
    ("test", _) => ()
    _ => fail("Should match with underscore rest")
  }
}

///|
test "Character class with rest" {
  lexmatch "abc123" with longest {
    ("[a-z]+", rest) =>
      if rest.to_string() == "123" {
        ()
      } else {
        fail("Rest should be '123'")
      }
    _ => fail("Should match")
  }
}

///|
test "Digit class with rest" {
  lexmatch "123abc" with longest {
    ("[[:digit:]]+", rest) =>
      if rest.to_string() == "abc" {
        ()
      } else {
        fail("Rest should be 'abc'")
      }
    _ => fail("Should match")
  }
}

///|
test "Non-whitespace with rest" {
  lexmatch "word space" with longest {
    ("[^[:space:]]+", rest) =>
      if rest.to_string() == " space" {
        ()
      } else {
        fail("Rest should be ' space'")
      }
    _ => fail("Should match")
  }
}

///|
test "Quantifier with rest" {
  lexmatch "aaabbb" with longest {
    ("a+", rest) =>
      if rest.to_string() == "bbb" {
        ()
      } else {
        fail("Rest should be 'bbb'")
      }
    _ => fail("Should match")
  }
}

///|
test "Exact count with rest" {
  lexmatch "12345" {
    ("[[:digit:]]{3}", rest) =>
      if rest.to_string() == "45" {
        ()
      } else {
        fail("Rest should be '45'")
      }
    _ => fail("Should match")
  }
}

///|
test "Optional pattern with rest" {
  lexmatch "abc" {
    ("a?", rest) =>
      if rest.to_string() == "bc" {
        ()
      } else {
        fail("Rest should be 'bc'")
      }
    _ => fail("Should match")
  }
}

///|
test "Zero or more with rest" {
  lexmatch "aaab" with longest {
    ("a*", rest) =>
      if rest.to_string() == "b" {
        ()
      } else {
        fail("Rest should be 'b'")
      }
    _ => fail("Should match")
  }
}

///|
test "Dot star with rest - matches all" {
  lexmatch "anything" with longest {
    (".*", rest) =>
      if rest.to_string() == "" {
        ()
      } else {
        fail("Rest should be empty after .*")
      }
    _ => fail("Should match")
  }
}

///|
test "Line processing with rest" {
  lexmatch "line1\nline2" {
    ("[^\n]+", rest) =>
      if rest.to_string() == "\nline2" {
        ()
      } else {
        fail("Rest should be '\\nline2'")
      }
    _ => fail("Should match")
  }
}

///|
test "Token extraction with rest" {
  lexmatch "token1 token2 token3" with longest {
    ("[[:word:]]+", rest) =>
      if rest.to_string() == " token2 token3" {
        ()
      } else {
        fail("Rest should be ' token2 token3'")
      }
    _ => fail("Should match")
  }
}

///|
test "Number extraction with rest" {
  lexmatch "123.456.789" with longest {
    ("[[:digit:]]+", rest) =>
      if rest.to_string() == ".456.789" {
        ()
      } else {
        fail("Rest should be '.456.789'")
      }
    _ => fail("Should match")
  }
}

///|
test "Path component with rest" {
  lexmatch "/usr/local/bin" {
    ("/", rest) =>
      if rest.to_string() == "usr/local/bin" {
        ()
      } else {
        fail("Rest should be 'usr/local/bin'")
      }
    _ => fail("Should match")
  }
}

///|
test "Prefix match with rest" {
  lexmatch "prefix_suffix" with longest {
    ("[a-z]+_", rest) =>
      if rest.to_string() == "suffix" {
        ()
      } else {
        fail("Rest should be 'suffix'")
      }
    _ => fail("Should match")
  }
}

///|
test "Bracket prefix with rest" {
  lexmatch "[content]" {
    ("\[", rest) =>
      if rest.to_string() == "content]" {
        ()
      } else {
        fail("Rest should be 'content]'")
      }
    _ => fail("Should match")
  }
}

///|
test "Paren prefix with rest" {
  lexmatch "(args)" {
    ("\(", rest) =>
      if rest.to_string() == "args)" {
        ()
      } else {
        fail("Rest should be 'args)'")
      }
    _ => fail("Should match")
  }
}

///|
test "Quote prefix with rest" {
  lexmatch "\"quoted\"" {
    ("\"", rest) =>
      if rest.to_string() == "quoted\"" {
        ()
      } else {
        fail("Rest should be 'quoted\"'")
      }
    _ => fail("Should match")
  }
}

///|
test "Escaped character with rest" {
  lexmatch "\\n text" {
    ("\\", rest) =>
      if rest.to_string() == "n text" {
        ()
      } else {
        fail("Rest should be 'n text'")
      }
    _ => fail("Should match")
  }
}

///|
test "Multiple patterns branching with rest" {
  lexmatch "hello world" with longest {
    ("hello", rest) =>
      if rest.to_string() == " world" {
        ()
      } else {
        fail("Should match first branch")
      }
    ("hi", _rest) => fail("Should not match second branch")
    _ => fail("Should match first branch")
  }
}

///|
test "Iterative tokenization simulation" {
  lexmatch "a b c" with longest {
    ("[[:word:]]", rest) =>
      // First token 'a', rest ' b c'
      lexmatch rest with longest {
        ("[[:space:]]", rest2) =>
          // Skip space, rest2 'b c'
          lexmatch rest2 with longest {
            ("[[:word:]]", rest3) =>
              // Second token 'b', rest3 ' c'
              if rest3.to_string() == " c" {
                ()
              } else {
                fail("Rest3 should be ' c'")
              }
            _ => fail("Should match third pattern")
          }
        _ => fail("Should match second pattern")
      }
    _ => fail("Should match first pattern")
  }
}

///|
test "Longest match behavior - greedy quantifier" {
  lexmatch "aaaaa" with longest {
    ("a+", rest) =>
      // Should consume all a's with longest match
      if rest.to_string() == "" {
        ()
      } else {
        fail("Should match all a's")
      }
    _ => fail("Should match")
  }
}

///|
test "Longest match - character class" {
  lexmatch "12345abc" with longest {
    ("[[:digit:]]+", rest) =>
      if rest.to_string() == "abc" {
        ()
      } else {
        fail("Should match all digits")
      }
    _ => fail("Should match")
  }
}

///|
test "Capture and rest combination" {
  lexmatch "hello world" with longest {
    ("[a-z]+" as word, rest) =>
      if word.to_string() == "hello" && rest.to_string() == " world" {
        ()
      } else {
        fail("Should capture 'hello' and rest ' world'")
      }
    _ => fail("Should match")
  }
}

///|
test "Multiple captures with rest" {
  lexmatch "123abc" with longest {
    (("[[:digit:]]+" as num) ("[a-z]+" as letters), rest) =>
      if num.to_string() == "123" &&
        letters.to_string() == "abc" &&
        rest.to_string() == "" {
        ()
      } else {
        fail("Should capture both and have empty rest")
      }
    _ => fail("Should match")
  }
}

///|
test "Rest after sequence pattern" {
  lexmatch "http://test" {
    (("http" "://") as prefix, rest) =>
      if prefix.to_string() == "http://" && rest.to_string() == "test" {
        ()
      } else {
        fail("Should capture prefix and rest")
      }
    _ => fail("Should match")
  }
}

///|
test "Nested lexmatch with rest" {
  lexmatch "first second" with longest {
    ("[[:word:]]+", rest) =>
      lexmatch rest with longest {
        ("[[:space:]]+", rest2) =>
          lexmatch rest2 with longest {
            ("[[:word:]]+", rest3) =>
              if rest3.to_string() == "" {
                ()
              } else {
                fail("Final rest should be empty")
              }
            _ => fail("Should match")
          }
        _ => fail("Should match")
      }
    _ => fail("Should match")
  }
}

///|
test "Rest with special characters" {
  lexmatch "!@#$%^&*()" {
    ("!", rest) =>
      if rest.to_string() == "@#$%^&*()" {
        ()
      } else {
        fail("Rest should contain special chars")
      }
    _ => fail("Should match")
  }
}

///|
test "Rest with newlines" {
  lexmatch "line1\nline2\nline3" {
    ("[^\n]+", rest) =>
      if rest.to_string() == "\nline2\nline3" {
        ()
      } else {
        fail("Rest should contain newlines and remaining lines")
      }
    _ => fail("Should match")
  }
}

///|
test "Rest with tabs" {
  lexmatch "word\ttab\tdata" with longest {
    ("[[:word:]]+", rest) =>
      if rest.to_string() == "\ttab\tdata" {
        ()
      } else {
        fail("Rest should contain tabs")
      }
    _ => fail("Should match")
  }
}

///|
test "Empty prefix with rest" {
  lexmatch "test" {
    ("", rest) =>
      if rest.to_string() == "test" {
        ()
      } else {
        fail("Rest should be entire string")
      }
    _ => fail("Should match")
  }
}

///|
test "Range quantifier with rest" {
  lexmatch "aaaaaabbb" with longest {
    ("a{3,5}", rest) =>
      // Should match 5 a's (longest within range)
      if rest.to_string() == "abbb" {
        ()
      } else {
        fail("Rest should be 'abbb'")
      }
    _ => fail("Should match")
  }
}

///|
test "Non-greedy simulation with explicit pattern" {
  lexmatch "aaabbb" {
    ("aaa", rest) =>
      if rest.to_string() == "bbb" {
        ()
      } else {
        fail("Rest should be 'bbb'")
      }
    _ => fail("Should match")
  }
}

///|
test "Word boundary simulation with rest" {
  lexmatch "word1 word2" with longest {
    ("[[:word:]]+", rest) =>
      if rest.to_string() == " word2" {
        ()
      } else {
        fail("Rest should be ' word2'")
      }
    _ => fail("Should match")
  }
}

///|
test "Mixed character classes with rest" {
  lexmatch "abc123!@#" with longest {
    ("[[:word:]]+", rest) =>
      if rest.to_string() == "!@#" {
        ()
      } else {
        fail("Rest should be '!@#'")
      }
    _ => fail("Should match")
  }
}
