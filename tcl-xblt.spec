%define teaname xblt
%define major 3.0

Name: tcl-%teaname
Version: 3.0
Release: alt1

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
mkdir -p %buildroot/%_tcldatadir/%teaname
install *.tcl %buildroot/%_tcldatadir/%teaname

%files
%dir %_tcldatadir/%teaname%major
%_tcldatadir/%teaname%major/*.tcl

%changelog
