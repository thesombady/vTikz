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

// By default, the plot will ahve marker style of a line, we can change that
if tikz.plot[0].plot is Scatter_plot {
	tikz.plot[0].plot.marker_style = .o // Now it will be circles
}

tikz.plot(
	'scatter.tex'
)