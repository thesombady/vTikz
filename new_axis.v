module vtikz

pub enum Legend_pos {
	north_west
	north_east
	south_west
	south_east
}

fn (l Legend_pos) to_string() string {
	return match l {
		.north_west { 'north west' }
		.north_east { 'north east' }
		.south_west { 'south west' }
		.south_east { 'south east' }
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

pub enum Axis_style {
	@none
	log_x
	log_y
	log
}

fn (a Axis_style) to_string() string {
	return match a {
		.@none { 'axis' }
		.log_x { 'semilogyaxis' }
		.log_y { 'semilogxaxis' }
		.log { 'loglogaxis' }
	}
}
	
struct Options_3d {
mut:
	cmap Cmap = .jet
	cbar bool = true
	box bool = true
	zlabel string = "z"
	ydomain [2]f32 = [f32(-1.0), 1.0]!
pub mut:
	fill Fill 
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
	options_3d  &Options_3d = unsafe { nil } // We rework this
	axis_style Axis_style = .@none
}

fn (a Axis) map_options() map[string]string{
	mut result := map[string]string{}

	if a.options_3d != unsafe{ nil } {
		result['colormap'] = '${a.axis_3d.cmap.to_string()}'
		//result['box'] = 'box = {${a.axis_3d.box}}'
		result['zlabel'] = '{${a.axis_3d.zlabel}}'
		result['y domain'] = '{${a.axis_3d.ydomain[0]}:${a.axis_3d.ydomain[1]}}'
	}

	result['title'] = a.title
	result['xlabel'] = a.xlabel
	result['ylabel'] = a.ylabel
	result['samples'] = string(a.sample)
	result['domain'] = '${a.xlim[0]}:${a.xlim[1]}'
	result['legend pos'] = a.legend_pos.to_string()
	if a.xtick.len != 0 {
		mut xtick := ''
		for i, v in a.xtick {
			xtick += '${v}'
			if i < a.xtick.len - 1 {
				xtick += ','
			}
		}	
		result['xtick'] = xtick
	}
	if a.ytick.len != 0 {
		mut ytick := ''
		for i, v in a.ytick {
			ytick += '${v}'
			if i < a.ytick.len - 1 {
				ytick += ','
			}
		}
		result['ytick'] = ytick
	}
	result['grid style'] = a.grid_style
	result['ymajorgrids'] = string(a.ymajor_grids)
	result['axis lines'] = a.axis_line.to_string()
}

fn (a axis) to_string() string {
	mut result := '\\begin{${a.axis_style.to_string()}}['
	options := a.map_options()
	mut cbar = false

	if a.options_3d != unsafe { nil } {
		cbar = true
	}

	if cbar {
		result += 'colorbar,'

	}

	mut counter := 0
	for k, v in options {
		result += '${k} = {${v}}'
		if counter < options.len - 1 {
			result += ',\n\t\t'
		}
		else {
			result += ']'
		}
	}

	return result
}