// Complex pattern tests - real-world tokenizers, parsers, and multi-stage matching

///|
test "Tokenizer - extract first number" {
  let expr = "123 + 456"
  lexmatch expr with longest {
    (("\d+" as num), _rest) => {
      if num == "123" {
        ()
      } else {
        fail("Should extract first number")
      }
    }
    _ => fail("Should match")
  }
}

///|
test "Tokenizer - extract keyword" {
  let code = "let x = 42"
  lexmatch code with longest {
    ("(?i:let)" as keyword, _rest) => {
      if keyword == "let" {
        ()
      } else {
        fail("Should extract keyword")
      }
    }
    _ => fail("Should match")
  }
}

///|
test "Tokenizer - extract function name" {
  let call = "print(123)"
  lexmatch call with longest {
    (("\w+" as func), _rest) => {
      if func == "print" {
        ()
      } else {
        fail("Should extract function")
      }
    }
    _ => fail("Should match")
  }
}

///|
test "Parser - extract JSON key" {
  let json = "\"name\": \"John\""
  lexmatch json with longest {
    ((("\"" "\w+" "\"") as key), _rest) => {
      if key == "\"name\"" {
        ()
      } else {
        fail("Should extract key")
      }
    }
    _ => fail("Should match")
  }
}

///|
test "Parser - extract HTML tag" {
  let tag = "<div>"
  lexmatch tag with longest {
    ((("<" "\w+" ">") as fulltag), _rest) => {
      if fulltag == "<div>" {
        ()
      } else {
        fail("Should match tag")
      }
    }
    _ => fail("Should match")
  }
}

///|
test "Parser - extract CSS property" {
  let css = "color: red"
  lexmatch css with longest {
    (("\w+" as prop), _rest) => {
      if prop == "color" {
        ()
      } else {
        fail("Should extract property")
      }
    }
    _ => fail("Should match")
  }
}

///|
test "Tokenizer - extract SQL keyword" {
  let sql = "SELECT name"
  lexmatch sql with longest {
    ("(?i:select)" as keyword, _rest) => {
      if keyword == "SELECT" {
        ()
      } else {
        fail("Should extract SELECT")
      }
    }
    _ => fail("Should match")
  }
}

///|
test "Parser - extract import keyword" {
  let code = "import func"
  lexmatch code with longest {
    ("(?i:import)" as keyword, _rest) => {
      if keyword == "import" {
        ()
      } else {
        fail("Should extract import")
      }
    }
    _ => fail("Should match")
  }
}

///|
test "Tokenizer - extract name from email format" {
  let email = "John Doe <user@example.com>"
  lexmatch email with longest {
    ((("\w+" "\s" "\w+") as name), _rest) => {
      if name == "John Doe" {
        ()
      } else {
        fail("Should extract name")
      }
    }
    _ => fail("Should match")
  }
}

///|
test "Parser - extract domain from URL" {
  let url = "http://example.com/page"
  lexmatch url with longest {
    ((("[a-z]+" "://" "\w+" "\." "\w+") as domain), _rest) => {
      if domain == "http://example.com" {
        ()
      } else {
        fail("Should match domain")
      }
    }
    _ => fail("Should match")
  }
}

///|
test "Tokenizer - extract date from log" {
  let log = "[2024-01-15] INFO"
  lexmatch log with longest {
    ((("\[" "\d{4}" "-" "\d{2}" "-" "\d{2}" "\]") as date), _rest) => {
      if date == "[2024-01-15]" {
        ()
      } else {
        fail("Should extract date")
      }
    }
    _ => fail("Should match")
  }
}

///|
test "Parser - extract function declaration" {
  let sig = "fn add(x: Int)"
  lexmatch sig with longest {
    ((("(?i:fn)" "\s+" "\w+") as fn_decl), _rest) => {
      if fn_decl == "fn add" {
        ()
      } else {
        fail("Should extract function")
      }
    }
    _ => fail("Should match")
  }
}

///|
test "Tokenizer - extract export statement" {
  let env = "export PATH=/usr"
  lexmatch env with longest {
    ((("(?i:export)" "\s+" "\w+") as export_stmt), _rest) => {
      if export_stmt == "export PATH" {
        ()
      } else {
        fail("Should match export")
      }
    }
    _ => fail("Should match")
  }
}

