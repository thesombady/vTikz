module vtikz

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

struct Axis_3d {
mut:
	cmap Color_map = .jet
	cbar bool = true
	box bool = true
	zlabel string = "z"
	ydomain [2]f32 = [f32(-1.0), 1.0]!
pub mut:
	fill Fill 
}

pub enum Fill {
	@none
	white
	black
	yellow
	red
	blue
	green
}

fn (f Fill) to_string() string {
	return match f {
		.@none { 'none' }
		.white { 'white' }
		.black { 'black' }
		.yellow { 'yellow' }
		.red { 'red' }
		.blue { 'blue' }
		.green { 'green' }
	}
}

struct Axis {
	ymajor_grids bool = true
pub:
	title string
	xlabel string = "x"
	ylabel string = "y"
mut:
	samples int = 100
	axis_line Axis_line = .left
	legend_pos Legend_pos = .north_west
	grid_style string = 'dashed'
	enlarge_limits bool = true
	xlim [2]f32 = [f32(-1.0), 1.0]!
	xtick []f32
	ytick []f32

	// 3D plots
	axis_3d &Axis_3d = unsafe { nil }
}

fn (a Axis) map_axis_to_string()map[string]string {
	// TODO: Change to array?
	mut result := map[string]string{}
	if a.axis_3d != unsafe{ nil } {
		result['colormap'] = '{${a.axis_3d.cmap.to_string()}}'
		if a.axis_3d.cbar {
			result['colorbar'] = '{colorbar}'
		}
		//result['box'] = 'box = {${a.axis_3d.box}}'
		result['zlabel'] = 'zlabel = {${a.axis_3d.zlabel}}'
		result['y_domain'] = 'y domain = {${a.axis_3d.ydomain[0]}:${a.axis_3d.ydomain[1]}}'
	}
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
	
	// Include?
	//result['enlarge_limits'] = 'enlarge limits = {${a.enlarge_limits}}'

	return result
}

fn (a Axis) to_string() string {
	mut s := ''
	s += '\\begin{axis}['

	data := a.map_axis_to_string()

	mut counter := 0
	for _, v in data {
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
	return match m {
		.square { 'square' }
		.o { 'o' }
		.line { 'none' }
	}
}