; extends
(arguments (_) @swappable)
(variable_list (_) @swappable)
(field) @swappable
(parameters (_) @swappable)


;; define a bunch of "control" structures to move around
;; assignment_statement as well potentially
((variable_declaration) @control)
((for_statement) @control)
((function_declaration) @control)
((function_definition) @control)
((return_statement) @control)
((if_statement) @control)
((else_statement) @control)
((elseif_statement) @control)
"end" @control