///|
test "Parser - extract package name" {
  let req = "package@1.2.3"
  lexmatch req with longest {
    (("\w+" as pkg), _rest) => {
      if pkg == "package" {
        ()
      } else {
        fail("Should extract package")
      }
    }
    _ => fail("Should match")
  }
}

///|
test "Tokenizer - extract commit type" {
  let commit = "feat: add feature"
  lexmatch commit with longest {
    (("\w+" as ctype), _rest) => {
      if ctype == "feat" {
        ()
      } else {
        fail("Should extract type")
      }
    }
    _ => fail("Should match")
  }
}

///|
test "Parser - extract markdown link" {
  let link = "[GitHub](url)"
  lexmatch link with longest {
    ((("\[" "\w+" "\]") as text), _rest) => {
      if text == "[GitHub]" {
        ()
      } else {
        fail("Should extract text")
      }
    }
    _ => fail("Should match")
  }
}

///|
test "Tokenizer - extract docker command" {
  let cmd = "docker run nginx"
  lexmatch cmd with longest {
    ((("(?i:docker)" "\s+" "\w+") as docker_cmd), _rest) => {
      if docker_cmd == "docker run" {
        ()
      } else {
        fail("Should match docker")
      }
    }
    _ => fail("Should match")
  }
}

///|
test "Parser - extract HTTP version" {
  let status = "HTTP/1.1 200"
  lexmatch status with longest {
    ((("HTTP/" "\d" "\." "\d") as version), _rest) => {
      if version == "HTTP/1.1" {
        ()
      } else {
        fail("Should match version")
      }
    }
    _ => fail("Should match")
  }
}

///|
test "Tokenizer - extract cron field" {
  let cron = "0 0 * * *"
  lexmatch cron with longest {
    (("\d+" as minutes), _rest) => {
      if minutes == "0" {
        ()
      } else {
        fail("Should extract minutes")
      }
    }
    _ => fail("Should match")
  }
}

///|
test "Parser - extract YAML key" {
  let yaml = "name: value"
  lexmatch yaml with longest {
    (("\w+" as key), _rest) => {
      if key == "name" {
        ()
      } else {
        fail("Should extract key")
      }
    }
    _ => fail("Should match")
  }
}

///|
test "Tokenizer - extract shebang path" {
  let shebang = "#!/usr/bin/python"
  lexmatch shebang with longest {
    ((("#!" "/" "\w+" "/" "\w+") as path), _rest) => {
      if path == "#!/usr/bin" {
        ()
      } else {
        fail("Should match path")
      }
    }
    _ => fail("Should match")
  }
}

///|
test "Parser - extract method access" {
  let call = "obj.method()"
  lexmatch call with longest {
    ((("\w+" "\." "\w+") as access), _rest) => {
      if access == "obj.method" {
        ()
      } else {
        fail("Should match method")
      }
    }
    _ => fail("Should match")
  }
}

///|
test "Tokenizer - extract IP address" {
  let addr = "192.168.1.1:8080"
  lexmatch addr with longest {
    ((("\d{1,3}" "\." "\d{1,3}" "\." "\d{1,3}" "\." "\d{1,3}") as ip), _rest) => {
      if ip == "192.168.1.1" {
        ()
      } else {
        fail("Should extract IP")
      }
    }
    _ => fail("Should match")
  }
}

///|
test "Parser - extract version number" {
  let ver = "v1.2.3-alpha"
  lexmatch ver with longest {
    ((("v?" "\d+" "\." "\d+" "\." "\d+") as version), _rest) => {
      if version == "v1.2.3" {
        ()
      } else {
        fail("Should extract version")
      }
    }
    _ => fail("Should match")
  }
}

///|
test "Tokenizer - extract currency code" {
  let price = "USD $99.99"
  lexmatch price with longest {
    (("[A-Z]{3}" as currency), _rest) => {
      if currency == "USD" {
        ()
      } else {
        fail("Should extract currency")
      }
    }
    _ => fail("Should match")
  }
}

///|
test "Parser - extract time from range" {
  let range = "09:00-17:30"
  lexmatch range with longest {
    ((("\d{2}" ":" "\d{2}") as start), _rest) => {
      if start == "09:00" {
        ()
      } else {
        fail("Should extract time")
      }
    }
    _ => fail("Should match")
  }
}

