import vtikz

mut tikz := Tikz.new("t [s]", "V [eV]", "Energy as a function of time")

tikz.add_function("x^2", "red", "$ x^2$", [f32(-1.0), 1.0]!)

// Keeps the .tex file in the working directory
// tikz.pref.keep_tex = true

tikz.add_scatter([f32(0.0), 1, 2, 3], [f32(0.0), 1, 4, 9], "blue", "Experimental")
if tikz.plots[1].plot is Scatter_plot {
	tikz.plots[1].plot.mark = .o
}
tikz.plot('potential.tex')