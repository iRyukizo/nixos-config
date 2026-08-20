; extends

(
 (call_expression
   function: (identifier) @_name
   arguments: (argument_list (string_literal (string_content) @injection.content)))
 (#match? @_name "_*[pP]rintf$|_FORMAT$|_PRINTF$")
 (#set! injection.language "printf")
)

(
 (call_expression
   function: (identifier) @_name
   arguments: (argument_list (concatenated_string (string_literal (string_content) @injection.content))))
 (#match? @_name "_*[pP]rintf$|_FORMAT$|_PRINTF$")
 (#set! injection.language "printf")
)
