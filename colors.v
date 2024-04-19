module vtikz

pub enum Color {
	black
	red
	blue
	green
	magenta
	cyan
	yellow
	white
}

fn (c Color) to_string() string {
	return match c {
		.black { 'black' }
		.red { 'red' }
		.blue { ' blue' }
		.green { 'green' }
		.magenta { 'magenta' }
		.cyan { 'cyan' }
		.yellow { 'yellow' }
		.white { 'white' }
	}
}

fn match_string_to_color(s string) Color {
	return match s {
		'red' { .red }
		'black' { .black }
		'blue' { .blue }
		'magenta' { .magenta }
		'yellow' { .yellow }
		'white' { .white }
		'cyan' { .cyan  }
		else { .black }
	}
}
