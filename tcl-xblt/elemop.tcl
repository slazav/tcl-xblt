# shift and rescale plots
# 2nd button on plot: shift and rescale

namespace eval xblt::elemop {
  variable data
}

proc xblt::elemop {graph args} {
  eval xblt::elemop::add $graph $args
}

proc xblt::elemop::add {graph args} {
  variable data
  bind $graph <ButtonPress-2>   "xblt::elemop::start $graph %x %y"
  bind $graph <B2-Motion>       "xblt::elemop::do    $graph %x %y"
  bind $graph <ButtonRelease-2> "xblt::elemop::end   $graph %x %y"
  set data($graph,started) 0
}

######################################################################
proc xblt::elemop::start {graph xp yp} {
  variable data
  $graph element closest $xp $yp e -interpolate yes
  set data($graph,es) $e(name)
  if {$data($graph,es) == ""} return
  xblt::crosshairs::show $graph 0
  set data($graph,xpi) $xp
  set data($graph,yi) [$graph axis invtransform $data($graph,es) $yp]
  set data($graph,sc) 1.0
  set data($graph,started) 1
  return -code break
}

proc xblt::elemop::do {graph xp yp} {
  variable data
  if {! $data($graph,started)} return
  set v $data($graph,es)
  set yi $data($graph,yi)
  set y [$graph axis invtransform $v $yp]
  set y1 [lindex [$graph axis limits $v] 0]
  set y2 [lindex [$graph axis limits $v] 1]
  set sc [expr {exp(($xp - $data($graph,xpi)) / 100.0)}]

  if {[$graph axis cget $v -logscale]} {
    set newmin [expr {exp(log($yi) - (log($y) - log($y1))*$data($graph,sc)/$sc)}]
    set newmax [expr {exp(log($yi) + (log($y2) - log($y))*$data($graph,sc)/$sc)}]
  } else {
    set newmin [expr {$yi - ($y - $y1)*$data($graph,sc)/$sc}]
    set newmax [expr {$yi + ($y2 - $y)*$data($graph,sc)/$sc}]
  }
  $graph axis configure $v -min $newmin -max $newmax
  set data($graph,sc) $sc
  return -code break
}

proc xblt::elemop::end {graph xp yp} {
  variable data
  if {! $data($graph,started)} return
  set data($graph,started) 0
  xblt::crosshairs::show $graph 1
  return -code break
}

