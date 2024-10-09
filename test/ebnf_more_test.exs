#
# MIT License
#
# Copyright (c) 2023-2024 The ggml authors
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
#
# https://github.com/ggerganov/llama.cpp/blob/master/tests/test-json-schema-to-grammar.cpp
#
# Code used from Regex Copy paste from llama.cpp
#
defmodule EBNFMoreTest do
  use ExUnit.Case

  alias EBNF.ParseState

# Try all to parse all grammars from
# https://github.com/ggerganov/llama.cpp/blob/master/tests/test-json-schema-to-grammar.cpp
  describe "parse/1" do

    test "min 0" do

	grammar = """
root ::= ([0] | [1-9] [0-9]{0,15}) space
space ::= | " " | "\n" [ \t]{0,20}
"""
      assert {:ok, parsed, "", _, _, _} = EBNF.parse(grammar)
      assert [_ | _] = parsed
    end

    test "min 1" do

	grammar = """
root ::= ([1-9] [0-9]{0,15}) space
space ::= | " " | "\n" [ \t]{0,20}
"""
assert {:ok, parsed, "", _, _, _} = EBNF.parse(grammar)
assert [_ | _] = parsed
    end

    test "min 3" do

	grammar = """
root ::= ([1-2] [0-9]{1,15} | [3-9] [0-9]{0,15}) space
space ::= | " "
"""
assert {:ok, parsed, "", _, _, _} = EBNF.parse(grammar)
assert [_ | _] = parsed
    end

    test "min 9" do

	grammar = """
root ::= ([1-8] [0-9]{1,15} | [9] [0-9]{0,15}) space
space ::= | " " | "\n" [ \t]{0,20}
"""
	assert {:ok, parsed, "", _, _, _} = EBNF.parse(grammar)
assert [_ | _] = parsed
    end

    test "min 10" do

	grammar = """
root ::= ([1] ([0-9]{1,15}) | [2-9] [0-9]{1,15}) space
space ::= | " " | "\n" [ \t]{0,20}
"""
	assert {:ok, parsed, "", _, _, _} = EBNF.parse(grammar)
assert [_ | _] = parsed
    end

    test "min 25" do

	grammar = """
root ::= ([1] [0-9]{2,15} | [2] ([0-4] [0-9]{1,14} | [5-9] [0-9]{0,14}) | [3-9] [0-9]{1,15}) space
space ::= | " " | "\n" [ \t]{0,20}
"""
	assert {:ok, parsed, "", _, _, _} = EBNF.parse(grammar)
assert [_ | _] = parsed
    end

    test "max 30" do

	grammar = """
root ::= ("-" [1-9] [0-9]{0,15} | [0-9] | ([1-2] [0-9] | [3] "0")) space
space ::= | " " | "\n" [ \t]{0,20}
"""
	assert {:ok, parsed, "", _, _, _} = EBNF.parse(grammar)
assert [_ | _] = parsed
    end

    test "min -5" do

	grammar = """
root ::= ("-" ([0-5]) | [0] | [1-9] [0-9]{0,15}) space
space ::= | " " | "\n" [ \t]{0,20}
"""
	assert {:ok, parsed, "", _, _, _} = EBNF.parse(grammar)
assert [_ | _] = parsed
    end

    test "min -123" do

	grammar = """
root ::= ("-" ([0-9] | ([1-8] [0-9] | [9] [0-9]) | "1" ([0-1] [0-9] | [2] [0-3])) | [0] | [1-9] [0-9]{0,15}) space
space ::= | " " | "\n" [ \t]{0,20}
"""
	assert {:ok, parsed, "", _, _, _} = EBNF.parse(grammar)
assert [_ | _] = parsed
    end

    test "max -5" do

	grammar = """
root ::= ("-" ([0-4] [0-9]{1,15} | [5-9] [0-9]{0,15})) space
space ::= | " " | "\n" [ \t]{0,20}
"""
	assert {:ok, parsed, "", _, _, _} = EBNF.parse(grammar)
assert [_ | _] = parsed
    end

    test "max 1" do

	grammar = """
root ::= ("-" [1-9] [0-9]{0,15} | [0-1]) space
space ::= | " " | "\n" [ \t]{0,20}
"""
	assert {:ok, parsed, "", _, _, _} = EBNF.parse(grammar)
assert [_ | _] = parsed
    end

    test "max 100" do

	grammar = """
root ::= ("-" [1-9] [0-9]{0,15} | [0-9] | ([1-8] [0-9] | [9] [0-9]) | "100") space
space ::= | " " | "\n" [ \t]{0,20}
"""
	assert {:ok, parsed, "", _, _, _} = EBNF.parse(grammar)
