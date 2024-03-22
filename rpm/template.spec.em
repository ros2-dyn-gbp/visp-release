%{?!ros_distro:%global ros_distro @(Rosdistro)}
%global pkg_name @(Name)
%global normalized_pkg_name %{lua:return (string.gsub(rpm.expand('%{pkg_name}'), '_', '-'))}

Name:           @(Package)
Version:        @(Version)
Release:        @(RPMInc)%{?dist}
Summary:        ROS %{pkg_name} package

License:        @(License)
@[if Homepage and Homepage != '']URL:            @(Homepage)@\n@[end if]@
Source0:        %{name}-%{version}.tar.gz
@[if NoArch]@\nBuildArch:      noarch@\n@[end if]@

BuildRequires:  bloom-rpm-macros
BuildRequires:  cmake

%{?bloom_package}

%description
@(Description)


%package devel
Release:        %{release}%{?release_suffix}
Summary:        %{summary}
Provides:       %{name}%{?_isa} = %{version}-%{release}
Requires:       %{name}-runtime%{?_isa} = %{version}-%{release}

%description devel
@(Description)


%package runtime
Release:        %{release}
Summary:        %{summary}

%description runtime
@(Description)


%prep
%autosetup -p1


%generate_buildrequires
%bloom_buildrequires


%build
%cmake \
    -UINCLUDE_INSTALL_DIR \
    -ULIB_INSTALL_DIR \
    -USYSCONF_INSTALL_DIR \
    -USHARE_INSTALL_PREFIX \
    -ULIB_SUFFIX \
    -DCMAKE_INSTALL_PREFIX="%{bloom_prefix}" \
    -DCMAKE_PREFIX_PATH="%{bloom_prefix}" \
    -DSETUPTOOLS_DEB_LAYOUT=OFF \
%if !0%{?with_tests}
    -DBUILD_TESTING=OFF \
%endif

%cmake3_build


%install
%cmake_install


%if 0%{?with_tests}
%check
# Look for a Makefile target with a name indicating that it runs tests
TEST_TARGET=$(%__make -qp -C %{__cmake_builddir} | sed "s/^\(test\|check\):.*/\\1/;t f;d;:f;q0")
if [ -n "$TEST_TARGET" ]; then
CTEST_OUTPUT_ON_FAILURE=1 \
    %cmake_build $TEST_TARGET || echo "RPM TESTS FAILED"
else echo "RPM TESTS SKIPPED"; fi
%endif


%files devel
%ghost %{bloom_prefix}/share/%{pkg_name}/package.xml


%files runtime
@[for lf in LicenseFiles]%license @lf@\n@[end for]@
%{bloom_prefix}


%changelog@[for change_version, (change_date, main_name, main_email) in changelogs]
* @(change_date) @(main_name) <@(main_email)> - @(change_version)
- Autogenerated by Bloom
@[end for]@
