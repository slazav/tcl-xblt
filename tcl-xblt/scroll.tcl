# connects a scrollbar with a blt graph

namespace eval xblt::scroll {
  variable graph;     # BLT graph widget
  variable scrollbar; # Scrollbar widget
  variable on_change; # User command to run on limit change.
  variable oldx1;     # Keep old limits during rescaling
  variable oldx2;     # to see if we need to do something.
  variable timefmt;   # x axis is time (unix time in seconds)
}

proc xblt::scroll {graph args} {
    eval xblt::scroll::add $graph $args
}

proc xblt::scroll::add {graph sbar args} {
  xblt::parse_options xblt::scroll::add $args [subst {
    -on_change xblt::scroll::on_change {}
    -timefmt   xblt::scroll::timefmt   {0}
  }]

  set xblt::scroll::oldx1  0
  set xblt::scroll::oldx2  0
  set xblt::scroll::graph  $graph
  set xblt::scroll::scrollbar $sbar
  $xblt::scroll::scrollbar configure -orient horizontal -command "xblt::scroll::cmd"
  $xblt::scroll::graph  axis configure x -scrollcommand "xblt::scroll::sset"

  bind $graph <Key-End>   "xblt::scroll::cmd moveto 1"
  bind $graph <Key-Home>  "xblt::scroll::cmd moveto 0"
  bind $graph <Key-Left>  "xblt::scroll::cmd scroll -1 units"
  bind $graph <Key-Right> "xblt::scroll::cmd scroll 1 units"
  bind $graph <Key-Prior> "xblt::scroll::cmd scroll -1 pages"
  bind $graph <Key-Next>  "xblt::scroll::cmd scroll 1 pages"
  bind $graph <ButtonPress-4> "xblt::scroll::cmd scroll -1 units"
  bind $graph <ButtonPress-5> "xblt::scroll::cmd scroll 1 units"
}

proc xblt::scroll::sset {x1 x2} {
  ## do only if range have been changed
  if {$x1==$xblt::scroll::oldx1 && $x2==$xblt::scroll::oldx2} return
  set xblt::scroll::oldx1 $x1
  set xblt::scroll::oldx2 $x2

  ## limits in plot coordinates
  set lims [$xblt::scroll::graph axis limits x]
  set xmin [lindex $lims 0]
  set xmax [lindex $lims 1]

  # calculate size of plot area:
  set w [winfo width $xblt::scroll::graph]
  set w [expr {$w-140}];  # not accurate, we do not know size of legend + vertical axis

  ## format time axis if needed
  if {$xblt::scroll::timefmt} {
    xblt::scroll::set_tscale $xblt::scroll::graph $xmin $xmax $w
  }

  ## run user command if needed
  set cmd $xblt::scroll::on_change
  if {$cmd != ""} {
    uplevel \#0 [eval $cmd $x1 $x2 $xmin $xmax $w]
  }

  ## update scrollbar
  $xblt::scroll::scrollbar set $x1 $x2
}

proc xblt::scroll::cmd {args} {
  ## blt plot limits
  set xlim [$xblt::scroll::graph axis limits x]
  set xmin [lindex $xlim 0]
  set xmax [lindex $xlim 1]

  ## scrollbar limits
  set slim [$xblt::scroll::scrollbar get]
  set smin [lindex $slim 0]
  set smax [lindex $slim 1]
  if {$smax <= $smin} {return}

  set s $smin
  set sbw [expr $smax-$smin]

  switch -exact [lindex $args 0] {
    moveto {
      set s [lindex $args 1]
    }
    scroll {
      set n [lindex $args 1]
      if {[string equal [lindex $args 2] units]} {
        set s [expr $s+$n*$sbw/20]
      } else {
        set s [expr $s+$n*$sbw]
      }
    }
  }
  if {$s > 1-$sbw} {set s [expr 1-$sbw]}
  if {$s < 0} {set s $smin}
  set k [expr {($xmax-$xmin)/($smax-$smin)}]
  set xmin [expr {$xmin + ($s-$smin)*$k}]
  set xmax [expr {$xmax + ($s-$smin)*$k}]
  $xblt::scroll::graph axis configure x -min $xmin -max $xmax
}

### format time and set axis labels

proc xblt::scroll::format_time {fmt p t} {
  # we cannot use just 'clock format' command since t can contain fractional
  # seconds
  set ti [expr {int($t)}]
  set fsec [string range [string trimright [format %.6f [expr {$t-$ti}]] 0] 1 end]
  if {[string match . $fsec]} {
    clock format $ti -format $fmt
  } else {
    string map [list "\001" $fsec] [clock format $ti -format [string map {%S "%S\001"} $fmt]]
  }
}

