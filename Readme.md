## tcl-xblt -- an extension library for tcl-blt graphs

Originally it comes from ROTA group (Low Temperature laboratory, TKK (Aalto) University, Finland)

## Functions:

---

### `xblt::hielems <blt_graph> <options>` -- hide/highlight/logscale/autoscale plots

This function adds additional functions to the legend menu for element hiding, highlighting,
setting log scale (vertical axis), autoscaling.

Key bindings:
* left mouse button on a legend -- toggle show/hide
* middle mouse button on a legend -- toggle normal/highlight

Options:
* -usemenu        -- add menu entries (default: 1)
* -hidemenulabel  -- label for show/hide menu entry (default: Hide)
* -hilitmenulabel -- label for normal/highlight menu entry (default: Highlight)
* -logmenulabel   -- label for normal/logscale menu entry (default: Logscale)
* -automenulabel  -- label for autoscale menu entry (default: Autoscale)

---

### `xblt::elemop <blt_graph>` -- move/scale plots in vertical direction

After a call to this function any plot can be selected with a middle
mouse button and scaled or moved in a vertical direction by dragging the
mouse. Vertical axis is modified accordingly. This is convenient if you
have many plots with different scales on the graph.

---

### `xblt::scrollbydrag <blt_graph>` -- move plots in vertical and horizontal directions

After a call to this function any plot can be dragged horizontally or vertically
by 2nd mouse button. Axes are modified accordingly.

Options:
* -modifier -- modifier for dragging (default: {})
* -button   -- mouse button for dragging (default: 2)
* -axes     -- list if axes to drag (default: {})

---

### `xblt::scroll <blt_graph> <scrollbar>` -- connects a graph widget with a horizintal scrollbar

Positions of the blt::graph and the scrollbar are syncronized. Key bindings
for navigation are added:

* Home/End keys -- scroll to the beginning/end of data
* Left/Right arrows, mouse wheel -- scroll left/right by 1/20 of the window.
* PgUp/PgDown keys -- scroll left/right by one window size.

Options:
* -on_change  -- command run when the plot is scrolled or resized. Four arguments:
  limits in scrollbar coordinates, limits in plot coordinates. (default: {})
* -timefmt    -- use nice time libels on the x axis (values should be in
  seconds since 1970-01-01). Boolean value. (default: 0)

---

### `xblt::zoomstack <blt_graph> <options>` -- zoom data with a mouse

One can zoom data with 1st mouse button. All previouse zoom settings are
stored in a stack. When unzooming is done (using 3rd mouse button or
menu entry), the previous setting is restored.

Horisontal scrolling of the graph with 2nd mouse button is also set up here.

Options:
* -modifier        -- modifier for zoom      (default: {})
* -button          -- mouse button to zoom   (default: 1)
* -scrollbutton    -- mouse button to scroll (default: 2)
* -unzoombutton    -- mouse button to unzoom (default: 3)
* -axes            -- list if axes to zoom (default: {} which means all)
* -recttype        -- type ot zooming rectangle: x,y or xy (default: xy)
* -rectconfig      -- (default: {})
* -usemenu         -- add menu entries (default: 1)
* -menuunzoomlabel -- label for unzoom menu entry (default: Unzoom)
* -menurezoomlabel -- label for restore zoom menu entry (default: Restore zoom)

---

### `xblt::crosshairs <blt_graph> <options>` -- crosshairs mode

Options:
* -variable  -- variable with the cursor state (default: {})
* -show      -- show/hide (default: {})
* -usemenu   -- add menu entry (default: 1)
* -menulabel -- label for crosshairs menu entry (default: Crosshairs)

Note: if -variable is empty then menu is not shown

---

### `xblt::readout <blt_graph> <options>` -- readout mode

Options:
* -variable      -- (default: {})
* -active        -- (default: {})
* -command       -- (default: {})
* -interpolate   -- (default: no)
* -onmarkers     -- (default: {})
* -usemenu       -- add menu entry (default: 1)
* -menulabel     -- (default: Readout)
* -formatcommand -- (default: {})
* -eventcommand  -- (default: {})

---

### `xblt::measure <blt_graph> <options>` -- measure mode

Options:
* -command cmd  -- (default: {})
* -commandlabel -- (default: usercmd)
* -event        -- (default: {})
* -quickevent   -- (default: {})
* -usemenu      -- add menu entry (default: 1)
* -menulabel    -- menu label (default: Measure)
* -finishlabel  -- menu label for a strange popup menu (default: Finish measure)

---

### `xblt::xcomments <blt_graph> <options>` -- add/delete comments on the x-axis

Comments are compatible with comments/annotations in graphene database.
They can be created by Control-ButtonPress-1 and deleted by Control-ButtonPress-3.
One can also add commands using `xblt::xcomments::create <position> <text>` call.
Functions -on_add and -on_del can be used to syncronize comments with a database.

Options:
* -on_add  -- command run when a comment is created, arguments: position,text (default: {})
* -on_del  -- command run when a comment is deleted, arguments: position,text (default: {})

---

TODO: other functions

* bindtag.tcl
* escape.tcl
* legmenu.tcl
* main.tcl
* mtmarker.tcl
* options.tcl
* plotmenu.tcl
* plotoper.tcl
* rubberrect.tcl
* timemark.tcl
* unitaxes.tcl
* varutil.tcl

