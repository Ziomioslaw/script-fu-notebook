; The script assume, that there is something on the background.
; 1. selects the background
; 2. revert the selection
; 3. fill the colour
;
; +batch invoke
;
(define (script-fu-replace-with-selection image drawable new-color)
  (gimp-context-push)
  (gimp-image-undo-group-start image)

  (let* (
         (left-top-x 0)
         (left-top-y 0)

         (color-at-point (car (gimp-image-pick-color image drawable left-top-x left-top-y FALSE FALSE 0)))
        )
    (gimp-context-set-foreground color-at-point)
    (gimp-fuzzy-select drawable left-top-x left-top-y 15 CHANNEL-OP-REPLACE TRUE TRUE 5.0 FALSE)
    (gimp-selection-invert image)
    (gimp-context-set-foreground new-color)
    (gimp-edit-fill drawable FOREGROUND-FILL)
  )

  (gimp-image-undo-group-end image)

  (gimp-displays-flush)
  (gimp-context-pop)
)

(script-fu-register
  "script-fu-replace-with-selection"           ; Nazwa skryptu
  "Replace with Selection"                     ; Nazwa w interfejsie
  "Pick color from top-left, invert selection and fill"  ; Opis
  "Your Name"                                  ; Autor
  "Your License"                               ; Licencja
  "2024"                                       ; Rok
  "*"                                          ; Typ obrazu (dla wszystkich)
  SF-IMAGE "Image" 0                           ; Parametry: Obraz
  SF-DRAWABLE "Drawable" 0                     ; Parametry: Warstwa
  SF-COLOR "New Color" '(0 0 0)                ; Nowy kolor (czarny domyślnie)
)

(script-fu-menu-register "script-fu-replace-with-selection" "<Image>/Filters/Custom")

(define (filename-from-path path)
  (car (reverse (strbreakup path "\\")))
)

(define (basename-from-filename file-name)
  (car (strbreakup file-name "."))
)

(define (script-fu-replace-with-selection-batch new-color input-pattern result-directory)
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
      (script-fu-replace-with-selection image drawable new-color)
      (gimp-file-save RUN-NONINTERACTIVE image drawable output-filename output-filename)
      (gimp-image-delete image)
    )
    (set! files (cdr files))
  )
))

; Windows:
; "C:\Program Files\GIMP 2\bin\gimp-2.10.exe" -i -b "(script-fu-replace-with-selection-batch '(255 0 0) \"input\\*.jpg\" \"output\")" -b "(gimp-quit 0)"
;
