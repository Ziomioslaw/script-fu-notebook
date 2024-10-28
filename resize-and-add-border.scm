(define (resize-and-add-border image drawable)
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

	(gimp-image-undo-group-end image)
	(gimp-displays-flush)
)

(script-fu-register "resize-and-add-border"
	"<Image>/Script-Fu/Resize and add border"
	"Automatically adjust contrast of drawable"
	"Ziomioslaw"
	"GPL3"
	"2022"
	"*"
	SF-IMAGE "Image" 0
	SF-DRAWABLE "Current Layer" 0
)
