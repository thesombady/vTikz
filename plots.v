module vtikz

struct Function_plot {
	func string
	color string
}

struct Scatter_plot {
	x []f32
	y []f32
	color string
mut:
	mark Mark = .line
}

struct Function3d {
	func string
	type_ Plot3d_type
}

struct Scatter3d {
	z []f32
	x []f32
	y []f32
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
type Plot_type = Scatter_plot | Function_plot | Scatter3d | Function3d

struct Plot {
	legend string
mut:
	plot Plot_type
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

fn (m Mark_style) to_string() string {
	return match m {
		.square { 'square' }
		.o { 'o' }
		.line { 'none' }
	}
}