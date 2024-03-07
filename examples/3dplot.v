import vtikz

// Define the tikz instance


mut tikz := Tikz.new('x', 'y', 'Potential')
tikz.add_function3d('exp(e^(-x^2 - y^2))', [f32(-2.0), 2.0]!, [f32(-2.0), 2.0]!, .surface)
// change the colormap and the background color
tikz.axis.axis_3d.cmap = .cool
tikz.axis.axis_3d.fill = 'black'
tikz.plot('potential.tex')