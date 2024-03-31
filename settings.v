module vtikz


pub fn (mut t Tikz) set_compiler(compiler Compiler) {
	t.pref.compiler = compiler
}

pub fn (mut t Tikz) set_keep_tex(keep bool) {
	t.pref.keep_tex = keep
}

pub fn (mut t Tikz) set_open_pdf(open bool) {
	t.pref.open_pdf = open
}

pub fn (mut t Tikz) set_show_legends(show bool) {
	t.pref.show_legends = show
}

pub fn (mut t Tikz) set_samples(samples int) {
	t.axis.samples = samples
}

pub fn (mut t Tikz) set_mark(index int, mark Mark) {
	if index >= t.plots.len {
		eprintln("Error: Index out of range")
		return
	}
	
	if t.plots[index].plot is Scatter_plot {
		t.plots[index].plot.mark = mark
	} else {
		eprintln("Error: Plot is not a scatter plot")
		return
	}
}

pub fn (mut t Tikz) set_style(index int, style Style) {
	if index >= t.plots.len {
		eprintln("Error: Index out of range")
		return
	}
	t.plots[index].style = style
}

pub fn (mut t Tikz) set_fill(fill Fill) {
	t.axis.options_3d.fill = fill
}

pub fn (mut t Tikz) set_cmap(c Cmap) {
	t.axis.options_3d.cmap = c
}

pub fn (mut t Tikz) set_legend_pos(pos Legend_pos) {
	t.axis.legend_pos = pos
}

pub fn (mut t Tikz) set_axis_line(line Axis_line) {
	t.axis.axis_line = line
}

pub fn (mut t Tikz) set_xtick(ticks []f32) {
	t.axis.xtick = ticks
}

pub fn (mut t Tiks) set_grid(t bool) {
	t.axis.grid = t
}