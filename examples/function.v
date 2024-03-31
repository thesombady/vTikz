import vtikz

// Define the tikz object

mut tikz := vtikz.Tikz.new(
	'x [m/s]',
	'y [m]',
	'Velocity Squared',
)

/*
	tikz.add_function(
		function: string, e.g. 'x^2'
		color: string, e.g. 'red'
		legend: string, e.g. ' $ x^2$'
		xlim: [2]f32, e.g. [f32(-10), 10]!
	)
*/
tikz.add_function('x^2', 'red', '$ x^2$', [f32(-3), 3]!)
// Even though we give it a legend, it will not be shown unless we force it, or give another function
// tiks.set_show_legends(true)

tikz.plot('squared.tex')
// This will create a pdf file called squared.pdf
// It will remove the .tex file, and all the auxiliary files
// tikz.pref.keep_tex = true will keep the .tex file