assert [_ | _] = parsed
    end

    test "min 0 max 23" do

	grammar = """
root ::= ([0-9] | ([1] [0-9] | [2] [0-3])) space
space ::= | " " | "\n" [ \t]{0,20}
"""
	assert {:ok, parsed, "", _, _, _} = EBNF.parse(grammar)
assert [_ | _] = parsed
    end

    test "min 15 max 300" do

	grammar = """
root ::= (([1] ([5-9]) | [2-9] [0-9]) | ([1-2] [0-9]{2} | [3] "00")) space
space ::= | " " | "\n" [ \t]{0,20}
"""
	assert {:ok, parsed, "", _, _, _} = EBNF.parse(grammar)
assert [_ | _] = parsed
    end

    test "min 5 max 30" do

	grammar = """
root ::= ([5-9] | ([1-2] [0-9] | [3] "0")) space
space ::= | " " | "\n" [ \t]{0,20}
"""
	assert {:ok, parsed, "", _, _, _} = EBNF.parse(grammar)
assert [_ | _] = parsed
    end

    test "min -123 max 42" do

	grammar = """
root ::= ("-" ([0-9] | ([1-8] [0-9] | [9] [0-9]) | "1" ([0-1] [0-9] | [2] [0-3])) | [0-9] | ([1-3] [0-9] | [4] [0-2])) space
space ::= | " " | "\n" [ \t]{0,20}
"""
	assert {:ok, parsed, "", _, _, _} = EBNF.parse(grammar)
assert [_ | _] = parsed
    end

    test "min -10 max 10" do

	grammar = """
root ::= ("-" ([0-9] | "10") | [0-9] | "10") space
space ::= | " " | "\n" [ \t]{0,20}
"""
	assert {:ok, parsed, "", _, _, _} = EBNF.parse(grammar)
assert [_ | _] = parsed
    end


    test "empty schema (object)" do

	grammar = """
array ::= "[" space ( value ("," space value)* )? "]" space
boolean ::= ("true" | "false") space
char ::= [^"\\\x7F\x00-\x1F] | [\\] (["\\bfnrt] | "u" [0-9a-fA-F]{4})
decimal-part ::= [0-9]{1,16}
integral-part ::= [0] | [1-9] [0-9]{0,15}
null ::= "null" space
number ::= ("-"? integral-part) ("." decimal-part)? ([eE] [-+]? integral-part)? space
object ::= "{" space ( string ":" space value ("," space string ":" space value)* )? "}" space
root ::= object
space ::= | " " | "\n" [ \t]{0,20}
string ::= "\"" char* "\"" space
value ::= object | array | string | number | boolean | null
"""
	assert {:ok, parsed, "", _, _, _} = EBNF.parse(grammar)
assert [_ | _] = parsed
    end

    test "exotic formats" do

	grammar = """
date ::= [0-9]{4} "-" ( "0" [1-9] | "1" [0-2] ) "-" ( "0" [1-9] | [1-2] [0-9] | "3" [0-1] )
date-string ::= "\"" date "\"" space
date-time ::= date "T" time
date-time-string ::= "\"" date-time "\"" space
root ::= "[" space tuple-0 "," space uuid "," space tuple-2 "," space tuple-3 "]" space
space ::= | " " | "\n" [ \t]{0,20}
time ::= ([01] [0-9] | "2" [0-3]) ":" [0-5] [0-9] ":" [0-5] [0-9] ( "." [0-9]{3} )? ( "Z" | ( "+" | "-" ) ( [01] [0-9] | "2" [0-3] ) ":" [0-5] [0-9] )
time-string ::= "\"" time "\"" space
tuple-0 ::= date-string
tuple-2 ::= time-string
tuple-3 ::= date-time-string
uuid ::= "\"" [0-9a-fA-F]{8} "-" [0-9a-fA-F]{4} "-" [0-9a-fA-F]{4} "-" [0-9a-fA-F]{4} "-" [0-9a-fA-F]{12} "\"" space
"""
	assert {:ok, parsed, "", _, _, _} = EBNF.parse(grammar)
assert [_ | _] = parsed
    end

    test "string" do

	grammar = """
char ::= [^"\\\x7F\x00-\x1F] | [\\] (["\\bfnrt] | "u" [0-9a-fA-F]{4})
root ::= "\"" char* "\"" space
space ::= | " " | "\n" [ \t]{0,20}
"""
	assert {:ok, parsed, "", _, _, _} = EBNF.parse(grammar)
