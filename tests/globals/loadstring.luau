assert(loadstring ~= nil, "loadstring global is missing")
assert(type(loadstring) == "function", "loadstring global should be a function")

local RETURN_SOURCE_BLOCK = 'return "Hello, World"'
local FUNCTIONAL_SOURCE_BLOCK = "return"

local BROKEN_SYNTAX_SOURCE_BLOCK = 'return "Hello ...'
local BROKEN_LOGIC_SOURCE_BLOCK = "return abc()"

assert(
	select(1, pcall(loadstring, nil)) == false,
	"expected loadstring to error when given no lua source"
)

local success = pcall(loadstring, BROKEN_SYNTAX_SOURCE_BLOCK)

assert(success == false, "expected loadstring to fail when given invalid syntax block")

local success, callback = pcall(loadstring, BROKEN_LOGIC_SOURCE_BLOCK)

assert(success == true, "expected loadstring to generate a function")
assert(type(callback) == "function", "expected a function return a `loadstring` call")

local success, callbackResponse = pcall(callback)

assert(success == false, "expected logic code block to error when executed")

local success, callback = pcall(loadstring, FUNCTIONAL_SOURCE_BLOCK)

assert(success == true, "expected loadstring to generate a function")
assert(type(callback) == "function", "expected a function return a `loadstring` call")

local success, callbackResponse = pcall(callback)

assert(success == true, "expected functional code block to successfully execute")
assert(callbackResponse == nil, "expected functional code block to not return a response")

local success, callback = pcall(loadstring, RETURN_SOURCE_BLOCK)

assert(success == true, "expected loadstring to generate a function")
assert(type(callback) == "function", "expected a function return a `loadstring` call")

local success, callbackResponse = pcall(callback)

assert(success == true, "expected return code block to successfully execute")
assert(callbackResponse == "Hello, World", "expected return code block to return a response")
