# connects a scrollbar with a blt graph

namespace eval xblt::scroll {
  variable data;

  # graph;       - BLT graph widget
  # scrollbar;   - Scrollbar widget
  # on_change;   - User command to run on limit change.
  # oldx1;       - Keep old limits during rescaling
  # oldx2;       - to see if we need to do something.
  # timefmt;     - x axis is time (unix time in seconds)
  # run_cmd_flag - do we need to run user command?
}

proc xblt::scroll {graph args} {
    eval xblt::scroll::add $graph $args
}

proc xblt::scroll::add {graph sbar args} {
  xblt::parse_options xblt::scroll::add $args [subst {
    -on_change xblt::scroll::data($graph,on_change) {}
    -timefmt   xblt::scroll::data($graph,timefmt)   {0}
  }]

  set xblt::scroll::data($graph,oldx1)  0
  set xblt::scroll::data($graph,oldx2)  0
  set xblt::scroll::data($graph,scrollbar) $sbar
  set xblt::scroll::data($graph,run_cmd_flag) 0
  $xblt::scroll::data($graph,scrollbar) configure -orient horizontal -command "xblt::scroll::cmd $graph"
  $graph axis configure x -scrollcommand "xblt::scroll::sset $graph"

  if {$xblt::scroll::data($graph,timefmt)} {
    $graph axis configure x -majorticks "" -stepsize 0 -subdivisions 10\
        -command "xblt::scroll::format_time {%Y-%m-%d%n%H:%M:%S}"
  }


  bind $graph <Key-End>   "xblt::scroll::cmd $graph moveto 1"
  bind $graph <Key-Home>  "xblt::scroll::cmd $graph moveto 0"
  bind $graph <Key-Left>  "xblt::scroll::cmd $graph scroll -1 units"
  bind $graph <Key-Right> "xblt::scroll::cmd $graph scroll 1 units"
  bind $graph <Key-Prior> "xblt::scroll::cmd $graph scroll -1 pages"
  bind $graph <Key-Next>  "xblt::scroll::cmd $graph scroll 1 pages"
  bind $graph <ButtonPress-4> "xblt::scroll::cmd $graph scroll -1 units"
  bind $graph <ButtonPress-5> "xblt::scroll::cmd $graph scroll 1 units"
}

## This function is called when graph is scrolled/zoomed or scrollbar is moved.
## It moves scrollbar and runs user command (for data updates) if needed.
proc xblt::scroll::sset {graph x1 x2} {

  ## limits in plot coordinates
  set lims [$graph axis limits x]
  set xmin [lindex $lims 0]
  set xmax [lindex $lims 1]

  ## do only if range (in real ccordinates) have been changed
  if {$xmin==$xblt::scroll::data($graph,oldx1) &&\
      $xmax==$xblt::scroll::data($graph,oldx2)} return
  set xblt::scroll::data($graph,oldx1) $xmin
  set xblt::scroll::data($graph,oldx2) $xmax

  $xblt::scroll::data($graph,scrollbar) set $x1 $x2

  ## we no not run set_tscale and user command
  ## too often
  if {$xblt::scroll::data($graph,run_cmd_flag) > 0} return
  incr xblt::scroll::data($graph,run_cmd_flag)

  # calculate size of plot area:
  set w [winfo width $graph]
  set w [expr {$w-140}];  # not accurate, we do not know size of legend + vertical axis

#  ## format time axis if needed
#  if {$xblt::scroll::data($graph,timefmt)} {
#    xblt::scroll::set_tscale $graph $xmin $xmax $w
#  }

  ## run user command if needed
  set cmd $xblt::scroll::data($graph,on_change)
  if {$cmd != ""} { eval $cmd $x1 $x2 $xmin $xmax $w }
  set xblt::scroll::data($graph,run_cmd_flag) [expr "$xblt::scroll::data($graph,run_cmd_flag) - 1"]
}


## This function is called when scrollbar is moved. It calculates
## new graph limits and scroll the graph
proc xblt::scroll::cmd {graph args} {

  ## scrollbar limits
  set slim [$xblt::scroll::data($graph,scrollbar) get]
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
  if {$s < 0} {set s 0}

  ## blt plot limits
  set xlim [$graph axis limits x]
  set xmin [lindex $xlim 0]
  set xmax [lindex $xlim 1]

  set dx [expr {($s-$smin)*($xmax-$xmin)/($smax-$smin)}]
  set xmin [expr {$xmin + $dx}]
  set xmax [expr {$xmax + $dx}]
  $graph axis configure x -min $xmin -max $xmax
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

  # when majorticks is set no minor ticks are allowed
  set SS [expr {$w/($xmax - $xmin)}]
  if {$SS > 60 } {
    set dl {}
    for {set d [expr {int($xmin)}]} {$d < $xmax} {set d [expr $d+1]} {
      lappend dl $d}
    $graph axis configure x -majorticks $dl -subdivisions 10\
       -command "xblt::scroll::format_time {%Y-%m-%d%n%H:%M:%S}"
    return

#    $graph axis configure x -majorticks "" -stepsize 1 -subdivisions 10\
#                            -command "xblt::scroll::format_time {%Y-%m-%d%n%H:%M:%S}"
#    return
  }
  if {10*$SS > 60 } {
    $graph axis configure x -majorticks "" -stepsize 10 -subdivisions 10\
                            -command "xblt::scroll::format_time {%Y-%m-%d%n%H:%M:%S}"
    return
  }
  set MM [expr {$SS*60}]
  if {$MM > 60 } {
    $graph axis configure x -majorticks "" -stepsize 60 -subdivisions 6\
                            -command "xblt::scroll::format_time {%Y-%m-%d%n%H:%M}"
    return
  }
  if {10*$MM > 60 } {
    $graph axis configure x -majorticks "" -stepsize 600 -subdivisions 10\
                            -command "xblt::scroll::format_time {%Y-%m-%d%n%H:%M}"
    return
  }
  set HH [expr {$MM*60}]
  if {$HH > 60 } {
    $graph axis configure x -majorticks "" -stepsize 3600 -subdivisions 6\
                            -command "xblt::scroll::format_time {%Y-%m-%d%n%H:%M}"
    return
  }
  if {3*$HH > 60 } {
    $graph axis configure x -majorticks "" -stepsize 10800 -subdivisions 3\
                            -command "xblt::scroll::format_time {%Y-%m-%d%n%H:%M}"
    return
  }
  set dd [expr {$HH*24}]
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
    return
  }
  set ww [expr {$dd*7}]
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
    return
  }
  set mm [expr {$dd*30}]
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
    return
  }
  set yy [expr {$dd*365}]
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
    return
  }
  $graph axis configure x -stepsize 0 -subdivisions 0
}


