# Tcl package index file, version 1.1
# This file is NOT generated by the "pkg_mkIndex" command

package ifneeded xBlt 3.0 [list source [file join $dir main.tcl]]\n[list tclPkgSetup $dir xBlt 3.0 {
    {bindtag.tcl    source {xblt::bindtag::add xblt::bindtag::remove xblt::bindtag::check}}
    {options.tcl    source {xblt::parse_options}}
    {varutil.tcl    source {xblt::var::use}}
    {mtmarker.tcl   source {xblt::mtmarker xblt::mtmarker::create}}
    {crosshairs.tcl source {xblt::crosshairs xblt::crosshairs:add}}
    {readout.tcl    source {xblt::readout xblt::readout::add}}
    {hielems.tcl    source {xblt::hielems xblt::hielems::add}}
    {measure.tcl    source {xblt::measure xblt::measure::add}}
    {legmenu.tcl    source {xblt::legmenu xblt::legmenu::add xblt::legmenu::get}}
    {plotmenu.tcl   source {xblt::plotmenu xblt::plotmenu::add xblt::plotmenu::get}}
    {scrolldrag.tcl source {xblt::scrollbydrag xblt::scrollbydrag::add}}
    {unitaxes.tcl   source {xblt::unitaxes::add}}
    {rubberrect.tcl source {xblt::rubberrect::add}}
    {escape.tcl     source {xblt::escape::activate}}
    {plotoper.tcl   source {xblt::plotoperation::register}}
    {zoomstack.tcl  source {xblt::zoomstack xblt::zoomstack::add}}
    {timemark.tcl   source {xblt::timemark::create}}
    {elemop.tcl     source {xblt::elemop}}
    {scroll.tcl     source {xblt::scroll}}
    {xcomments.tcl  source {xblt::xcomments xblt::xcomments::create xblt::xcomments::create_int xblt::xcomments::delete xblt::xcomments::delete_int xblt::xcomments::delete_old xblt::xcomments::clear}}
}]
