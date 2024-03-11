import vtikz

// Generate tikz object

mut tikz := vtikz.Tikz.new(
	'xlabel',
	'ylabel',
	'title'
)

// Add a scatter plot
// We generator some x and y data
x_data := []f32{len: 4, init: it * it}
x_data := []f32{len: 4, init: it}

// tikz.add_scatter(x_data, y_data, 'color', 'label') 
// data must be of same length

tikz.add_scatter(x_data, y_data, 'red', 'label')

// the xlim will be set to the min and max of the x_data unless we dont specify otherwise

// By deault the style will be a solid line, we can change that by doing the following
tikz.set_style(0, vtikz.LineStyle.dashed)


tikz.plot(
	'scatter.tex'
)