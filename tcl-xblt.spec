%define teaname xblt
%define major 3.1

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

%build
mkdir -p %buildroot/%_tcldatadir/%teaname%major
install -m644 *.tcl %buildroot/%_tcldatadir/%teaname%major

%files
%dir %_tcldatadir/%teaname%major
%_tcldatadir/%teaname%major/*.tcl

%changelog
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
