module main
import os
import time


pub enum Compiler {
	pdflatex
	texlive
}

struct Pref {
	font_size u8 = 12
	font_style string = "Arial"
mut:
	compiler Compiler = .pdflatex
	keep_tex bool
pub mut:
	legends bool
}

struct Enviroment {
	body &Enviroment
	name string
	header string
	content string
	foot string
}


fn set_parameters(parameters []string) string {
	mut result := '['
	for i in 0..parameters.len {
		result += parameters[i]
		if i != parameters.len - 1 {
			result += ', '
		}
	}
	result += ']'
	return result

}

const header := ["\\documentclass[tikz]{standalone}\n",
	"\\usepackage{pgfplots}\n",
	"\\usepackage{pgfplotstable}\n",
	"\\pgfplotsset{compat=1.18}\n",
	"\\begin{document}\n"]

pub struct Tikz {
mut:
	pref Pref
	axis Axis
pub mut:
	plots []Plot
}

pub enum Legend_pos {
	north_west
	north_east
	south_west
	south_east
}

fn (l Legend_pos) to_string() string {
	match l {
		.north_west {
			return 'north west'
		}
		.north_east {
			return 'north east'
		}
		.south_west {
			return 'south west'
		}
		.south_east {
			return 'south east'
		}
	}
}

pub enum Axis_line {
	left
	right
	box
	middle
	center
	@none
}

fn (a Axis_line) to_string() string {
	return match a {
		.left { 'left' }
		.right {'right'}		
		.box { 'box' }
		.middle { 'middle' }
		.center { 'center' }
		.@none { 'none' }		
	}	
}

pub struct Axis {
	ymajor_grids bool = true
pub:
	title string
	xlabel string = "x"
	ylabel string = "y"
	samples int = 100
mut:
	axis_line Axis_line = .left
	legend_pos Legend_pos = .north_west
	grid_style string = 'dashed'
	enlarge_limits bool = true
	xlim [2]f32
	ylim [2]f32
	xtick []f32
	ytick []f32
}

fn (a Axis) map_axis_to_string()map[string]string {
	mut result := map[string]string{}
	result['title'] = 'title = {${a.title}}'
	result['xlabel'] = 'xlabel = {${a.xlabel}}'
	result['ylabel'] = 'ylabel = {${a.ylabel}}'
	result['samples'] = 'samples = {${a.samples}}'
	result['domain'] = 'domain = {${a.xlim[0]}:${a.xlim[1]}}'
	if a.xtick.len != 0 {
		result['xtick'] = 'xtick = {${a.xtick}}'
	}
	if a.ytick.len != 0 {
		result['ytick'] = 'ytick = {${a.ytick}}'
	}
	result['legend_pos'] = 'legend pos = {${a.legend_pos.to_string()}}'
	result['grid_style'] = 'grid style = {${a.grid_style}}'
	result['ymajor_grids'] = 'ymajorgrids = {${a.ymajor_grids}}'	
	result['axis_line'] = 'axis lines = {${a.axis_line.to_string()}}'
	//result['enlarge_limits'] = 'enlarge limits = {${a.enlarge_limits}}'

	return result
}

fn (a Axis) to_string() string {
	mut s := ''
	s += '\\begin{axis}['
	data := a.map_axis_to_string()

	mut counter := 0
	for k, v in data {
		s += '${v}'	
		if counter < data.len - 1 {
			s += ',\n\t\t'
		}
		counter ++
	}	
	s += '\n\t]\n'
	
	return s
}

enum Mark_style {
	line
	square
	o
}

fn (m Mark_style) to_string() string {
	match m {
		.square {
			return 'square'
		}
		.o {
			return 'o'
		}
		.line {
			return 'none'
		}
	}
}

struct Function_plot {
	func string
	color string
}

struct Scatter_plot {
	x []f32
	y []f32
	color string
mut:
	mark Mark_style = .line
}

pub enum Color_map {
	jet
	hot
	hot2
	blackwhite
	bluered
	cool
	grenyellow
	redyellow
	violet
}

fn (c Color_map) to_string() string {
	return match c {
		.jet { 'jet' }
		.hot { 'hot' }
		.hot2 { 'hot2' }
		.blackwhite { 'blackwhite' }
		.bluered { 'bluered' }
		.cool { 'cool' }
		.grenyellow { 'grenyellow' }
		.redyellow { 'redyellow' }
		.violet { 'violet' }
	}
}

struct Heatmap {
	xy[][]f32
	z [][]f32
mut:
	colomap Color_map = .jet
}

pub type Plot_type = Scatter_plot | Function_plot | Heatmap

pub struct Plot {
	legend string
mut:
	plot Plot_type
	style string = 'solid'
}


pub fn Tikz.new(xlabel string, ylabel string, title string) Tikz {
	return Tikz {
		pref: Pref {
		},
		axis: Axis {
			title: title,
			xlabel: xlabel,
			ylabel: ylabel,
		},
	}
}


