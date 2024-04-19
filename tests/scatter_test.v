import vtikz

// Generate tikz object

fn test_scatter() {
	mut tikz := vtikz.Tikz.new('xlabel', 'ylabel', 'title')

	// Add a scatter plot
	// We generator some x and y data
	x_data := []f64{len: 4, init: index * index}
	y_data := []f64{len: 4, init: index}

	// tikz.add_scatter(x_data, y_data, 'color', 'label')
	// data must be of same length

	tikz.scatter(x: x_data, y: y_data, color: .red)

	tikz.set_mark(0, vtikz.Mark.square)

	tikz.set_style(0, vtikz.Style.dashed)

	tikz.set_compiler(.pdflatex)

	tikz.set_keep_tex(true)

	tikz.plot('scatter.tex')
}
