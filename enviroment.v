module vtikz

const header := ["\\documentclass[tikz]{standalone}",
	"\\usepackage{pgfplots}",
	"\\usepackage{pgfplotstable}",
	"\\pgfplotsset{compat=1.18}",
	"\\begin{document}",
	"\\usepgfplotslibrary{colorbrewer}\n"]

struct Enviroment {
	body &Enviroment
	name string
	header string
	content string
	foot string
}


fn (t Tikz) to_enviroment() Enviroment {

	mut content := []string{len: t.plots.len}

	mut document := Enviroment {
		name: "document",
		body: &Enviroment {
			name: "tikzpicture",
			body: &Enviroment {
				name: 'axis'
				header: t.axis.to_string(),
				content: t.content(mut content, 0),
				foot: '\\end{axis}\n',
				body : unsafe { nil }
			},
			header: "\\begin{tikzpicture}\n",
			foot: "\\end{tikzpicture}\n"
		},
		header: vtikz.header.join('\n'),
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