assert [_ | _] = parsed
    end

    test "string w/ min length 1" do

	grammar = """
char ::= [^"\\\x7F\x00-\x1F] | [\\] (["\\bfnrt] | "u" [0-9a-fA-F]{4})
root ::= "\"" char+ "\"" space
space ::= | " " | "\n" [ \t]{0,20}
"""
	assert {:ok, parsed, "", _, _, _} = EBNF.parse(grammar)
assert [_ | _] = parsed
    end

    test "string w/ min length 3" do

	grammar = """
char ::= [^"\\\x7F\x00-\x1F] | [\\] (["\\bfnrt] | "u" [0-9a-fA-F]{4})
root ::= "\"" char{3,} "\"" space
space ::= | " " | "\n" [ \t]{0,20}
"""
	assert {:ok, parsed, "", _, _, _} = EBNF.parse(grammar)
assert [_ | _] = parsed
    end

    test "string w/ max length" do

	grammar = """
char ::= [^"\\\x7F\x00-\x1F] | [\\] (["\\bfnrt] | "u" [0-9a-fA-F]{4})
root ::= "\"" char{0,3} "\"" space
space ::= | " " | "\n" [ \t]{0,20}
"""
	assert {:ok, parsed, "", _, _, _} = EBNF.parse(grammar)
assert [_ | _] = parsed
    end

    test "string w/ min & max length" do

	grammar = """
char ::= [^"\\\x7F\x00-\x1F] | [\\] (["\\bfnrt] | "u" [0-9a-fA-F]{4})
root ::= "\"" char{1,4} "\"" space
space ::= | " " | "\n" [ \t]{0,20}
"""
	assert {:ok, parsed, "", _, _, _} = EBNF.parse(grammar)
assert [_ | _] = parsed
    end

    test "boolean" do

	grammar = """
root ::= ("true" | "false") space
space ::= | " " | "\n" [ \t]{0,20}
"""
assert {:ok, parsed, "", _, _, _} = EBNF.parse(grammar)
assert [_ | _] = parsed
    end

    test "integer" do

	grammar = """
integral-part ::= [0] | [1-9] [0-9]{0,15}
root ::= ("-"? integral-part) space
space ::= | " " | "\n" [ \t]{0,20}
"""
	assert {:ok, parsed, "", _, _, _} = EBNF.parse(grammar)
assert [_ | _] = parsed
    end

    test "string const" do

	grammar = """
root ::= "\"foo\"" space
space ::= | " " | "\n" [ \t]{0,20}
"""
	assert {:ok, parsed, "", _, _, _} = EBNF.parse(grammar)
assert [_ | _] = parsed
    end

    test "non-string const" do

	grammar = """
root ::= "123" space
space ::= | " " | "\n" [ \t]{0,20}
"""
	assert {:ok, parsed, "", _, _, _} = EBNF.parse(grammar)
assert [_ | _] = parsed
    end

    test "non-string enum" do

	grammar = """
root ::= ("\"red\"" | "\"amber\"" | "\"green\"" | "null" | "42" | "[\"foo\"]") space
space ::= | " " | "\n" [ \t]{0,20}
"""
	assert {:ok, parsed, "", _, _, _} = EBNF.parse(grammar)
assert [_ | _] = parsed
    end

    test "string array" do

	grammar = """
char ::= [^"\\\x7F\x00-\x1F] | [\\] (["\\bfnrt] | "u" [0-9a-fA-F]{4})
root ::= "[" space (string ("," space string)*)? "]" space
space ::= | " " | "\n" [ \t]{0,20}
string ::= "\"" char* "\"" space
"""
	assert {:ok, parsed, "", _, _, _} = EBNF.parse(grammar)
assert [_ | _] = parsed
    end

    test "nullable string array" do

	grammar = """
alternative-0 ::= "[" space (string ("," space string)*)? "]" space
char ::= [^"\\\x7F\x00-\x1F] | [\\] (["\\bfnrt] | "u" [0-9a-fA-F]{4})
null ::= "null" space
root ::= alternative-0 | null
space ::= | " " | "\n" [ \t]{0,20}
string ::= "\"" char* "\"" space
"""
	assert {:ok, parsed, "", _, _, _} = EBNF.parse(grammar)
