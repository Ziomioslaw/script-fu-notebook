(define (resize-into-square image drawable)
  (gimp-image-undo-group-start image)
  (plug-in-autocrop RUN-NONINTERACTIVE image drawable)

  (let* (
      (current-width (car (gimp-image-width image)))
      (current-height (car (gimp-image-height image)))
      (square-size (if
          (or (> current-width 1490) (> current-height 1490))
          1500
          (+ (max current-width current-height) 10)
      ))
      (wanted-width (min (- square-size 10) current-width))
      (wanted-height (min (- square-size 10) current-height))
      (ratio (min (/ wanted-width current-width) (/ wanted-height current-height)))
      (width (* ratio current-width))
      (height (* ratio current-height))
    )

    (gimp-image-scale image width height)
    (gimp-image-resize image square-size square-size (/ (- square-size width) 2) (/ (- square-size height) 2))
  )

  (gimp-layer-resize-to-image-size drawable)
  (gimp-image-undo-group-end image)
  (gimp-displays-flush)
)

; ----------------
; This function allow run the base script in batch mode:
;  gimp -i -b '(resize-into-square-save "*.png")' -b '(gimp-quit 0)'
;
(define (resize-into-square-save pattern)
  (let* (
      (filelist (cadr (file-glob pattern 1)))
    )

    (while (not (null? filelist))
      (let* (
          (file-name (car filelist))
          (image (car (gimp-file-load RUN-NONINTERACTIVE file-name file-name)))
          (drawable (car (gimp-image-get-active-layer image)))
          (file-name-without-extension (unbreakupstr (butlast (strbreakup file-name ".")) "."))
        )

        (resize-into-square image drawable)

        (gimp-file-save RUN-NONINTERACTIVE image drawable (string-append file-name-without-extension ".xcf") (string-append file-name-without-extension ".xcf"))

        (gimp-layer-flatten drawable)
        (gimp-file-save RUN-NONINTERACTIVE image drawable (string-append file-name-without-extension ".jpg") (string-append file-name-without-extension ".jpg"))

        (gimp-image-delete image)
      )

      (set! filelist (cdr filelist))
    )
  )
)

(script-fu-register "resize-into-square"
    "<Image>/Script-Fu/Resize and add border"
    "Automatically adjust contrast of drawable"
    "Ziomioslaw"
    "Ziomioslaw"
    "2022"
    "*"
    SF-IMAGE "Image" 0
    SF-DRAWABLE "Current Layer" 0
)
