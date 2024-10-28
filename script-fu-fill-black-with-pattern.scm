;
; Selects black colour, replace it with pattern.
; See line 15 for the name of the pattern.
;
(define (script-fu-fill-black-with-pattern image drawable)
  (gimp-context-push)

  (gimp-image-undo-group-start image)

  (gimp-context-set-antialias FALSE)
  (gimp-context-set-feather FALSE)
  (gimp-context-set-sample-threshold 0.3)
  (gimp-image-select-color image CHANNEL-OP-ADD drawable '(0 0 0))

  (gimp-context-set-pattern "2a")
  (gimp-edit-bucket-fill drawable BUCKET-FILL-PATTERN NORMAL-MODE 100 0 FALSE 0 0)

  (gimp-selection-none image)

  (gimp-displays-flush)
  (gimp-image-undo-group-end image)

  (gimp-context-pop)
)

(define (filename-from-path path)
  (car (reverse (strbreakup path "\\")))
)

(define (basename-from-filename file-name)
  (car (strbreakup file-name "."))
)

(define (script-fu-fill-black-with-pattern-batch input-pattern result-directory)
(let* (
    (files (cadr (file-glob input-pattern 1)))
  )
  (while (not (null? files))
    (let* (
        (file-name (car files))
        (output-filename (string-append result-directory "\\" (basename-from-filename (filename-from-path file-name)) ".jpg"))
        (image (car (gimp-file-load RUN-NONINTERACTIVE file-name file-name)))
        (drawable (car (gimp-image-get-active-layer image)))
      )
      (script-fu-fill-black-with-pattern image drawable)
      (gimp-file-save RUN-NONINTERACTIVE image drawable output-filename output-filename)
      (gimp-image-delete image)
    )
    (set! files (cdr files))
  )
))

;
; Example of call:
; "C:\Program Files\GIMP 2\bin\gimp-2.10.exe" -i -b "(script-fu-fill-black-with-pattern-batch \"input\\*.jpg\" \"output\")" -b "(gimp-quit 0)"
; 
