module vtikz

struct Function_plot {
	func  string
	color Color
}

struct Point {
	x f32
	y f32
}

fn (p Point) to_string() string {
	return '(${p.x}, ${p.y})'
}

struct Draw { // TODO: Inline so that scale matches
mut:
	points     []Point
	legend_pos Legend_pos
	str        ?string
}

struct Scatter_plot {
	x     []f32
	y     []f32
	color Color
mut:
	mark Mark = .line
}

struct Function3d {
	func  string
	type_ Plot3d_type
}

struct Scatter3d {
	table [][]f32
	type_ Plot3d_type
}

pub enum Plot3d_type {
	mesh
	surface
	line
	scatter
}

fn (p Plot3d_type) to_string() string {
	return match p {
		.mesh { 'mesh' }
		.surface { 'surf' }
		.line { 'line' }
		.scatter { 'scatter' }
	}
}

type Plot_type = Draw | Function3d | Function_plot | Scatter3d | Scatter_plot

struct Plot {
	legend string
mut:
	plot  Plot_type
	style Style = .solid
}

pub enum Style {
	solid
	dashed
	dotted
}

fn (s Style) to_string() string {
	return match s {
		.solid { 'solid' }
		.dashed { 'dashed' }
		.dotted { 'dotted' }
	}
}

pub enum Mark {
	line
	square
	o
}

fn (m Mark) to_string() string {
	return match m {
		.square { 'square' }
		.o { 'o' }
		.line { 'none' }
	}
}
