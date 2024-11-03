;
; Returns the basename base (without the extension) on the file-name.
;  "abc.abc.jpg" -> "abc.abc"
;  "abc" -> "abc"
;  "abc.jpg" -> "abc"
;
(define (basename-from-filename file-name)
(let* (
    (tokens (reverse (strbreakup file-name ".")))
  )
  (if (> (length tokens) 1)
    (unbreakupstr (reverse (cdr tokens)) ".")
    file-name
  )
))
