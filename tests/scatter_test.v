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



tikz.plot(
	'scatter.tex'
)