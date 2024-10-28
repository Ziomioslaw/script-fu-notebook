(define (script-fu-replace-color image drawable color-to-replace new-color)
  (gimp-context-push)
  (gimp-image-undo-group-start image)

  (gimp-context-set-foreground color-to-replace)
  (gimp-by-color-select drawable color-to-replace 0 0 0 0 0 0)
  (gimp-context-set-foreground new-color)
  (gimp-edit-fill drawable FOREGROUND-FILL)
  (gimp-displays-flush)

  (gimp-image-undo-group-end image)
  (gimp-context-pop)
)

(script-fu-register
  "script-fu-replace-color"
  "Replace Colour"
  "Replace all occurrences of a color with another"
  "Ziomioslaw"
  "GPL3"
  "2024"
  "*"
  SF-IMAGE "Image" 0
  SF-DRAWABLE "Drawable" 0
  SF-COLOR "Color to Replace" '(255 255 255)
  SF-COLOR "New Color" '(0 0 0)
)

(script-fu-menu-register "script-fu-replace-color" "<Image>/Filters/Custom")
