module vtikz


pub fn (mut t Tikz) set_compiler(compiler vtikz.Compiler) {
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

pub fn (mut t Tikz) set_mark(index int, mark vtikz.Mark) {
	if index >= t.plots.len {
		eprintln("Error: Index out of range")
		return
	}
	t.plots[index].mark = mark
}

pub fn (mut t Tikz) set_style(index int, style vtikz.Style) {
	if index >= t.plots.len {
		eprintln("Error: Index out of range")
		return
	}
	t.plots[index].style = style
}

pub fn (mut t Tikz) set_fill(fill vtikz.Fill) {
	t.axis.axis_3d.fill = fill
}