%define teaname xblt
%define major 3.2

Name: tcl-%teaname
Version: %major
Release: alt1
BuildArch: noarch

Summary: tcl-xblt library from ROTA group
Group: System/Libraries
Source: %name-%version.tar
License: Unknown

Requires: tcl

%description
tcl-xblt library from ROTA group

%prep
%setup -q

%install
mkdir -p %buildroot/%_tcldatadir/%teaname%major
install -m644 *.tcl %buildroot/%_tcldatadir/%teaname%major

%files
%dir %_tcldatadir/%teaname%major
%_tcldatadir/%teaname%major/*.tcl

%changelog
* Tue Nov 14 2023 Vladislav Zavjalov <slazav@altlinux.org> 3.2-alt1
v3.2
- readout.tcl: simplify xblt::readout::format logic
- readout.tcl: when using axis -command formatting do not show original value (smaller labels for timestamps)
- plotoper.tcl: avoid mixing tags for multi-graph programs (solve problem with finish measure button)
- elemop.tcl: multiple blt::graph support
- elemop.tcl, scroll.tcl, xcomments.tcl: do not use full namespace names in functions
- xcomments.tcl: add -show_x and -time_fmt options
- scrolldrag.tcl: avoid dragging a logscale plot to negative values
- scroll.tcl: use simple and ugly time format (good one did not work properly)
- xBlt_test: add x/y-axis titles

* Sat Jan 13 2018 Vladislav Zavjalov <slazav@altlinux.org> 3.1-alt1
- New modules:
  - elemop - shift and rescale plots (as in Rota's Stripchart program).
  - xcomments - interactive comments connected to x axis.
  - scroll - connects the plot with a horizontal scrollbar, nice time axis formatting.
- Fix old modules:
  - hielems: add logscale, autoscale.
  - plotoper: destroy old menu if it exists (allow to register operation twice).
  - scrolldrag: do not go beyond scrollmin:scrollmax.
  - readout: use eval to run a user-specified command.
  - zoomstack: fix limit settings, clear axis stepsize to avoid too many ticks.
  - Default option -scrollbutton=2 in zoomstack module.
  - Default option -usemenu=1 in crosshairs, measure, readout, zoomstack, hielems modules.
- Add some documentation (comments in the code, Readme.md file)
