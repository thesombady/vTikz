module vtikz
import os
import time
import math

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
	"\\begin{document}\n",
	"\\usepgfplotslibrary{colorbrewer}\n"]

pub struct Tikz {
mut:
	axis Axis
pub mut:
	plots []Plot
	pref Pref
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


pub fn (mut t Tikz) add_scatter(x []f32, y []f32, color string, legend string) {
	
	if x.len != y.len {
		eprintln("Error: x and y must have the same length")
		return
	}

	for i in 0..t.plots.len {
		if t.plots[i].plot is Function3d || t.plots[i].plot is Scatter3d {
			eprintln("Error: 3d plots only support a single input")
			return
		}
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
		t.pref.show_legends = true
	}
}

pub fn (mut t Tikz) add_function(func string, color string, legend string, xlim [2]f32) {
	for i in 0..t.plots.len {
		if t.plots[i].plot is Function3d || t.plots[i].plot is Scatter3d {
			eprintln("Error: 3d plots only support a single input")
			return
		}
	}
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
		t.pref.show_legends = true
	}
}

pub fn (mut t Tikz) add_function3d(func string, xlim [2]f32, ylim [2]f32, type_ Plot3d_type) {
	if t.plots.len > 0 {
		eprintln("Error: Heatmaps only support a single input")
		return
	}
	t.plots << Plot {
		plot: Function3d{
			func: func,
			type_: type_,
		},
	}
	t.axis.xlim = xlim
	t.axis.samples = 20
	t.axis.axis_3d = &Axis_3d{ydomain: ylim}
}

pub fn (mut t Tikz) add_scatter3d(z []f32, x []f32, y []f32, type_ Plot3d_type) {
	if t.plots.len > 0 {
		eprintln("Error: Heatmaps only support a single input")
		return
	}
	// We compute the equispaced grid as the xy
	if x.len * y.len != z.len {
		eprintln("The sum of elements in x and y must be equal to the length of z")
		eprintln("Not ${x.len} * ${y.len}  = ${z.len}")
		return
	}	

	t.plots << Plot {
		plot: Scatter3d {
			x: x,
			y: y,
			z: z,
			type_: .surface,
		},
	}

	t.axis.axis_3d = &Axis_3d{}
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

fn (t Tikz) content(mut axis_content []string, idx int) string {
	id := t.plots[idx]
	match id.plot{
		Scatter_plot {
			axis_content[idx] += '\t' + set_command("addplot", ["color = ${id.plot.color}", "mark=${id.plot.mark.to_string()}"], true) + 'coordinates {\n'
			for i in 0..id.plot.x.len {
				axis_content[idx] += '\t\t(${id.plot.x[i]}, ${id.plot.y[i]})\n'
			}	
			axis_content[idx] += '\t};\n'
		}
		Function_plot {
			axis_content[idx] += '\t' + set_command("addplot", ['color = ${id.plot.color}', 'style = ${id.style}'], true) + ' {${id.plot.func}};\n'
		}		
		Scatter3d {
			eprintln('Not yet implemented correctly')
			/*
			axis_content[idx] += '\t' + set_command("addplot3", ['${id.plot.type_.to_string()}'], true) + 'table {\n'
			length := id.plot.x.len
			x_data := id.plot.x
			y_data := id.plot.y
			for j in 0..length {
				for i in 0..length {
					axis_content[idx] += '\t\t ${x_data[i]} ${y_data[j]} ${id.plot.z[i + length * j]}\n'
				}
			}

			axis_content[idx] += '\t};\n'
			*/
		}
		Function3d {
			axis_content[idx] += '\t' + set_command("addplot3", [id.plot.type_.to_string(), 'fill = ${t.axis.axis_3d.fill}'], true) + ' {${id.plot.func}};\n'
		}
	}
	if t.pref.show_legends {
		axis_content[idx] += '\t\\addlegendentry{${id.legend}};\n'
	}
	
	if idx < t.plots.len -1 {
		return t.content(mut axis_content, idx + 1)
	}

	return axis_content.join('')
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

	if t.pref.compiler != .@none {
		compile(t, path)
		// Removing the auxiliar files
		time.sleep(1 * time.second) // Wait such that everything has compiled
		
		remove_aux(path)

		if !t.pref.keep_tex {
			os.rm(path) or {
				eprintln("Error: File not found")
			}
		}

		// Open file
		if t.pref.open_pdf {
			os.system('open ${path[0..path.len-4]}.pdf') 
		}
	}
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