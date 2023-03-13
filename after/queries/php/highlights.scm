;; extends

(php_tag) @function.macro

(variable_name (name) @property)

(string) @nospell

((variable_name) @variable.builtin
 (#eq? @variable.builtin "this"))

[
 "$"
 ] @keyword
