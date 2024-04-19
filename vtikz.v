module vtikz

import os
import time
// import math

// set_parameters([]string) returns a string with the parameters
fn set_parameters(parameters []string) string {
	mut result := '['
	for i in 0 .. parameters.len {
		result += parameters[i]
		if i != parameters.len - 1 {
			result += ', '
		}
	}
	result += ']'
	return result
}

pub struct Tikz {
mut:
	axis Axis
pub mut:
	plots []Plot
	pref  Pref
}

// Tikz.new(string, string, string) creates a new Tikz object
pub fn Tikz.new(xlabel string, ylabel string, title string) Tikz {
	return Tikz{
		pref: Pref{}
		axis: Axis{
			title: title
			xlabel: xlabel
			ylabel: ylabel
		}
	}
}

@[param]
pub struct Scatter_args {
pub:
	x      []f64  @[required]
	y      []f64  @[required]
	legend string
	color  Color
}

// t.add_scatter([]f32, []f32, string, string) adds a scatter plot to the Tikz object
pub fn (mut t Tikz) scatter(s Scatter_args) {
	if s.x.len != s.y.len {
		eprintln('Error: x and y must have the same length')
		return
	}

	for i in 0 .. t.plots.len {
		if t.plots[i].plot is Function3d || t.plots[i].plot is Scatter3d {
			eprintln('Error: 3d plots only support a single input')
			return
		}
	}

	t.plots << Plot{
		plot: Scatter_plot{
			x: s.x.map(f32(it))
			y: s.y.map(f32(it))
			color: s.color
		}
		legend: s.legend
	}

	xlim := [f32(s.x[0]), f32(s.x[s.x.len - 1])]!
	t.axis.xlim = xlim
	if t.plots.len > 1 {
		t.pref.show_legends = true
	}
}

@[param]
pub struct Function_args {
pub:
	func   string @[required]
	color  Color
	legend string
	xlim   [2]f64 = [0.0, 1.0]!
}

pub fn (mut t Tikz) function(f Function_args) {
	for i in 0 .. t.plots.len {
		if t.plots[i].plot is Function3d || t.plots[i].plot is Scatter3d {
			eprintln('Error: 3d plots only support a single input')
			return
		}
	}
	// Adding plots to the tikz figure
	t.plots << Plot{
		plot: Function_plot{
			func: f.func
			color: f.color
		}
		legend: f.legend
	}

	if t.axis.xlim[0] > f32(f.xlim[0]) {
		t.axis.xlim[0] = f32(f.xlim[0])
	}
	if t.axis.xlim[1] < f32(f.xlim[1]) {
		t.axis.xlim[1] = f32(f.xlim[1])
	}

	if t.plots.len > 1 {
		t.pref.show_legends = true
	}
}

// t.add_function3d(string, [2]f32, [2]f32, Plot3d_type) adds a 3d function to the Tikz object

@[param]
pub struct Function3_args {
pub:
	func    string      @[required]
	legend  string
	xlim    [2]f64 = [-1.0, 1.0]!
	ylim    [2]f64 = [-1.0, 1.0]!
	type_   Plot3d_type
	as_heap bool
}

pub fn (mut t Tikz) function3(f Function3_args) {
	if t.plots.len > 0 {
		eprintln('Error: Heatmaps only support a single input')
		return
	}
	t.plots << Plot{
		plot: Function3d{
			func: f.func
			type_: f.type_
		}
	}
	t.axis.xlim = [f32(f.xlim[0]), f32(f.xlim[1])]!
	t.axis.samples = 20
	t.axis.options_3d = &Options_3d{
		ydomain: [f32(f.ylim[0]), f32(f.ylim[1])]!
		as_heap: f.as_heap
	}
}

pub struct Scatter3_args[T] {
pub:
	data    [][]T       @[required]
	xlim    [2]f64 = [-1.0, 1.0]!
	ylim    [2]f64 = [-1.0, 1.0]!
	type_   Plot3d_type
	as_heap bool
}

// t.add_scatter3d([]f32, []f32, []f32, Plot3d_type) adds a 3d scatter plot to the Tikz object
pub fn (mut t Tikz) scatter3[T](s Scatter3_args[T]) {
	if t.plots.len > 0 {
		eprintln('Error: Heatmaps only support a single input')
		return
	}
	// data [][]T Has to has x - y - z where dim(data) = x[0] -> x[-1] X y[0] -> y[-1]

	t.plots << Plot{
		plot: Scatter3d{
			table: s.data.map(it.map(f32(it)))
		}
	}
	t.axis.xlim = [f32(s.xlim[0]), f32(s.xlim[1])]!

	t.axis.options_3d = &Options_3d{
		ydomain: [f32(s.ylim[0]), f32(s.ylim[1])]!
		as_heap: s.as_heap
	}
}

pub fn (mut t Tikz) draw(points []f32) {
	if points.len % 2 != 0 && points.len > 2 {
		eprintln("Must contain x-y pairs and can't be a point")
		return
	}

	mut plot := Draw{}
	for i := 0; i < points.len - 1; i += 2 {
		plot.points << Point{
			x: points[i]
			y: points[i + 1]
		}
	}

	t.plots << Plot{
		plot: Plot_type(plot)
	}
}

// set_command(string, []string, bool) returns a string with the command
fn set_command(command string, parameters []string, is_tikz bool) string {
	mut result := '\\${command}['
	for i in 0 .. parameters.len {
		result += parameters[i]
		if i != parameters.len - 1 {
			result += ', '
		}
	}
	result += ']'
	if is_tikz {
		return result
	}
	return result + '\n'
}

// t.clear() removes all the plots and clears the axis & preferences
pub fn (mut t Tikz) clear() {
	t.plots = []
	t.axis = Axis{}
	t.pref = Pref{}
}

// t.plot(string) creates a .tex file with the plot
pub fn (t Tikz) plot(name string) {
	mut path := ''

	if name == '' {
		path = 'plot.tex'
	} else if !name.contains('.tex') {
		eprintln('Error: File must be a .tex file')
		eprintln('Creating plot.tex')
		path = 'plot.tex'
	} else {
		path = name
	}
	mut file := os.create(path) or {
		println('Error creating file')
		return
	}

	document := t.to_enviroment()

	file.write(document.to_string().bytes()) or {
		println('Error writing to file')
		return
	}

	file.close()

	if t.pref.compiler != .@none {
		compile(t, path)
		// Removing the auxiliar files
		time.sleep(1 * time.second) // Wait such that everything has compiled

		remove_aux(path)

		if !t.pref.keep_tex {
			os.rm(path) or { eprintln('Error: File not found') }
		}

		// Open file
		if t.pref.open_pdf {
			os.system('open ${path[0..path.len - 4]}.pdf')
		}
	}
}

// t.compile(string) compiles the .tex file
fn compile(t Tikz, path string) {
	if t.pref.compiler == .pdflatex {
		os.system('pdflatex ${path}')
	} else if t.pref.compiler == .texlive {
		os.system('latexmk -pdf ${path}')
	} else if t.pref.compiler == .lualatex {
		os.system('lualatex ${path}')
	} else {
		eprintln('Error: Compiler not found')
	}
}

// remove_aux(string) removes the auxiliar files
fn remove_aux(path string) {
	for ext in ['aux', 'log', 'out', 'fls', 'fdb_latexmk', 'synctex.gz'] {
		os.rm('${path[0..path.len - 4]}.${ext}') or {
			eprintln('File: ${path[0..path.len - 4]}.${ext} not found')
		}
	}
}