fn (mut t Tikz) add_scatter(x []f32, y []f32, color string, legend string) {
	if x.len != y.len {
		eprintln("Error: x and y must have the same length")
		return
	}

	t.plots << Plot {
		plot : Scatter_plot {
			x: x,
			y: y,
			color: color,
		},
		legend: legend,
	}

	xlim := [x[0], x[x.len - 1]]!
	t.axis.xlim = xlim
	if t.plots.len > 1 {
		t.pref.legends = true
	}
}

fn (mut t Tikz) add_function(func string, color string, legend string, xlim [2]f32) {
	t.plots << Plot {
		plot: Function_plot {
			func: func,
			color: color,
		},
		legend: legend,
	}
	mut limit := [f32(0), 0]!
	if xlim == [f32(0), 0]! {
		limit = [f32(-1.0), 1.0]!
	} else {
		limit = xlim
	}
	if limit[0] < t.axis.xlim[0] {
		t.axis.xlim[0] = limit[0]
	}
	if limit[1] > t.axis.xlim[1] {
		t.axis.xlim[1] = limit[1]
	}
	if t.plots.len > 1 {
		t.pref.legends = true
	}
}

fn set_command(command string, parameters []string, is_tikz bool) string {
	mut result := '\\${command}['
	for i in 0..parameters.len {
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

fn (t Tikz) axis_content() string {
	mut axis_content := ''
	for plot in t.plots {
		match plot.plot {
			Scatter_plot {
				axis_content += '\t' + set_command("addplot", ["color = ${plot.plot.color}", "mark=${plot.plot.mark.to_string()}"], true) + 'coordinates {\n'
				for i in 0..plot.plot.x.len {
					axis_content += '\t\t(${plot.plot.x[i]}, ${plot.plot.y[i]})\n'
				}	
				axis_content += '\t};\n'
			}
			Function_plot {
				axis_content += '\t' + set_command("addplot", ['color = ${plot.plot.color}', 'style = ${plot.style}'], true) + ' {${plot.plot.func}};\n'
			}
			else {
				eprintln("Error: Plot_type not implemented")
			}
		}
		if t.pref.legends {
			axis_content += '\t\\addlegendentry{${plot.legend}};\n'
		}
	}

	return axis_content
}

fn (t Tikz) to_enviroment() Enviroment {


	mut document := Enviroment {
		name: "document",
		body: &Enviroment {
			name: "tikzpicture",
			body: &Enviroment {
				name: 'axis'
				header: t.axis.to_string(),
				content: t.axis_content(),
				foot: '\\end{axis}\n',
				body : unsafe { nil }
			},
			header: "\\begin{tikzpicture}\n",
			foot: "\\end{tikzpicture}\n"
		},
		header: header.join(''),
		foot: "\\end{document}\n"
	}

	return document
}

fn (e Enviroment) to_string() string {

	mut result := e.header

	if e.body != unsafe { nil } {
		result += e.body.to_string()
	}	

	result += e.content

	result += e.foot

	return result
}

pub fn (t Tikz) plot(name string) {
	mut path := ''

	if name == '' {
		path = 'plot.tex'
	} else if !name.contains('.tex') {
		eprintln("Error: File must be a .tex file")
		eprintln("Creating plot.tex")
		path = 'plot.tex'
	} else {
		path = name
	}
	mut file := os.create(path) or {
		println("Error creating file")
		return
	}

	document := t.to_enviroment()

	file.write(document.to_string().bytes()) or {
		println("Error writing to file")
		return
	}

	file.close()

	compile(t, path)

	// Removing the auxiliar files

	time.sleep(1 * time.second)
	
	remove_aux(path)

	if !t.pref.keep_tex {
		os.rm(path) or {
			eprintln("Error: File not found")
		}
	}

	// Open file
	os.system('open ${path[0..path.len-4]}.pdf') 
}

fn compile(t Tikz, path string) {
	if t.pref.compiler == .pdflatex {
		os.system("pdflatex ${path}")
	} else if t.pref.compiler == .texlive {
		os.system("latexmk -pdf ${path}")
	} else {
		eprintln("Error: Compiler not found")
	}
}

fn remove_aux(path string) {
	for ext in ["aux", "log", "out", 'fls', 'fdb_latexmk', 'synctex.gz'] {
		os.rm("${path[0..path.len - 4]}.${ext}") or {
			eprintln("File: ${path[0..path.len-4]}.${ext} not found")
		}
	}
}

fn main() {
	mut tikz := Tikz.new("t [s]", "V [eV]", "Energy as a function of time")
	tikz.add_function("x^2", "red", "$ x^2$", [f32(-1.0), 1.0]!)
	tikz.pref.keep_tex = true
	//tikz.add_function("x^3", "black", "$ x^3$", [f32(-1.0), 1.0]!)
	//tikz.plots[1].style = 'dashed'
	tikz.add_scatter([f32(0.0), 1, 2, 3], [f32(0.0), 1, 4, 9], "blue", "Experimental")
	if tikz.plots[1].plot is Scatter_plot {
		tikz.plots[1].plot.mark = .o
	}
	//tikz.axis.axis_line = .middle
	//res := tikz.to_enviroment()
	tikz.plot('potential.tex')
}
