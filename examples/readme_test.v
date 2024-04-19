import vtikz

fn test_readme() {
	x := [f32(1), 2, 3, 4, 5]
	y := [f32(1), 4, 10, 15, 26] // Assume this to be experimental data of x^2

	mut tikz := vtikz.Tikz.new(
		'x', // xlabel
		'y', // ylabel
		'Our first plot'
	)

	tikz.add_scatter(x, y, 'blue', 'Experimental data') // We add the scatter data

	tikz.add_function(
		"x^2", // The function
		'red', // The color
		'Fitted data', // The line style
		[f32(3), 5]! // The range of x (Not in agreement with the data, but for the sake of the example)
	)

	// When adding the second plot the xlimits are set to the range of the enitre data set, i.e. [1, 5]!, and vtikz will automatically show the legends when adding the second plot

	// We can change the compiler by changing the preference structure
	// tikz.set_compiler(vtikz.Compiler.texlive)
	// The default is .pdflatex and we have .@none

	// If we dont want the .tex file to be compiled, we can set the field keep_tex to true
	assert 1 == 1, 'This is a test'

	// If we dont want the pdf to automatically open, we do the following:
	//tikz.set_open_pdf(false)

	// Note, all the auxiliary files are deleted.

	// If you want to change the legend position, you can do the following:

	//tikz.set_legend_pos(vtikz.Legend_pos.north_east) // This is the same as the above

	// If you want to change the alignment of the graph, you can do the following:

	// If the standard tick labels are not what you want, you can change them by doing the following:

	//tikz.set_compiler(vtikz.Compiler.@none)

	tikz.set_xtick([f32(1), 2.5, 5])//All values must be f32.

	tikz.plot('scatter_plot.tex') // Save the plot to a .tex file

}