assert [_ | _] = parsed
    end

    test "tuple1" do

	grammar = """
char ::= [^"\\\x7F\x00-\x1F] | [\\] (["\\bfnrt] | "u" [0-9a-fA-F]{4})
root ::= "[" space string "]" space
space ::= | " " | "\n" [ \t]{0,20}
string ::= "\"" char* "\"" space
"""
	assert {:ok, parsed, "", _, _, _} = EBNF.parse(grammar)
assert [_ | _] = parsed
    end

    test "tuple2" do

	grammar = """
char ::= [^"\\\x7F\x00-\x1F] | [\\] (["\\bfnrt] | "u" [0-9a-fA-F]{4})
decimal-part ::= [0-9]{1,16}
integral-part ::= [0] | [1-9] [0-9]{0,15}
number ::= ("-"? integral-part) ("." decimal-part)? ([eE] [-+]? integral-part)? space
root ::= "[" space string "," space number "]" space
space ::= | " " | "\n" [ \t]{0,20}
string ::= "\"" char* "\"" space
"""
	assert {:ok, parsed, "", _, _, _} = EBNF.parse(grammar)
assert [_ | _] = parsed
    end

    test "number" do

	grammar = """
decimal-part ::= [0-9]{1,16}
integral-part ::= [0] | [1-9] [0-9]{0,15}
root ::= ("-"? integral-part) ("." decimal-part)? ([eE] [-+]? integral-part)? space
space ::= | " " | "\n" [ \t]{0,20}
"""
	assert {:ok, parsed, "", _, _, _} = EBNF.parse(grammar)
assert [_ | _] = parsed
    end

    test "minItems" do

	grammar = """
boolean ::= ("true" | "false") space
root ::= "[" space boolean ("," space boolean)+ "]" space
space ::= | " " | "\n" [ \t]{0,20}
"""
	assert {:ok, parsed, "", _, _, _} = EBNF.parse(grammar)
assert [_ | _] = parsed
    end

    test "maxItems 1" do

	grammar = """
boolean ::= ("true" | "false") space
root ::= "[" space boolean? "]" space
space ::= | " " | "\n" [ \t]{0,20}
"""
	assert {:ok, parsed, "", _, _, _} = EBNF.parse(grammar)
assert [_ | _] = parsed
    end

    test "maxItems 2" do

	grammar = """
boolean ::= ("true" | "false") space
root ::= "[" space (boolean ("," space boolean)?)? "]" space
space ::= | " " | "\n" [ \t]{0,20}
"""
	assert {:ok, parsed, "", _, _, _} = EBNF.parse(grammar)
assert [_ | _] = parsed
    end

    test "min + maxItems" do

	grammar = """
decimal-part ::= [0-9]{1,16}
integer ::= ("-"? integral-part) space
integral-part ::= [0] | [1-9] [0-9]{0,15}
item ::= number | integer
number ::= ("-"? integral-part) ("." decimal-part)? ([eE] [-+]? integral-part)? space
root ::= "[" space item ("," space item){2,4} "]" space
space ::= | " " | "\n" [ \t]{0,20}
"""
	assert {:ok, parsed, "", _, _, _} = EBNF.parse(grammar)
assert [_ | _] = parsed
    end

    test "min + max items with min + max values across zero" do

	grammar = """
item ::= ("-" ([0-9] | "1" [0-2]) | [0-9] | ([1-8] [0-9] | [9] [0-9]) | ([1] [0-9]{2} | [2] "0" [0-7])) space
root ::= "[" space item ("," space item){2,4} "]" space
space ::= | " " | "\n" [ \t]{0,20}
"""
	assert {:ok, parsed, "", _, _, _} = EBNF.parse(grammar)
assert [_ | _] = parsed
    end

    test "min + max items with min + max values" do

	grammar = """
item ::= (([1] ([2-9]) | [2-9] [0-9]) | ([1] [0-9]{2} | [2] "0" [0-7])) space
root ::= "[" space item ("," space item){2,4} "]" space
space ::= | " " | "\n" [ \t]{0,20}
"""
	assert {:ok, parsed, "", _, _, _} = EBNF.parse(grammar)
assert [_ | _] = parsed
    end

    test "simple regexp" do

	grammar = """
root ::= "\"" "ab" "c"? "d"* "ef" "g"+ ("hij")? "kl" "\"" space
space ::= | " " | "\n" [ \t]{0,20}
"""
	assert {:ok, parsed, "", _, _, _} = EBNF.parse(grammar)
assert [_ | _] = parsed
    end

#    test "regexp escapes" do
#
#	grammar = """
#root ::= "\"" "[]{}()|+*?" "\"" space
#space ::= | " " | "\n" [ \t]{0,20}
#"""
#	assert {:ok, parsed, "", _, _, _} = EBNF.parse(grammar)
#assert [_ | _] = parsed
#    end

