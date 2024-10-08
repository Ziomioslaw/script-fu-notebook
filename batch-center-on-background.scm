; ----------------
; This function open background picture, places the input-file on top, then save whole as out-file.
;
(define (center-on-background background-file input-file output-file)
(let* (
    (input-image (car (gimp-file-load RUN-NONINTERACTIVE input-file input-file)))
    (background-image (car (gimp-file-load RUN-NONINTERACTIVE background-file background-file)))
    (input-layer (car (gimp-image-get-active-layer input-image)))
    (bg-width (car (gimp-image-width background-image)))
    (bg-height (car (gimp-image-height background-image)))
    (input-width (car (gimp-image-width input-image)))
    (input-height (car (gimp-image-height input-image)))
    (x-pos (/ (- bg-width input-width) 2))
    (y-pos (/ (- bg-height input-height) 2))
  )

  (gimp-edit-copy input-layer)
  (let* (
      (new-layer (car (gimp-layer-new background-image bg-width bg-height RGBA-IMAGE "Layer" 100 NORMAL-MODE)))
    )

    (gimp-image-add-layer background-image new-layer -1)
    (gimp-image-set-active-layer background-image new-layer)
    (gimp-edit-paste new-layer TRUE)
    (gimp-layer-set-offsets new-layer x-pos y-pos)
    (gimp-floating-sel-anchor (car (gimp-image-get-active-layer background-image)))
  )

  (gimp-image-flatten background-image)
  (gimp-file-save RUN-NONINTERACTIVE background-image (car (gimp-image-get-active-layer background-image)) output-file output-file)

  (gimp-image-delete input-image)
  (gimp-image-delete background-image)
))

(define (filename-from-path path)
  (car (reverse (strbreakup path "/")))
)

(define (basename-from-filename file-name)
  (car (strbreakup file-name "."))
)

; ----------------
; This function allow run the base script in batch mode:
;  gimp -i -b '(batch-center-on-background-batch "tlo.jpg" "input/*.jpg" "output" )' -b '(gimp-quit 0)'
;
(define (center-on-background-batch background-file input-pattern result-directory)
(let* (
    (files (cadr (file-glob input-pattern 1)))
  )
  (while (not (null? files))
    (let* (
        (file-name (car files))
        (output-filename (string-append result-directory "/" (basename-from-filename (filename-from-path file-name)) ".jpg"))
      )
      (center-on-background background-file file-name output-filename)
    )

    (set! files (cdr files))
  )
))
