
# vTikz

A simple design to generate standalone tikz images in V.

## Installation

To install vtikz, run the following command in your shell/terminal:

```bash
v install --git https://github.com/thesombady/vtikz
```

This requires the V package manager to be installed, and for compiling the generated .tex file, a LaTeX distribution is required with tikz and pgfplots, for example: texlive, miktex, etc.
One change the latex compiler by changing the `compiler` field in the preference structure.

## Usage

For examples, see the [Examples](examples) directory.

The following are the types of plots that can be created in vTikz:

1. Scatter Plots
    * Scatter plots are a series of data, where each data point is represented by a marker. These markers can be customized to different shapes.
    * The markers are connected by lines by default, but this can be changed.
2. Function plots (2d)
    * Functions are represented as a string, e.g. "x^2 + 2x + 1", which would be a quadratic function in "x".
    * The function can be customized to have different colors and line styles (dashed, thin, thick, etc.).
3. Function plots (3d)
    * Functions are represented as a string in the form 'z = f(x, y)', where 'z' is the dependent variable and 'x' and 'y' are the independent variables, e.g. "x^2 + y^2".
    * This mode supports mesh, surface and line plots. Each of these can be customized with the color map, and in the specific case of surface plot, also the fill-color (by default white).
4. Scatter plots 3d
    * In this mode, the assumption of an equispaced grid is made, and the data is represented as a matrix of z-values. `[][]f32`.
    * This mode supports mesh and surface plots. Each of these can be customized with the color map, and in the specific case of surface plot, also the fill-color (by default white).
5. Bar plots (Not yet implemented)
    * Bar plots are a series of data, where each data point is represented by a bar. These bars can be customized to different colors and patterns.

# Structure of the package

To generate a new plot, one has to create an instance of Tikz, which is the core of the generator. The Tikz struct has the following fields:

```v
struct Tikz {
    pref Pref // The preferences for the plot
    axis Axis // The axis of the plot
    plots []Plot // The plots to be added to the plot
}

mut tikz := Tikz.new(
    xlabel,
    ylabel,
    title
)
```

The preferences, `pref` allows for some choosing compiler: texlive, pdflatex. It also allows for keeping the .tex file after creating the plot.

This package is made to be simple and easy to use, but still generate tikz figures that are on par with the quality of scientific publications.

## Examples

For more examples, see the [Examples](examples) directory.

### Scatter Plot

```v
import vtikz

x := [f32(1), 2, 3, 4, 5]
y := [f32(1), 4, 10, 15, 26] // Assume this to be experimental data of x^2

mut tikz := Tikz.new(
    'x', // xlabel
    'y', // ylabel
    'Our first plot'
)

tikz.add_scatter(x, y, 'blue', 'Experimental data') // We add the scatter data

tikz.add_function(
    "x^2", // The function
    'red', // The color
    'Fitted data', // The line style
    [3, 5]! // The range of x (Not in agreement with the data, but for the sake of the example)
)

// When adding the second plot the xlimits are set to the range of the enitre data set, i.e. [1, 5]!, and vtikz will automatically show the legends when adding the second plot

// We can change the compiler by changing the preference structure
tikz.set_compiler(vtikz.Compiler.texlive)
// The default is .pdflatex and we have .@none

// If we dont want the .tex file to be compiled, we can set the field keep_tex to true
tikz.set_keep_tex(true)

// If we dont want the pdf to automatically open, we do the following:
tikz.set_open_pdf(false)

// Note, all the auxiliary files are deleted.

// If you want to change the legend position, you can do the following:

tikz.set_legend_pos(vtikz.Legend_pos.north_east) // This is the same as the above

// Iff you want to change the alignment of the graph, you can do the following:

tikz.set_axis_line(.center)

// If the standard tick labels are not what you want, you can change them by doing the following:

tikz.set_xtick([f32(1), 2.5, 5])//All values must be f32.

tikz.plot('scatter_plot.tex') // Save the plot to a .tex file

```