#    test "regexp quote" do
#
#	grammar = """
#root ::= "\"" "\"" "\"" space
#space ::= | " " | "\n" [ \t]{0,20}
#"""
#	assert {:ok, parsed, "", _, _, _} = EBNF.parse(grammar)
#assert [_ | _] = parsed
#    end

    test "regexp" do

	grammar = """
dot ::= [^\x0A\x0D]
root ::= "\"" ("(" root-1{1,3} ")")? root-1{3,3} "-" root-1{4,4} " " "a"{3,5} "nd" dot dot dot "\"" space
root-1 ::= [0-9]
space ::= | " " | "\n" [ \t]{0,20}
"""
	assert {:ok, parsed, "", _, _, _} = EBNF.parse(grammar)
assert [_ | _] = parsed
    end

    test "required props in original order" do

	grammar = """
a-kv ::= "\"a\"" space ":" space string
b-kv ::= "\"b\"" space ":" space string
c-kv ::= "\"c\"" space ":" space string
char ::= [^"\\\x7F\x00-\x1F] | [\\] (["\\bfnrt] | "u" [0-9a-fA-F]{4})
root ::= "{" space b-kv "," space c-kv "," space a-kv "}" space
space ::= | " " | "\n" [ \t]{0,20}
string ::= "\"" char* "\"" space
"""
	assert {:ok, parsed, "", _, _, _} = EBNF.parse(grammar)
assert [_ | _] = parsed
    end

    test "1 optional prop" do

	grammar = """
a-kv ::= "\"a\"" space ":" space string
char ::= [^"\\\x7F\x00-\x1F] | [\\] (["\\bfnrt] | "u" [0-9a-fA-F]{4})
root ::= "{" space  (a-kv )? "}" space
space ::= | " " | "\n" [ \t]{0,20}
string ::= "\"" char* "\"" space
"""
	assert {:ok, parsed, "", _, _, _} = EBNF.parse(grammar)
assert [_ | _] = parsed
    end

    test "N optional props" do

	grammar = """
a-kv ::= "\"a\"" space ":" space string
a-rest ::= ( "," space b-kv )? b-rest
b-kv ::= "\"b\"" space ":" space string
b-rest ::= ( "," space c-kv )?
c-kv ::= "\"c\"" space ":" space string
char ::= [^"\\\x7F\x00-\x1F] | [\\] (["\\bfnrt] | "u" [0-9a-fA-F]{4})
root ::= "{" space  (a-kv a-rest | b-kv b-rest | c-kv )? "}" space
space ::= | " " | "\n" [ \t]{0,20}
string ::= "\"" char* "\"" space
"""
	assert {:ok, parsed, "", _, _, _} = EBNF.parse(grammar)
assert [_ | _] = parsed
    end

    test "required + optional props each in original order" do

	grammar = """
a-kv ::= "\"a\"" space ":" space string
b-kv ::= "\"b\"" space ":" space string
c-kv ::= "\"c\"" space ":" space string
char ::= [^"\\\x7F\x00-\x1F] | [\\] (["\\bfnrt] | "u" [0-9a-fA-F]{4})
d-kv ::= "\"d\"" space ":" space string
d-rest ::= ( "," space c-kv )?
root ::= "{" space b-kv "," space a-kv ( "," space ( d-kv d-rest | c-kv ) )? "}" space
space ::= | " " | "\n" [ \t]{0,20}
string ::= "\"" char* "\"" space
"""
	assert {:ok, parsed, "", _, _, _} = EBNF.parse(grammar)
assert [_ | _] = parsed
    end

    test "additional props" do

	grammar = """
additional-kv ::= string ":" space additional-value
additional-value ::= "[" space (number ("," space number)*)? "]" space
char ::= [^"\\\x7F\x00-\x1F] | [\\] (["\\bfnrt] | "u" [0-9a-fA-F]{4})
decimal-part ::= [0-9]{1,16}
integral-part ::= [0] | [1-9] [0-9]{0,15}
number ::= ("-"? integral-part) ("." decimal-part)? ([eE] [-+]? integral-part)? space
root ::= "{" space  (additional-kv ( "," space additional-kv )* )? "}" space
space ::= | " " | "\n" [ \t]{0,20}
string ::= "\"" char* "\"" space
"""
	assert {:ok, parsed, "", _, _, _} = EBNF.parse(grammar)
