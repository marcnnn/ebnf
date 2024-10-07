defmodule EBNF.Parser do
  @moduledoc false

  import NimbleParsec

  from_to =
    ignore(string("{"))
    |> integer(min: 1)
    |> ignore(string(","))
    |> integer(min: 1)
    |> ignore(string("}"))
    |> tag(:from_to)

    times =
      ignore(string("{"))
      |> integer(min: 1)
      |> ignore(string("}"))
      |> tag(:times)

  whitespace = repeat(choice([string(" "), string("\n"), string("\t")]))

  string_literal =
    ignore(string(~s(")))
    |> repeat(
      lookahead_not(ascii_char([?"]))
      |> choice([
        ~S(\") |> string() |> replace(?"),
        string(~S(\t)) |> replace(?\t),
        string(~S(\n)) |> replace(?\n),
        string(~S(\\)) |> replace(?\\),
        utf8_char([])
      ])
    )
    |> ignore(string(~s(")))
    |> tag(:string)

  char =
    choice([
      string(~S( )) |> replace(?\s),
      string(~S(\t)) |> replace(?\t),
      string("\t") |> replace(?\t),
      string(~S(\n)) |> replace(?\n),
      string("\n") |> replace(?\n),
      string("\r") |> replace(?\r),
      string(~S(\\)) |> replace(?\\),
      string("\\") |> replace(?\\),
      string("\"") |> replace(?\"),
      string("\d") |> replace(?\d),
      string("\0") |> replace(?\0),
      string("\x1F") |> replace(~s(\x1F)),
      ascii_char([?a..?z, ?A..?Z, ?0..?9, ?_, ?-, ?+, ?*, ?/])
    ])
    |> tag(:char)

  range =
    char
    |> ignore(string("-"))
    |> concat(char)
    |> tag(:range)



  range_or_char = choice([range, char])

  negation =
    ignore(string("^"))
    |> concat(range_or_char)
    |> tag(:negation)

  negation_range_or_char = choice([negation, range, char])

  character_set =
    ignore(string("["))
    |> times(negation_range_or_char, min: 1)
    |> ignore(string("]"))
    |> tag(:character_set)

  terminal =
    choice([string_literal, character_set])
    |> tag(:terminal)

  identifier =
    ascii_string([?a..?z, ?A..?Z, ?0..?9, ?_, ?-], min: 1)
    |> tag(:identifier)

  grouping =
    ignore(string("("))
    |> ignore(repeat(string(" ")))
    |> parsec(:expression)
    |> ignore(repeat(string(" ")))
    |> ignore(string(")"))
    |> tag(:grouping)

  factor =
    choice([identifier, terminal, grouping])
    |> then(&choice([
      tag(concat(&1,choice([string("*"), string("+"), string("?"), from_to, times])),:repetition),
      &1
    ]))
    |> ignore(repeat(choice([string(" "), string("\t")])))

  term = times(factor, min: 0)

  choice_separator =
    ignore(repeat(string(" ")))
    |> string("|")
    |> ignore(repeat(string(" ")))

  alternate =
    term
    |> times(concat(choice_separator, choice([term, tag(empty(), :empty)])), min: 1)
    |> tag(:alternate)

  defcombinatorp(:expression, choice([alternate, term]))

  rule =
    identifier
    |> ignore(optional(repeat(string(" "))))
    |> ignore(string("::="))
    |> ignore(optional(repeat(string(" "))))
    |> concat(parsec(:expression))
    |> ignore(optional(whitespace))
    |> tag(:rule)

  defparsec(:grammar, times(rule, min: 1))
end
