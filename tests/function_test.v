
import vtikz

// Define the tikz object

fn test_function() {
	mut tikz := vtikz.Tikz.new('s [t]', 'height [m]', 'Height of a ball thrown up in the air')

	/*

		tikz.add_function(
			function: string, e.g. 'x^2'
			color: string, e.g. 'red'
			legend: string, e.g. ' $ x^2$'
			xlim: [2]f32, e.g. [f32(-10), 10]!
		)
	*/
	tikz.function( func: '-0.5 * x^2 + 0.5', color: .red)
	// tikz.add_function('-0.5 * x^2 + 0.5', 'red', '$ x^2$', [f32(0.1), 1]!)
	tikz.draw([f32(0), 0, 1, 2])
	// Even though we give it a legend, it will not be shown unless we force it, or give another function
	// tikz.set_show_legeneds(true)

	tikz.set_keep_tex(true)
	tikz.set_compiler(.@none)

	tikz.plot('squared.tex')
	// This will create a pdf file called squared.pdf
	// It will remove the .tex file, and all the auxiliary files
	// tikz.pref.keep_tex = true will keep the .tex file
}
