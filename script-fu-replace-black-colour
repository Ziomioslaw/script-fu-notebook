; Replace black colour with given.
; 

(define (script-fu-replace-with-selection image drawable new-color threshold)
  (gimp-context-push)
  (gimp-image-undo-group-start image)

  (let* (
         (left-top-x 0)
         (left-top-y 0)

         (color-at-point (car (gimp-image-pick-color image drawable left-top-x left-top-y FALSE FALSE 0)))
        )
    (gimp-context-set-foreground color-at-point)
    (gimp-context-set-sample-threshold threshold)
    (gimp-image-select-color image CHANNEL-OP-ADD drawable '(0 0 0))
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
  SF-ADJUSTMENT "Threshold" '(0.15 0.0 1.0 0.01 0.1 2 0)  ; Próg wyboru koloru
)

(script-fu-menu-register "script-fu-replace-with-selection" "<Image>/Filters/Custom")
