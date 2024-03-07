
# vTikz

A simple design to generate standalone tikz images in V.

## Installation

```bash
v install vTikz
```

## Usage

For examples, see the [Examples](examples) directory.

The following are the types of plots that can be created in vTikz:

1. Scatter plots
2. Function plots
3. Heatmaps (Not implemented yet)
4. Bar plots (Not implemented yet)


# Strucure of the package

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
