#
# spec file for package SuSEfirewall2
#
# Copyright (c) 2012, 2015 SUSE LINUX Products GmbH, Nuernberg, Germany.
#
# All modifications and additions to the file contributed by third parties
# remain the property of their copyright owners, unless otherwise agreed
# upon. The license for this file, and modifications and additions to the
# file, is the same license as for the pristine package itself (unless the
# license for the pristine package is not an Open Source License, in which
# case the license is the MIT License). An "Open Source License" is a
# license that conforms to the Open Source Definition (Version 1.9)
# published by the Open Source Initiative.

# Please submit bugfixes or comments via http://bugs.opensuse.org/
#

# norootforbuild
# icecream 0


Name:           HANA-Firewall
Version:        1.0
Release:        0.3.4
License:        GPL v2 or later
Group:          Productivity/Networking/Security
Provides:       hana-firewall
Obsoletes:      hana-firewall
Conflicts:	SuSEfirewall
PreReq:         %fillup_prereq %insserv_prereq fileutils
Requires:       iptables coreutils perl sysconfig
Summary:        HANA Server Firewall using iptables and netfilter
Source:         HANA-Firewall-1.0.tar.bz2
BuildArch:      noarch
BuildRoot:      %{_tmppath}/HANA-Firewall-1.0
#!BuildIgnore: post-build-checks

%description
The HANA Firewall implements a packet filter specialized for SAP HANA
environment. The main advantage over the SuSEFirewall2 is the increased
number of security zones that can be configured.

The HANA Firewall uses the iptables/netfilter packet filtering
infrastructure to create a flexible rule set for incoming traffic.

Provides HANA-Firewall-0.9


Authors:
--------
    Markus Guertler <mguertler@suse.com>
    Alexander Bergmann <abergmann@suse.com>

%prep
%setup
# please send patches to mguertler/abergmann for inclusion in git repo

%build

%install
make DESTDIR="%{buildroot}" install
install -d -m 755 %{buildroot}/etc/sysconfig/hana_firewall.d

%files
%defattr(-, root, root)
%config /etc/init.d/hana_firewall
/sbin/hana_firewall
/sbin/rchana_firewall
%config /etc/sysconfig/hana_firewall
/etc/sysconfig/hana_firewall.d
/etc/sysconfig/hana_firewall.d/*

%check

%postun
%insserv_cleanup

%post

%clean
rm -rf %{buildroot}

%changelog
* Thu Jul  9 2015 rroth@suse.com
- backports from github (HANA_HIGH_AVAILABILITY)
- misc. enhancements from 3.0 - 3.4
* Tue May 20 2014 abergmann@suse.com
- HANA Firewall Initial Version 1.0

