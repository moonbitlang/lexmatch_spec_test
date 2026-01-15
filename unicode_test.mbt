// Unicode tests - matching Unicode literals, escapes, and ASCII-only classes

///|
test "Unicode - literal CJK match" {
  lexmatch "你好" {
    "你好" => ()
    _ => fail("Should match literal CJK characters")
  }
}

///|
test "Unicode - mixed ASCII and CJK" {
  lexmatch "hello世界" {
    ("hello" "世界") => ()
    _ => fail("Should match mixed ASCII and Unicode")
  }
}

///|
test "Unicode - \\u escape BMP" {
  lexmatch "你" {
    "\u4F60" => ()
    _ => fail("Should match U+4F60")
  }
}

///|
test "Unicode - \\u{...} escape non-BMP" {
  lexmatch "🧪" {
    "\u{1F9EA}" => ()
    _ => fail("Should match U+1F9EA")
  }
}

///|
test "Unicode - dot matches one codepoint" {
  lexmatch "汉" {
    "." => ()
    _ => fail("Dot should match a Unicode character")
  }
}

///|
test "Unicode - character class literals" {
  lexmatch "界" {
    "[你好界]" => ()
    _ => fail("Should match Unicode class literal")
  }
  lexmatch "你" {
    "[界]" => fail("Should not match non-member")
    _ => ()
  }
}

///|
test "Unicode - capture with rest" {
  lexmatch "你好世界" {
    ("你好" as greeting, rest) =>
      if greeting.to_string() == "你好" && rest.to_string() == "世界" {
        ()
      } else {
        fail("Should capture greeting and rest")
      }
    _ => fail("Should match")
  }
}

///|
test "Unicode - ASCII classes exclude non-ASCII" {
  lexmatch "é" {
    "[[:alpha:]]" => fail("ASCII alpha should not match é")
    _ => ()
  }
  lexmatch "你" {
    "[[:word:]]" => fail("ASCII word should not match CJK")
    _ => ()
  }
}

///|
test "Unicode - [[:ascii:]] only matches ASCII" {
  lexmatch "A" {
    "[[:ascii:]]" => ()
    _ => fail("Should match ASCII letter")
  }
  lexmatch "😀" {
    "[[:ascii:]]" => fail("Should not match emoji")
    _ => ()
  }
}