///|
test "Tokenizer - extract file size" {
  let size = "1.5 GB"
  lexmatch size with longest {
    ((("\d+" "\." "\d+") as num), _rest) => {
      if num == "1.5" {
        ()
      } else {
        fail("Should extract size")
      }
    }
    _ => fail("Should match")
  }
}

///|
test "Parser - extract user mention" {
  let mention = "@username text"
  lexmatch mention with longest {
    ((("@" "\w+") as user), _rest) => {
      if user == "@username" {
        ()
      } else {
        fail("Should extract mention")
      }
    }
    _ => fail("Should match")
  }
}

///|
test "Tokenizer - extract hashtag" {
  let tag = "#programming text"
  lexmatch tag with longest {
    ((("#" "\w+") as hashtag), _rest) => {
      if hashtag == "#programming" {
        ()
      } else {
        fail("Should extract hashtag")
      }
    }
    _ => fail("Should match")
  }
}

///|
test "Parser - extract temperature" {
  let temp = "25.5°C"
  lexmatch temp with longest {
    ((("\d+" "\." "\d+") as val), _rest) => {
      if val == "25.5" {
        ()
      } else {
        fail("Should extract temp")
      }
    }
    _ => fail("Should match")
  }
}

///|
test "Tokenizer - extract IPv6 prefix" {
  let ipv6 = "2001:db8::1"
  lexmatch ipv6 with longest {
    ((("[\da-f]+" ":" "[\da-f]+") as prefix), _rest) => {
      if prefix == "2001:db8" {
        ()
      } else {
        fail("Should extract prefix")
      }
    }
    _ => fail("Should match")
  }
}

///|
test "Parser - extract WHERE keyword" {
  let where_ = "WHERE age > 18"
  lexmatch where_ with longest {
    ("(?i:where)" as keyword, _rest) => {
      if keyword == "WHERE" {
        ()
      } else {
        fail("Should match WHERE")
      }
    }
    _ => fail("Should match")
  }
}

///|
test "Tokenizer - extract constructor" {
  let ctor = "new Person()"
  lexmatch ctor with longest {
    ((("(?i:new)" "\s+" "\w+") as new_stmt), _rest) => {
      if new_stmt == "new Person" {
        ()
      } else {
        fail("Should match new")
      }
    }
    _ => fail("Should match")
  }
}

///|
test "Parser - extract code fence" {
  let fence = "```javascript"
  lexmatch fence with longest {
    ((("```" "\w+") as lang), _rest) => {
      if lang == "```javascript" {
        ()
      } else {
        fail("Should match fence")
      }
    }
    _ => fail("Should match")
  }
}

///|
test "Tokenizer - extract arrow function" {
  let lambda = "() => x"
  lexmatch lambda with longest {
    ((("\(" "\)" "\s*" "=>") as arrow), _rest) => {
      if arrow == "() =>" {
        ()
      } else {
        fail("Should match arrow")
      }
    }
    _ => fail("Should match")
  }
}

///|
test "Parser - extract variable from annotation" {
  let annotation = "x: Int"
  lexmatch annotation with longest {
    (("\w+" as var_), _rest) => {
      if var_ == "x" {
        ()
      } else {
        fail("Should extract var")
      }
    }
    _ => fail("Should match")
  }
}

///|
test "Tokenizer - extract type name" {
  let generic = "List<Int>"
  lexmatch generic with longest {
    (("\w+" as tname), _rest) => {
      if tname == "List" {
        ()
      } else {
        fail("Should extract type")
      }
    }
    _ => fail("Should match")
  }
}

///|
test "Parser - extract comment start" {
  let comment = "/* text */"
  lexmatch comment with longest {
    ((("/" "\*") as start), _rest) => {
      if start == "/*" {
        ()
      } else {
        fail("Should match comment")
      }
    }
    _ => fail("Should match")
  }
}

///|
test "Tokenizer - validate hex escape" {
  let hex = "\\x41"
  if hex lexmatch? ("\\" "x" "[\da-fA-F]{2}") with longest {
    ()
  } else {
    fail("Should match hex")
  }
}

///|
test "Parser - validate unicode escape" {
  let unicode = "\\u0041"
  if unicode lexmatch? ("\\" "u" "[\da-fA-F]{4}") with longest {
    ()
  } else {
    fail("Should match unicode")
  }
}