assert [_ | _] = parsed
    end

    test "additional props (true)" do

	grammar = """
array ::= "[" space ( value ("," space value)* )? "]" space
boolean ::= ("true" | "false") space
char ::= [^"\\\x7F\x00-\x1F] | [\\] (["\\bfnrt] | "u" [0-9a-fA-F]{4})
decimal-part ::= [0-9]{1,16}
integral-part ::= [0] | [1-9] [0-9]{0,15}
null ::= "null" space
number ::= ("-"? integral-part) ("." decimal-part)? ([eE] [-+]? integral-part)? space
object ::= "{" space ( string ":" space value ("," space string ":" space value)* )? "}" space
root ::= object
space ::= | " " | "\n" [ \t]{0,20}
string ::= "\"" char* "\"" space
value ::= object | array | string | number | boolean | null
"""
	assert {:ok, parsed, "", _, _, _} = EBNF.parse(grammar)
assert [_ | _] = parsed
    end

    test "additional props (implicit)" do

	grammar = """
array ::= "[" space ( value ("," space value)* )? "]" space
boolean ::= ("true" | "false") space
char ::= [^"\\\x7F\x00-\x1F] | [\\] (["\\bfnrt] | "u" [0-9a-fA-F]{4})
decimal-part ::= [0-9]{1,16}
integral-part ::= [0] | [1-9] [0-9]{0,15}
null ::= "null" space
number ::= ("-"? integral-part) ("." decimal-part)? ([eE] [-+]? integral-part)? space
object ::= "{" space ( string ":" space value ("," space string ":" space value)* )? "}" space
root ::= object
space ::= | " " | "\n" [ \t]{0,20}
string ::= "\"" char* "\"" space
value ::= object | array | string | number | boolean | null
"""
	assert {:ok, parsed, "", _, _, _} = EBNF.parse(grammar)
assert [_ | _] = parsed
    end

    test "empty w/o additional props" do

	grammar = """
root ::= "{" space  "}" space
space ::= | " " | "\n" [ \t]{0,20}
"""
	assert {:ok, parsed, "", _, _, _} = EBNF.parse(grammar)
assert [_ | _] = parsed
    end

    test "required + additional props" do

	grammar = """
a-kv ::= "\"a\"" space ":" space number
additional-k ::= ["] ( [a] char+ | [^"a] char* )? ["] space
additional-kv ::= additional-k ":" space string
char ::= [^"\\\x7F\x00-\x1F] | [\\] (["\\bfnrt] | "u" [0-9a-fA-F]{4})
decimal-part ::= [0-9]{1,16}
integral-part ::= [0] | [1-9] [0-9]{0,15}
number ::= ("-"? integral-part) ("." decimal-part)? ([eE] [-+]? integral-part)? space
root ::= "{" space a-kv ( "," space ( additional-kv ( "," space additional-kv )* ) )? "}" space
space ::= | " " | "\n" [ \t]{0,20}
string ::= "\"" char* "\"" space
"""
	assert {:ok, parsed, "", _, _, _} = EBNF.parse(grammar)
assert [_ | _] = parsed
    end

    test "optional + additional props" do

	grammar = """
a-kv ::= "\"a\"" space ":" space number
a-rest ::= ( "," space additional-kv )*
additional-k ::= ["] ( [a] char+ | [^"a] char* )? ["] space
additional-kv ::= additional-k ":" space number
char ::= [^"\\\x7F\x00-\x1F] | [\\] (["\\bfnrt] | "u" [0-9a-fA-F]{4})
decimal-part ::= [0-9]{1,16}
integral-part ::= [0] | [1-9] [0-9]{0,15}
number ::= ("-"? integral-part) ("." decimal-part)? ([eE] [-+]? integral-part)? space
root ::= "{" space  (a-kv a-rest | additional-kv ( "," space additional-kv )* )? "}" space
space ::= | " " | "\n" [ \t]{0,20}
"""
	assert {:ok, parsed, "", _, _, _} = EBNF.parse(grammar)
