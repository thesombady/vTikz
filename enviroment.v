module vtikz

const preamble = ['\\documentclass[tikz]{standalone}', '\\usepackage{pgfplots}',
	'\\usepackage{pgfplotstable}', '\\pgfplotsset{compat=1.18}', '\\begin{document}',
	'\\usepgfplotslibrary{colorbrewer}\n']

struct Enviroment {
	body    &Enviroment
	name    string
	header  string
	content string
	foot    string
}

fn (t Tikz) to_enviroment() Enviroment {
	mut content := []string{len: t.plots.len}

	mut document := Enviroment{
		name: 'document'
		body: &Enviroment{
			name: 'tikzpicture'
			body: &Enviroment{
				name: '${t.axis.axis_style.to_string()}'
				header: t.axis.to_string()
				content: t.content(mut content, 0)
				foot: '\\end{${t.axis.axis_style.to_string()}}\n'
				body: unsafe { nil }
			}
			header: '\\begin{tikzpicture}\n'
			foot: '\\end{tikzpicture}\n'
		}
		header: vtikz.preamble.join('\n')
		foot: '\\end{document}\n'
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

// t.content() returns the content of the axis
fn (t Tikz) content(mut axis_content []string, idx int) string {
	id := t.plots[idx]
	match id.plot {
		Scatter_plot {
			axis_content[idx] += '\t' +
				set_command('addplot', ['color = ${id.plot.color.to_string()}', 'mark=${id.plot.mark.to_string()}', 'style = ${id.style.to_string()}'], true) +
				'coordinates {\n'
			for i in 0 .. id.plot.x.len {
				axis_content[idx] += '\t\t(${id.plot.x[i]}, ${id.plot.y[i]})\n'
			}
			axis_content[idx] += '\t};\n'
		}
		Function_plot {
			axis_content[idx] += '\t'
				set_command('addplot', ['color = ${id.plot.color.to_string()}', 'style = ${id.style.to_string()}'], true) +
				' {${id.plot.func}};\n'
		}
		Scatter3d {
			// panic('Not yet implemented correctly')
			axis_content[idx] += '\t'
			axis_content[idx] += set_command('addplot3+', [
				'${id.plot.type_.to_string()}',
				'shader=faceted',
			], true)
			axis_content[idx] += table_to_string(id.plot.table, t.axis.xlim, t.axis.options_3d.ydomain)
		}
		Function3d {
			if t.axis.options_3d.fill != .@none {
				axis_content[idx] += '\t'

				axis_content[idx] += set_command('addplot3', [
					id.plot.type_.to_string(),
					'fill = ${t.axis.options_3d.fill}',
				], true)
				axis_content[idx] += ' {${id.plot.func}};\n'
			} else {
				axis_content[idx] += '\t'

				axis_content[idx] += set_command('addplot3', [
					id.plot.type_.to_string(),
				], true)
				axis_content[idx] += ' {${id.plot.func}};\n'
			}
		}
		Draw {
			axis_content[idx] += '\t' + set_command('draw', ['dashed, thin'], true)
			for i in 0 .. id.plot.points.len {
				axis_content[idx] += id.plot.points[i].to_string()
				if i < id.plot.points.len - 1 {
					axis_content[idx] += '--'
				} else {
					axis_content[idx] += ';\n'
				}
			}
		}
	}
	if t.pref.show_legends {
		axis_content[idx] += '\t\\addlegendentry{${id.legend}};\n'
	}

	if idx < t.plots.len - 1 {
		return t.content(mut axis_content, idx + 1)
	}

	return axis_content.join('')
}

fn table_to_string(table [][]f32, xlim [2]f32, ylim [2]f32) string {
	mut t := ''
	t += 'table {\n\t\t'
	n := table.len
	m := table[0].len
	dx := (xlim[1] - xlim[0]) / f32(n - 1)
	dy := (ylim[1] - ylim[0]) / f32(m - 1)
	for i in 0 .. n {
		for j in 0 .. m {
			t += '${xlim[0] + dx * i}\t${ylim[0] + dy * j}\t${table[i][j]}'
			if i * j < m * n - 2 {
				if j == m - 1 {
					t += '\n'
				}
				t += '\t\n\t\t'
			}
		}
	}

	t += '};\n'
	return t
}