## set time scale
proc xblt::scroll::set_tscale {graph xmin xmax w} {

  set SS [expr {$w/($xmax - $xmin)}]
  set MM [expr {$SS*60}]
  set HH [expr {$MM*60}]
  set dd [expr {$HH*24}]
  set ww [expr {$dd*7}]
  set mm [expr {$dd*30}]
  set yy [expr {$dd*365}]

  # when majorticks is set no minor ticks are allowed
  if {$SS > 60 } {
    $graph axis configure x -majorticks "" -stepsize 1 -subdivisions 10\
                            -command "xblt::scroll::format_time {%Y-%m-%d%n%H:%M:%S}"
    update idletasks
    return
  }
  if {10*$SS > 60 } {
    $graph axis configure x -majorticks "" -stepsize 10 -subdivisions 10\
                            -command "xblt::scroll::format_time {%Y-%m-%d%n%H:%M:%S}"
    update idletasks
    return
  }
  if {$MM > 60 } {
    $graph axis configure x -majorticks "" -subdivisions 6 -stepsize 60\
                            -command "xblt::scroll::format_time {%Y-%m-%d%n%H:%M}"
    update idletasks
    return
  }
  if {10*$MM > 60 } {
    $graph axis configure x -majorticks "" -stepsize 600 -subdivisions 10\
                            -command "xblt::scroll::format_time {%Y-%m-%d%n%H:%M}"
    update idletasks
    return
  }
  if {$HH > 60 } {
    $graph axis configure x -majorticks "" -stepsize 3600 -subdivisions 6 -subdivisions 10\
                            -command "xblt::scroll::format_time {%Y-%m-%d%n%H:%M}"
    update idletasks
    return
  }
  if {3*$HH > 60 } {
    $graph axis configure x -majorticks "" -loose 0 -stepsize 10800 -subdivisions 3 -subdivisions 10\
                            -command "xblt::scroll::format_time {%Y-%m-%d%n%H:%M}"
    update idletasks
    return
  }
  if {$dd > 60 } {
    # build list with days. We can not use -stepsize 86400
    # because of local time shift
    set d [clock format [expr {int($xmin)}] -format "%Y-%m-%d"]
    set d [clock scan $d]
    set dl {}
    while {$d < $xmax} {
      set d [expr $d+86400]
      lappend dl [expr $d]
    }
    $graph axis configure x -majorticks $dl -command "xblt::scroll::format_time {%Y-%m-%d}"
    update idletasks
    return
  }
  if {$ww > 60 } {
    # build list with weeks. We can not use -stepsize [expr {7*86400}]
    # because of local time shift
    set d [clock format [expr {int($xmin)}] -format "%Y-%m-%d"]
    set w [clock format [expr {int($xmin)}] -format "%u"]; # weekday
    set d [clock scan $d]; # beginning of the day
    set d [expr {$d - ($w-1)*86400}]; # go to Monday
    set dl {}
    while {$d < $xmax} {
      set d [expr $d+7*86400]
      lappend dl [expr $d]
    }
    $graph axis configure x -majorticks $dl -subdivisions 7 -command "xblt::scroll::format_time {%Y-%m-%d}"
    update idletasks
    return
  }
  if {$mm > 60 } {
    # build list of months
    set d [clock format [expr {int($xmin)}] -format "%Y-%m"]
    set d [clock scan "$d-01"]; # beginning of the month
    set dl {}
    while {$d < $xmax} {
      set d [expr $d+32*86400]
      set d [clock format $d -format "%Y-%m"]
      set d [clock scan "$d-01"]; # beginning of the month
      lappend dl [expr $d]
    }
    $graph axis configure x -majorticks $dl -subdivisions 31 -command "xblt::scroll::format_time {%Y-%m}"
    update idletasks
    return
  }
  if {$yy > 60 } {
    # build list of years
    set d [clock format [expr {int($xmin)}] -format "%Y"]
    set d [clock scan "$d-01-01"]; # beginning of the year
    set dl {}
    while {$d < $xmax} {
      set d [expr $d+367*86400]
      set d [clock format $d -format "%Y"]
      set d [clock scan "$d-01-01"]; # beginning of the year
      lappend dl [expr $d]
    }
    $graph axis configure x -majorticks $dl -subdivisions 12 -command "xblt::scroll::format_time %Y"
    update idletasks
    return
  }
  $graph axis configure x -stepsize 0
  $graph axis configure x -subdivisions 0
  update idletasks
}


