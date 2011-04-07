Summary: The Pants SYS-V init script
Name: pants
Version: 1.0
Release: 1
License: GPL
Group: System Environment/Base
URL: http://www.friocorte.com/projects/pants
Source0: %{name}-%{version}.tar.gz
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root

%description
The SYS-V pants script. Make sure you're wearing pants in multi-user mode. A practice in bash programming

%prep
%setup -q

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
/sbin/chkconfig --del pants

%changelog
* Wed Mar 16 2005 Derek Carter <goozbach@friocorte.com> - 1.0-2
- fixed bug with sys-v script stopping

* Wed Mar 16 2005 Derek Carter <goozbach@friocorte.com> - 1.0-1
- Initial build.
