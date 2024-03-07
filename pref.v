module vtikz


pub enum Compiler {
	@none
	pdflatex
	texlive
}

struct Pref {
	font_size u8 = 12
	font_style string = "Arial"
mut:
	compiler Compiler = .pdflatex
	keep_tex bool
	open_pdf bool = true
pub mut:
	show_legends bool
}