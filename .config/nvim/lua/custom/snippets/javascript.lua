local ls = require("luasnip")

-- Predicato and
ls.snippets = {
  all = {
    ls.parser.parse_snippet("and", [[
"Name": "$1",
"_t": "AndPredicateDocument",
"Children": [
  {
    $0
  }
]
]]),
  }
}

-- Ateco2007
ls.snippets = {
  all = {
    ls.parser.parse_snippet("ateco2007", [[
"Name": "$3",
"_t": "Ateco2007PredicateDocument",
"Negate": $2,
"Mode": "$1", //Matches or Starts
"Values": [$0]
]]),
  }
}

-- Balance
ls.snippets = {
  all = {
    ls.parser.parse_snippet("balance", [[
"_t": "BalanceItemExpressionDocument",
"Code": "${0:numero}"
]]),
  }
}

-- ConstantNumber
ls.snippets = {
  all = {
    ls.parser.parse_snippet("constantNumber", [[
"_t": "ConstantNumberExpressionDocument",
"Value": $0
]]),
  }
}

-- Division
ls.snippets = {
  all = {
    ls.parser.parse_snippet("division", [[
"Name": $2,
"_t": "DivisionExpressionDocument",
"Left": {
  $1
},
"Right": {
  $0
}
]]),
  }
}

-- EqualString
ls.snippets = {
  all = {
    ls.parser.parse_snippet("equalString", [[
"Name": $2,
"_t": "StringEqPredicateDocument",
"Left": {
  "_t": "VariableStringExpressionDocument",
  "Var": "$1"
},
"Right": {
  "_t": "ConstantStringExpressionDocument",
  "Value": "$0"
}
]]),
  }
}

-- NewRule
ls.snippets = {
  all = {
    ls.parser.parse_snippet("newRule", [[
"Description": "$4",
"BankId": "$3",
"ProductId": $2,
"SubProductId": null,
"LawId": $1,
"Version": 1,
"Status": "Draft",
"Predicate": {
  $0
}
]]),
  }
}

-- Opposite
ls.snippets = {
  all = {
    ls.parser.parse_snippet("opposite", [[
"_t": "OppositeExpressionDocument",
"Child": {
  $0
}
]]),
  }
}

-- Or
ls.snippets = {
  all = {
    ls.parser.parse_snippet("or", [[
"Name": "$1",
"_t": "OrPredicateDocument",
"Children": [
  {
    $0
  }
]
]]),
  }
}

-- Parameters
ls.snippets = {
  all = {
    ls.parser.parse_snippet("parameters", [[
"Parameters": [{
  "Name": "$1",
  "Value": $0
}]
]]),
  }
}

-- Startup
ls.snippets = {
  all = {
    ls.parser.parse_snippet("startup", [[
"Name": "Costituita da meno di tre anni",
"_t": "IsStartupPredicateDocument",
]]),
  }
}

-- Sum
ls.snippets = {
  all = {
    ls.parser.parse_snippet("sum", [[
"_t": "SumExpressionDocument",
"Children":  [
  {
    $1
  },
  {
    $0
  }
]
]]),
  }
}

-- Template
ls.snippets = {
  all = {
    ls.parser.parse_snippet("template", [[
"Name": "${1:NOME-IN-MAIUSCOLO}",
"Expression": {
  $0
}
]]),
  }
}

-- TemplateRef
ls.snippets = {
  all = {
    ls.parser.parse_snippet("templateRef", [[
"_t": "NumberExpressionTemplateReferenceExpressionDocument",
"NameRef": "${0:NOME-IN-MAIUSCOLO}"
]]),
  }
}
