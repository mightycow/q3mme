echo Which target?
echo 1. Release
echo 2. Debug
set /p choice=
if %choice%==1 (
	set vs_target=Release
) else if %choice%==2 (
	set vs_target=Debug
) else (
    echo Invalid choice
	exit
)

@rem We don't have x64 support yet.
set vs_arch=Win32
@rem echo Which architecture?
@rem echo 1. x86
@rem echo 2. x64
@rem set /p choice=
@rem if %choice%==1 (
@rem 	set vs_arch=Win32
@rem ) else if %choice%==2 (
@rem 	set vs_arch=x64
@rem ) else (
@rem     echo Invalid choice
@rem 	exit
@rem )