assert [_ | _] = parsed
    end

    test "required + optional + additional props" do

	grammar = """
additional-k ::= ["] ( [a] ([l] ([s] ([o] char+ | [^"o] char*) | [^"s] char*) | [n] ([d] char+ | [^"d] char*) | [^"ln] char*) | [^"a] char* )? ["] space
additional-kv ::= additional-k ":" space number
also-kv ::= "\"also\"" space ":" space number
also-rest ::= ( "," space additional-kv )*
and-kv ::= "\"and\"" space ":" space number
char ::= [^"\\\x7F\x00-\x1F] | [\\] (["\\bfnrt] | "u" [0-9a-fA-F]{4})
decimal-part ::= [0-9]{1,16}
integral-part ::= [0] | [1-9] [0-9]{0,15}
number ::= ("-"? integral-part) ("." decimal-part)? ([eE] [-+]? integral-part)? space
root ::= "{" space and-kv ( "," space ( also-kv also-rest | additional-kv ( "," space additional-kv )* ) )? "}" space
space ::= | " " | "\n" [ \t]{0,20}
"""
	assert {:ok, parsed, "", _, _, _} = EBNF.parse(grammar)
assert [_ | _] = parsed
    end

    test "optional props with empty name" do

	grammar = """
-kv ::= "\"\"" space ":" space root
-rest ::= ( "," space a-kv )? a-rest
a-kv ::= "\"a\"" space ":" space integer
a-rest ::= ( "," space additional-kv )*
additional-k ::= ["] ( [a] char+ | [^"a] char* ) ["] space
additional-kv ::= additional-k ":" space integer
char ::= [^"\\\x7F\x00-\x1F] | [\\] (["\\bfnrt] | "u" [0-9a-fA-F]{4})
integer ::= ("-"? integral-part) space
integral-part ::= [0] | [1-9] [0-9]{0,15}
root ::= ("-"? integral-part) space
root0 ::= "{" space  (-kv -rest | a-kv a-rest | additional-kv ( "," space additional-kv )* )? "}" space
space ::= | " " | "\n" [ \t]{0,20}
"""
	assert {:ok, parsed, "", _, _, _} = EBNF.parse(grammar)
assert [_ | _] = parsed
    end

    test "optional props with nested names" do

	grammar = """
a-kv ::= "\"a\"" space ":" space integer
a-rest ::= ( "," space aa-kv )? aa-rest
aa-kv ::= "\"aa\"" space ":" space integer
aa-rest ::= ( "," space additional-kv )*
additional-k ::= ["] ( [a] ([a] char+ | [^"a] char*) | [^"a] char* )? ["] space
additional-kv ::= additional-k ":" space integer
char ::= [^"\\\x7F\x00-\x1F] | [\\] (["\\bfnrt] | "u" [0-9a-fA-F]{4})
integer ::= ("-"? integral-part) space
integral-part ::= [0] | [1-9] [0-9]{0,15}
root ::= "{" space  (a-kv a-rest | aa-kv aa-rest | additional-kv ( "," space additional-kv )* )? "}" space
space ::= | " " | "\n" [ \t]{0,20}
"""
	assert {:ok, parsed, "", _, _, _} = EBNF.parse(grammar)
assert [_ | _] = parsed
    end

    test "optional props with common prefix" do

	grammar = """
ab-kv ::= "\"ab\"" space ":" space integer
ab-rest ::= ( "," space ac-kv )? ac-rest
ac-kv ::= "\"ac\"" space ":" space integer
ac-rest ::= ( "," space additional-kv )*
additional-k ::= ["] ( [a] ([b] char+ | [c] char+ | [^"bc] char*) | [^"a] char* )? ["] space
additional-kv ::= additional-k ":" space integer
char ::= [^"\\\x7F\x00-\x1F] | [\\] (["\\bfnrt] | "u" [0-9a-fA-F]{4})
integer ::= ("-"? integral-part) space
integral-part ::= [0] | [1-9] [0-9]{0,15}
root ::= "{" space  (ab-kv ab-rest | ac-kv ac-rest | additional-kv ( "," space additional-kv )* )? "}" space
space ::= | " " | "\n" [ \t]{0,20}
"""
	assert {:ok, parsed, "", _, _, _} = EBNF.parse(grammar)
assert [_ | _] = parsed
    end

    test "top-level $ref" do

	grammar = """
char ::= [^"\\\x7F\x00-\x1F] | [\\] (["\\bfnrt] | "u" [0-9a-fA-F]{4})
foo ::= "{" space foo-a-kv "}" space
foo-a-kv ::= "\"a\"" space ":" space string
root ::= foo
space ::= | " " | "\n" [ \t]{0,20}
string ::= "\"" char* "\"" space
"""
	assert {:ok, parsed, "", _, _, _} = EBNF.parse(grammar)
