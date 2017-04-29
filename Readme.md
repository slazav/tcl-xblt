## tcl-xblt -- an extension library fot tcl-blt graphs

Originally it comes from ROTA group of Low Temperature laboratory in
TKK (Aalto) University in Finland.

E-mail: `slazav at altlinux dot org`

## Functions:

---

### `xblt::hielems <blt_graph> <options>` -- hide/highlight/logscale/autoscale of plots

This function adds additional functions to the legend menu for element hiding, highlighting,
setting log scale (vertical axis), autoscaling.

Key bindings:
* left mouse button on a legend -- toggle show/hide
* middle mouse button on a legend -- toggle normal/highlight

Options:
`
  -usemenu        -- add menu entries (default: 1)
  -hidemenulabel  -- label for show/hide menu entry (default: Hide)
  -hilitmenulabel -- label for normal/highlight menu entry (default: Highlight)
  -logmenulabel   -- label for normal/logscale menu entry (default: Logscale)
  -automenulabel  -- label for autoscale menu entry (default: Autoscale)
`

---

### `xblt::elemop <blt_graph>` -- vertical moving and scaling of data

After a call to this function any plot can be selected with a middle
mouse button and scaled or moved in a vertical direction by dragging the
mouse. Vertical axis is modified accordingly. This is convenient if you
have many plots with different scales on the graph.

---

### `xblt::scroll <blt_graph> <scrollbar>` -- connects a blt::graph widget with a horizintal TK scrollbar

Positions of the blt::graph and the scrollbar are syncronized. Key bindings
for navigation are added:
* Home/End keys -- scroll to the beginning/end of data
* Left/Right arrows, mouse wheel -- scroll left/right by 1/20 of the window.
* PgUp/PgDown keys -- scroll left/right by one window size.


