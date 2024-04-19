import vtikz

// Define the tikz instance

fn test_3d() {
	mut tikz := vtikz.Tikz.new('x', 'y', 'Potential')
	tikz.function3(
		func: 'exp(e^(-x^2 - y^2))'
		xlim: [-2.0, 2.0]!
		ylim: [-2.0, 2.0]!
		type_: .surface
		as_heap: true
	)
	// change the colormap and the background color
	// tikz.axis.axis_3d.cmap = .cool
	// tikz.axis.axis_3d.fill = 'black'
	tikz.set_cmap(vtikz.Cmap.cool)
	tikz.set_fill(vtikz.Fill.black)
	tikz.set_keep_tex(true)
	tikz.set_compiler(.@none)
	tikz.plot('potential.tex')
}

fn test_scatter3d() {
	mut tikz := vtikz.Tikz.new('x', 'y', 'z')

	mut data := [][]f64{len: 20, init: []f64{len: 20, init: 0.0}}
	for i in 0 .. 20 {
		data[i][i] = 1
	}

	tikz.scatter3[f64](
		data: data
		// as_heap: true
		xlim: [0.0, 5.0]!
		ylim: [-1.0, 1.0]!
		type_: .mesh
	)

	tikz.set_cmap(.viridis)
	tikz.set_grid(true)

	tikz.set_keep_tex(true)
	tikz.set_compiler(.pdflatex)
	tikz.plot('3d.tex')
}
