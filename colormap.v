module vtikz

pub enum Cmap{
	jet
	hot
	hot2
	blackwhite
	bluered
	cool
	grenyellow
	redyellow
	violet
	viridis
	pubu
}

fn (c Cmap) to_string() string {
	return match c {
		.jet { 'colormap/jet' }
		.hot { 'colormap/hot' }
		.hot2 { 'colormap/hot2' }
		.blackwhite { 'colormap/blackwhite' }
		.bluered { 'colormap/bluered' }
		.cool { 'colormap/cool' }
		.grenyellow { 'colormap/grenyellow' }
		.redyellow { 'colormap/redyellow' }
		.violet { 'colormap/violet' }
		.viridis { 'colormap/viridis' }
		.pubu { 'colormap/PuBu' }
	}
}