assert [_ | _] = parsed
    end

    test "anyOf" do

	grammar = """
alternative-0 ::= foo
alternative-1 ::= bar
bar ::= "{" space  (bar-b-kv )? "}" space
bar-b-kv ::= "\"b\"" space ":" space number
decimal-part ::= [0-9]{1,16}
foo ::= "{" space  (foo-a-kv )? "}" space
foo-a-kv ::= "\"a\"" space ":" space number
integral-part ::= [0] | [1-9] [0-9]{0,15}
number ::= ("-"? integral-part) ("." decimal-part)? ([eE] [-+]? integral-part)? space
root ::= alternative-0 | alternative-1
space ::= | " " | "\n" [ \t]{0,20}
"""
	assert {:ok, parsed, "", _, _, _} = EBNF.parse(grammar)
assert [_ | _] = parsed
    end

    test "mix of allOf, anyOf and $ref (similar to https://json.schemastore.org/tsconfig.json)" do

	grammar = """
a-kv ::= "\"a\"" space ":" space number
b-kv ::= "\"b\"" space ":" space number
c-kv ::= "\"c\"" space ":" space number
d-kv ::= "\"d\"" space ":" space number
d-rest ::= ( "," space c-kv )?
decimal-part ::= [0-9]{1,16}
integral-part ::= [0] | [1-9] [0-9]{0,15}
number ::= ("-"? integral-part) ("." decimal-part)? ([eE] [-+]? integral-part)? space
root ::= "{" space a-kv "," space b-kv ( "," space ( d-kv d-rest | c-kv ) )? "}" space
space ::= | " " | "\n" [ \t]{0,20}
"""
	assert {:ok, parsed, "", _, _, _} = EBNF.parse(grammar)
assert [_ | _] = parsed
    end

    test "conflicting names" do

	grammar = """
decimal-part ::= [0-9]{1,16}
integral-part ::= [0] | [1-9] [0-9]{0,15}
number ::= ("-"? integral-part) ("." decimal-part)? ([eE] [-+]? integral-part)? space
number- ::= "{" space number-number-kv "}" space
number-kv ::= "\"number\"" space ":" space number-
number-number ::= "{" space number-number-root-kv "}" space
number-number-kv ::= "\"number\"" space ":" space number-number
number-number-root-kv ::= "\"root\"" space ":" space number
root ::= "{" space number-kv "}" space
space ::= | " " | "\n" [ \t]{0,20}
"""
	assert {:ok, parsed, "", _, _, _} = EBNF.parse(grammar)
assert [_ | _] = parsed
    end

    test "tab" do

	grammar = """
root ::= [\t]{0,20}
"""
	assert {:ok, parsed, "", _, _, _} = EBNF.parse(grammar)
assert [_ | _] = parsed
    end

    test "two tab" do

	grammar = """
root ::= [\t]{2}
"""
	assert {:ok, parsed, "", _, _, _} = EBNF.parse(grammar)
assert [_ | _] = parsed
    end

    test "char regex" do

	grammar = """
root ::= [^\"\\\d\0-\x1F]
"""
	assert {:ok, parsed, "", _, _, _} = EBNF.parse(grammar)
assert [_ | _] = parsed
    end

  end

  describe "expand/1" do

    test "tab{1,3}" do

	grammar = """
root ::= [\t]{1,3}
"""
assert %ParseState{
         symbol_ids: symbol,
         grammar_encoding: encoded
       } = EBNF.encode(grammar)
assert [1, 10, 2, 9, 9, 2, 9, 9, 2, 9, 9, 0, 7, 2, 9, 9, 2, 9, 9, 0, 4, 2, 9, 9, 0, 0, 0, 3, 1, 1, 0, 0, 65535] = encoded
assert %{"root" => 0, "root_1" => 1} = symbol
    end

    test "tab{0,3}" do

	grammar = """
root ::= [\t]{0,3}
"""
assert %ParseState{
         symbol_ids: symbol,
         grammar_encoding: encoded
       } = EBNF.encode(grammar)
assert [1, 10, 2, 9, 9, 2, 9, 9, 2, 9, 9, 0, 7, 2, 9, 9, 2, 9, 9, 0, 4, 2, 9, 9, 0, 1, 0, 0, 0, 3, 1, 1, 0, 0, 65535] = encoded
assert %{"root" => 0, "root_1" => 1} = symbol
    end

    test "tab{2}" do

	grammar = """
root ::= [\t]{2}
"""
assert %ParseState{
         symbol_ids: symbol,
         grammar_encoding: encoded
       } = EBNF.encode(grammar)
assert [1, 7, 2, 9, 9, 2, 9, 9, 0, 0, 0, 3, 1, 1, 0, 0, 65535] = encoded
assert %{"root" => 0, "root_1" => 1} = symbol
    end
  end

end
