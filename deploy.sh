#! bin/bash

rm book/pacviz-book.pdf

echo "Running Examples"
Rscript ./examples/examples.r

echo "Converting Example PDFs to PNGs"
for pdfile in ./examples/figures/*.pdf ; do
	pdftoppm "${pdfile}" "${pdfile%.*}" -png
	mv "${pdfile%.*}-1.png" "${pdfile%.*}.png"
done

while getopts "dt" opt; do
	case "${opt}" in
    t)
				Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::gitbook', clean=TRUE, new_session = TRUE)"
				Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::pdf_book', clean=TRUE, new_session = TRUE)"

				pdfunite images/cover.pdf book/pacviz-book.pdf book/out.pdf
				mv book/out.pdf book/pacviz-book.pdf

				# pandoc book/pacviz-book.epub -f epub -t gfm -s -o README.md
			;;
		d)
				Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::gitbook', clean=TRUE, new_session = TRUE)"
				Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::pdf_book', clean=TRUE, new_session = TRUE)"

				pdfunite images/cover.pdf book/pacviz-book.pdf book/out.pdf
				mv book/out.pdf book/pacviz-book.pdf

        git add --all
        git commit -m "update book"
        git push origin gh-pages
        ;;
  esac
done
