Summary: The Pants SYS-V init script
Name: pants-sysv
Version: v1.0.0
Release: 3
License: GPL
Group: System Environment/Base
URL: http://github.com/goozbach/Pants-SYSV
Source0:  https://github.com/goozbach/Pants-SYSV/archive/%{version}.tar.gz
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root

%description
The SYS-V pants script. Make sure you're wearing pants in multi-user mode. A practice in bash programming

%prep
%setup -qn %{name}-%{version}               [GitHub]

%build
make

%install
export ROOT_DIR=$RPM_BUILD_ROOT
make install

%clean
rm -rf $RPM_BUILD_ROOT


%files
%defattr(-,root,root,-)
%doc AUTHOR README CONTRIB pants.spec
/etc/init.d/pants
/usr/sbin/pants
%config /etc/sysconfig/pants
%config /etc/pants.file

%post
/usr/sbin/useradd -r pants -d /
/sbin/chkconfig --add pants

%preun
/usr/sbin/userdel pants
/sbin/service pants stop
/sbin/chkconfig --del pants

%changelog
* Tue Jan 19 2016 Derek Carter <goozbach@friocorte.com> 1.0.0-3
- adding symantic versioning; changing source0 to github

* Tue Jun 26 2012 Derek Carter <goozbach@friocorte.com> 1.0.0-2
- added service stop in preun

* Tue Jun 26 2012 Derek Carter <goozbach@friocorte.com> 1.0.0-1
- Moved to semantic versioning
- fixed url

* Wed Mar 16 2005 Derek Carter <goozbach@friocorte.com> - 1.0-2
- fixed bug with sys-v script stopping

* Wed Mar 16 2005 Derek Carter <goozbach@friocorte.com> - 1.0-1
- Initial build.
