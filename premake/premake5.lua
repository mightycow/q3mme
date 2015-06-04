mme_root = ".."
mme_src = mme_root.."/code/"
mme_build = mme_root.."/.build"
mme_bin = mme_root.."/.bin"
mme_cgame = mme_src.."cgame/"
mme_game = mme_src.."game/"
mme_q3ui = mme_src.."q3_ui/"
mme_ui = mme_src.."ui/"
mme_ui_data = mme_root.."/ui/"
mme_libs = mme_root.."/libs/"
mme_asm = mme_src.."asm/"
mme_asm_obj = mme_build.."/".._ACTION.."/"

local function AddMasmFile(fileName)

	-- Assemble before the build.
	prebuildcommands { "ml.exe /c /nologo /safeseh /Fo"..fileName..".obj /Ta"..path.getabsolute(mme_asm..fileName..".asm") }
	
	-- Link the assembled object file.
	linkoptions { path.getabsolute(mme_build.."/".._ACTION.."/"..fileName..".obj") }
	
	-- Add the assembled file to the source list for editing.
	files { mme_src.."asm/"..fileName..".asm" }

end

local function ApplyProjectSettings(addSuffix) 

	if addSuffix == nil then
		addSuffix = true
	end
	
	local projectName = project().name
	
	if(addSuffix) then
	
		configuration "x32"
			targetname ( projectName.."x86" ) 
			
		configuration "x64"
			targetname ( projectName.."x64" ) 
	
	end
	
	configuration {}
		-- "NoExceptions" "ExtraWarnings"
		flags { "Symbols", "NoNativeWChar", "NoPCH", "NoRTTI", "StaticRuntime", "NoManifest" }
	
	configuration "Debug"
		defines { "DEBUG", "_DEBUG" }
		flags { }

	configuration "Release"
		defines { "NDEBUG" }
		flags { "NoMinimalRebuild", "Optimize", "NoFramePointer", "EnableSSE2", "FloatFast" } -- "NoIncrementalLink"
		
	--
	-- Visual Studio
	--
	configuration { "vs*" }
		defines { "_CRT_SECURE_NO_WARNINGS", "WIN32", "_WIN32", "_WINDOWS" }
	
	configuration { "Debug", "vs*" }
		targetdir ( mme_bin.."/debug" )
		buildoptions { "" } -- Directly passed to the compiler.
		linkoptions { "" } -- Directly passed to the linker.
		
	configuration { "Release", "vs*" }
		targetdir ( mme_bin.."/release" )
		buildoptions { "/Ot", "/GT", "/GS-" } -- Directly passed to the compiler.
		linkoptions { "/OPT:REF", "/OPT:ICF" } -- Directly passed to the linker.
		
	--
	-- GCC
	--
	configuration { "gmake" }
		buildoptions { "-Wno-c++11-compat -Wno-invalid-offsetof" } -- Directly passed to the compiler.
		linkoptions { "" } -- Directly passed to the linker.
	
	configuration { "Debug", "gmake" }
		targetdir ( mme_bin.."/debug" )
		buildoptions { "" } -- Directly passed to the compiler.
		linkoptions { "" } -- Directly passed to the linker.
		
	configuration { "Release", "gmake" }
		targetdir ( mme_bin.."/release" )
		buildoptions { "" } -- Directly passed to the compiler.
		linkoptions { "" } -- Directly passed to the linker.
	
end

local function SetLocation()

	location (mme_build .. "/" .. _ACTION)

end

-- Do we want to create some folders?
-- os.mkdir()

solution "q3mme"

	SetLocation()
	platforms { "x32", "x64" }
	configurations { "Debug", "Release" }

	project "cgame"
	
		configuration {}
		
			kind "SharedLib"
			language "C"
			defines { "ENGINE_Q3" }
			files 
			{ 
				mme_cgame.."cg_consolecmds.c",
				mme_cgame.."cg_demos.c",
				mme_cgame.."cg_demos.h",
				mme_cgame.."cg_demos_camera.c",
				mme_cgame.."cg_demos_capture.c",
				mme_cgame.."cg_demos_dof.c",
				mme_cgame.."cg_demos_effects.c",
				mme_cgame.."cg_demos_hud.c",
				mme_cgame.."cg_demos_line.c",
				mme_cgame.."cg_demos_math.c",
				mme_cgame.."cg_demos_math.h",
				mme_cgame.."cg_demos_move.c",
				mme_cgame.."cg_demos_script.c",
				mme_cgame.."cg_draw.c",
				mme_cgame.."cg_drawtools.c",
				mme_cgame.."cg_effects.c",
				mme_cgame.."cg_ents.c",
				mme_cgame.."cg_event.c",
				mme_cgame.."cg_info.c",
				mme_cgame.."cg_local.h",
				mme_cgame.."cg_localents.c",
				mme_cgame.."cg_main.c",
				mme_cgame.."cg_marks.c",
				mme_cgame.."cg_players.c",
				mme_cgame.."cg_playerstate.c",
				mme_cgame.."cg_predict.c",
				mme_cgame.."cg_public.h",
				mme_cgame.."cg_scoreboard.c",
				mme_cgame.."cg_servercmds.c",
				mme_cgame.."cg_snapshot.c",
				mme_cgame.."cg_syscalls.c",
				mme_cgame.."cg_view.c",
				mme_cgame.."cg_weapons.c",
				mme_cgame.."tr_types.h",
				
				mme_game.."bg_demos.c",
				mme_game.."bg_demos.h",
				mme_game.."bg_local.h",
				mme_game.."bg_misc.c",
				mme_game.."bg_pmove.c",
				mme_game.."bg_public.h",
				mme_game.."bg_slidemove.c",
				mme_game.."q_math.c",
				mme_game.."q_shared.c",
				mme_game.."q_shared.h",
				mme_game.."surfaceflags.h",
				
				mme_ui.."keycodes.h",
				mme_ui.."ui_shared.c",
				mme_ui.."ui_shared.h",
				
				mme_ui_data.."menudef.h"
			}
		
		configuration { "vs*" }
			files { mme_cgame.."cgame.def" } -- DLL function export list
		
		ApplyProjectSettings()

	project "qagame"
	
		configuration {}
	
			kind "SharedLib"
			language "C"
			defines { "ENGINE_Q3" }
			files 
			{
				mme_game.."ai_chat.c",
				mme_game.."ai_chat.h",
				mme_game.."ai_cmd.c",
				mme_game.."ai_cmd.h",
				mme_game.."ai_dmnet.c",
				mme_game.."ai_dmnet.h",
				mme_game.."ai_dmq3.c",
				mme_game.."ai_dmq3.h",
				mme_game.."ai_main.c",
				mme_game.."ai_main.h",
				mme_game.."ai_team.c",
				mme_game.."ai_team.h",
				mme_game.."ai_vcmd.c",
				mme_game.."ai_vcmd.h",
				mme_game.."be_aas.h",
				mme_game.."be_ai_char.h",
				mme_game.."be_ai_chat.h",
				mme_game.."be_ai_gen.h",
				mme_game.."be_ai_goal.h",
				mme_game.."be_ai_move.h",
				mme_game.."be_ai_weap.h",
				mme_game.."be_ea.h",
				mme_game.."bg_local.h",
				mme_game.."bg_misc.c",
				mme_game.."bg_pmove.c",
				mme_game.."bg_public.h",
				mme_game.."bg_slidemove.c",
				mme_game.."botlib.h",
				mme_game.."chars.h",
				mme_game.."g_active.c",
				mme_game.."g_arenas.c",
				mme_game.."g_bot.c",
				mme_game.."g_client.c",
				mme_game.."g_cmds.c",
				mme_game.."g_combat.c",
				mme_game.."g_items.c",
				mme_game.."g_local.h",
				mme_game.."g_main.c",
				mme_game.."g_mem.c",
				mme_game.."g_misc.c",
				mme_game.."g_missile.c",
				mme_game.."g_mover.c",
				mme_game.."g_public.h",
				mme_game.."g_session.c",
				mme_game.."g_spawn.c",
				mme_game.."g_svcmds.c",
				mme_game.."g_syscalls.c",
				mme_game.."g_target.c",
				mme_game.."g_team.c",
				mme_game.."g_team.h",
				mme_game.."g_trigger.c",
				mme_game.."g_utils.c",
				mme_game.."g_weapon.c",
				mme_game.."inv.h",
				mme_game.."match.h",
				mme_game.."q_math.c",
				mme_game.."q_shared.c",
				mme_game.."q_shared.h",
				mme_game.."surfaceflags.h",
				mme_game.."syn.h",
				
				mme_ui_data.."menudef.h"
			}
		
		configuration { "vs*" }
			files { mme_game.."game.def" } -- DLL function export list
		
		ApplyProjectSettings()
		
	project "ui"
	
		configuration {}
		
			kind "SharedLib"
			language "C"
			defines { "Q3_UI_EXPORTS" }
			files 
			{
				mme_q3ui.."keycodes.h",
				mme_q3ui.."ui_atoms.c",
				mme_q3ui.."ui_background.c",
				mme_q3ui.."ui_confirm.c",
				mme_q3ui.."ui_credits.c",
				mme_q3ui.."ui_demo2.c",
				mme_q3ui.."ui_display.c",
				mme_q3ui.."ui_ingame.c",
				mme_q3ui.."ui_local.h",
				mme_q3ui.."ui_main.c",
				mme_q3ui.."ui_menu.c",
				mme_q3ui.."ui_mfield.c",
				mme_q3ui.."ui_players.c",
				mme_q3ui.."ui_qmenu.c",
				mme_q3ui.."ui_sound.c",
				mme_q3ui.."ui_video.c",
				
				mme_game.."bg_misc.c",
				mme_game.."bg_public.h",
				mme_game.."q_math.c",
				mme_game.."q_shared.c",
				mme_game.."q_shared.h",
				mme_game.."surfaceflags.h",
				
				mme_ui.."ui_public.h",
				mme_ui.."ui_syscalls.c",
				
				mme_cgame.."tr_types.h"
			}
		
		configuration { "vs*" }
			files { mme_q3ui.."ui.def" } -- DLL function export list
		
		ApplyProjectSettings()
		
	project "quake3mme"
	
		configuration {}
			kind "WindowedApp"
			language "C"
			defines { "IOQ3_VM", "BOTLIB", "HAVE_VM_COMPILED", "HAVE_VM_NATIVE", "ENGINE_Q3" }
			includedirs { mme_libs.."jpeg-turbo/include" }
			includedirs { mme_libs.."freetype/include", mme_libs.."freetype/include/freetype" }
		
		configuration "vs*"
			includedirs { mme_libs.."jpeg-turbo/include/msvc" }
			
		configuration "windows"
			flags { "WinMain" }
			
		configuration {}
		
			files 
			{
				mme_src.."botlib/aasfile.h",
				mme_src.."botlib/be_aas_bsp.h",
				mme_src.."botlib/be_aas_bspq3.c",
				mme_src.."botlib/be_aas_cluster.c",
				mme_src.."botlib/be_aas_cluster.h",
				mme_src.."botlib/be_aas_debug.c",
				mme_src.."botlib/be_aas_debug.h",
				mme_src.."botlib/be_aas_def.h",
				mme_src.."botlib/be_aas_entity.c",
				mme_src.."botlib/be_aas_entity.h",
				mme_src.."botlib/be_aas_file.c",
				mme_src.."botlib/be_aas_file.h",
				mme_src.."botlib/be_aas_funcs.h",
				mme_src.."botlib/be_aas_main.c",
				mme_src.."botlib/be_aas_main.h",
				mme_src.."botlib/be_aas_move.c",
				mme_src.."botlib/be_aas_move.h",
				mme_src.."botlib/be_aas_optimize.c",
				mme_src.."botlib/be_aas_optimize.h",
				mme_src.."botlib/be_aas_reach.c",
				mme_src.."botlib/be_aas_reach.h",
				mme_src.."botlib/be_aas_route.c",
				mme_src.."botlib/be_aas_route.h",
				mme_src.."botlib/be_aas_routealt.c",
				mme_src.."botlib/be_aas_routealt.h",
				mme_src.."botlib/be_aas_sample.c",
				mme_src.."botlib/be_aas_sample.h",
				mme_src.."botlib/be_ai_char.c",
				mme_src.."botlib/be_ai_chat.c",
				mme_src.."botlib/be_ai_gen.c",
				mme_src.."botlib/be_ai_goal.c",
				mme_src.."botlib/be_ai_move.c",
				mme_src.."botlib/be_ai_weap.c",
				mme_src.."botlib/be_ai_weight.c",
				mme_src.."botlib/be_ai_weight.h",
				mme_src.."botlib/be_ea.c",
				mme_src.."botlib/be_interface.c",
				mme_src.."botlib/be_interface.h",
				mme_src.."botlib/l_crc.c",
				mme_src.."botlib/l_crc.h",
				mme_src.."botlib/l_libvar.c",
				mme_src.."botlib/l_libvar.h",
				mme_src.."botlib/l_log.c",
				mme_src.."botlib/l_log.h",
				mme_src.."botlib/l_memory.c",
				mme_src.."botlib/l_memory.h",
				mme_src.."botlib/l_precomp.c",
				mme_src.."botlib/l_precomp.h",
				mme_src.."botlib/l_script.c",
				mme_src.."botlib/l_script.h",
				mme_src.."botlib/l_struct.c",
				mme_src.."botlib/l_struct.h",
				mme_src.."botlib/l_utils.h",
				
				mme_src.."cgame/cg_public.h",
				mme_src.."cgame/tr_types.h",
				
				mme_src.."client/cl_cgame.c",
				mme_src.."client/cl_cin.c",
				mme_src.."client/cl_console.c",
				mme_src.."client/cl_demos.c",
				mme_src.."client/cl_input.c",
				mme_src.."client/cl_keys.c",
				mme_src.."client/cl_main.c",
				mme_src.."client/cl_mme.c",
				mme_src.."client/cl_net_chan.c",
				mme_src.."client/cl_parse.c",
				mme_src.."client/cl_scrn.c",
				mme_src.."client/cl_ui.c",
				mme_src.."client/client.h",
				mme_src.."client/fx_local.h",
				mme_src.."client/fx_main.c",
				mme_src.."client/fx_parse.c",
				mme_src.."client/fx_public.h",
				mme_src.."client/fx_types.h",
				mme_src.."client/keys.h",
				mme_src.."client/snd_dma.c",
				mme_src.."client/snd_effects.c",
				mme_src.."client/snd_local.h",
				mme_src.."client/snd_main.c",
				mme_src.."client/snd_mem.c",
				mme_src.."client/snd_mix.c",
				mme_src.."client/snd_mix.h",
				mme_src.."client/snd_mme.c",
				mme_src.."client/snd_public.h",
				
				mme_src.."game/be_aas.h",
				mme_src.."game/be_ai_char.h",
				mme_src.."game/be_ai_chat.h",
				mme_src.."game/be_ai_gen.h",
				mme_src.."game/be_ai_goal.h",
				mme_src.."game/be_ai_move.h",
				mme_src.."game/be_ai_weap.h",
				mme_src.."game/be_ea.h",
				mme_src.."game/bg_public.h",
				mme_src.."game/botlib.h",
				mme_src.."game/g_public.h",
				mme_src.."game/q_math.c",
				mme_src.."game/q_shared.c",
				mme_src.."game/q_shared.h",
				mme_src.."game/surfaceflags.h",
				
				mme_src.."qcommon/alias.c",
				mme_src.."qcommon/cm_load.c",
				mme_src.."qcommon/cm_local.h",
				mme_src.."qcommon/cm_patch.c",
				mme_src.."qcommon/cm_patch.h",
				mme_src.."qcommon/cm_polylib.c",
				mme_src.."qcommon/cm_polylib.h",
				mme_src.."qcommon/cm_public.h",
				mme_src.."qcommon/cm_test.c",
				mme_src.."qcommon/cm_trace.c",
				mme_src.."qcommon/cmd.c",
				mme_src.."qcommon/common.c",
				mme_src.."qcommon/cpuid.c",
				mme_src.."qcommon/cpuid.h",
				mme_src.."qcommon/cvar.c",
				mme_src.."qcommon/files.c",
				mme_src.."qcommon/huffman.c",
				mme_src.."qcommon/md4.c",
				mme_src.."qcommon/msg.c",
				mme_src.."qcommon/net_chan.c",
				mme_src.."qcommon/qcommon.h",
				mme_src.."qcommon/qfiles.h",
				mme_src.."qcommon/unzip.c",
				mme_src.."qcommon/unzip.h",
				mme_src.."qcommon/vm.c",
				mme_src.."qcommon/vm_interpreted.c",
				mme_src.."qcommon/vm_local.h",
				mme_src.."qcommon/vm_x86.c",
				mme_src.."qcommon/vm_x86_ioq3.c",
				
				mme_src.."renderer/libpng/png.c",
				mme_src.."renderer/libpng/png.h",
				mme_src.."renderer/libpng/pngconf.h",
				mme_src.."renderer/libpng/pngdebug.h",
				mme_src.."renderer/libpng/pngerror.c",
				mme_src.."renderer/libpng/pngget.c",
				mme_src.."renderer/libpng/pnginfo.h",
				mme_src.."renderer/libpng/pnglibconf.h",
				mme_src.."renderer/libpng/pngmem.c",
				mme_src.."renderer/libpng/pngpread.c",
				mme_src.."renderer/libpng/pngpriv.h",
				mme_src.."renderer/libpng/pngread.c",
				mme_src.."renderer/libpng/pngrio.c",
				mme_src.."renderer/libpng/pngrtran.c",
				mme_src.."renderer/libpng/pngrutil.c",
				mme_src.."renderer/libpng/pngset.c",
				mme_src.."renderer/libpng/pngstruct.h",
				mme_src.."renderer/libpng/pngtrans.c",
				mme_src.."renderer/libpng/pngwio.c",
				mme_src.."renderer/libpng/pngwrite.c",
				mme_src.."renderer/libpng/pngwtran.c",
				mme_src.."renderer/libpng/pngwutil.c",
				mme_src.."renderer/qgl.h",
				mme_src.."renderer/tr_animation.c",
				mme_src.."renderer/tr_backend.c",
				mme_src.."renderer/tr_bloom.c",
				mme_src.."renderer/tr_bsp.c",
				mme_src.."renderer/tr_cmds.c",
				mme_src.."renderer/tr_curve.c",
				mme_src.."renderer/tr_flares.c",
				mme_src.."renderer/tr_font.c",
				mme_src.."renderer/tr_framebuffer.c",
				mme_src.."renderer/tr_glslprogs.c",
				mme_src.."renderer/tr_image.c",
				mme_src.."renderer/tr_init.c",
				mme_src.."renderer/tr_light.c",
				mme_src.."renderer/tr_local.h",
				mme_src.."renderer/tr_main.c",
				mme_src.."renderer/tr_marks.c",
				mme_src.."renderer/tr_mesh.c",
				mme_src.."renderer/tr_mme.c",
				mme_src.."renderer/tr_mme.h",
				mme_src.."renderer/tr_mme_avi.c",
				mme_src.."renderer/tr_mme_common.c",
				mme_src.."renderer/tr_mme_fbo.c",
				mme_src.."renderer/tr_mme_sse2.c",
				mme_src.."renderer/tr_mme_stereo.c",
				mme_src.."renderer/tr_model.c",
				mme_src.."renderer/tr_noise.c",
				mme_src.."renderer/tr_public.h",
				mme_src.."renderer/tr_scene.c",
				mme_src.."renderer/tr_shade.c",
				mme_src.."renderer/tr_shade_calc.c",
				mme_src.."renderer/tr_shader.c",
				mme_src.."renderer/tr_shadows.c",
				mme_src.."renderer/tr_sky.c",
				mme_src.."renderer/tr_surface.c",
				mme_src.."renderer/tr_world.c",
				mme_src.."renderer/zlib/adler32.c",
				mme_src.."renderer/zlib/compress.c",
				mme_src.."renderer/zlib/crc32.c",
				mme_src.."renderer/zlib/crc32.h",
				mme_src.."renderer/zlib/deflate.c",
				mme_src.."renderer/zlib/deflate.h",
				mme_src.."renderer/zlib/gzclose.c",
				mme_src.."renderer/zlib/gzguts.h",
				mme_src.."renderer/zlib/gzlib.c",
				mme_src.."renderer/zlib/gzread.c",
				mme_src.."renderer/zlib/gzwrite.c",
				mme_src.."renderer/zlib/infback.c",
				mme_src.."renderer/zlib/inffast.c",
				mme_src.."renderer/zlib/inffast.h",
				mme_src.."renderer/zlib/inffixed.h",
				mme_src.."renderer/zlib/inflate.c",
				mme_src.."renderer/zlib/inflate.h",
				mme_src.."renderer/zlib/inftrees.c",
				mme_src.."renderer/zlib/inftrees.h",
				mme_src.."renderer/zlib/ioapi.c",
				mme_src.."renderer/zlib/ioapi.h",
				mme_src.."renderer/zlib/trees.c",
				mme_src.."renderer/zlib/trees.h",
				mme_src.."renderer/zlib/uncompr.c",
				mme_src.."renderer/zlib/zconf.h",
				mme_src.."renderer/zlib/zlib.h",
				mme_src.."renderer/zlib/zutil.c",
				mme_src.."renderer/zlib/zutil.h",
				
				mme_src.."server/server.h",
				mme_src.."server/sv_bot.c",
				mme_src.."server/sv_ccmds.c",
				mme_src.."server/sv_client.c",
				mme_src.."server/sv_demos.c",
				mme_src.."server/sv_game.c",
				mme_src.."server/sv_init.c",
				mme_src.."server/sv_main.c",
				mme_src.."server/sv_net_chan.c",
				mme_src.."server/sv_snapshot.c",
				mme_src.."server/sv_world.c",
				
				mme_src.."ui/keycodes.h",
				mme_src.."ui/ui_public.h"
			}
		
		configuration {}
			links { "jpeg", "freetype" }
		
		configuration "vs*"
			AddMasmFile ( "ftola" )
			files { mme_src.."win32/qe3.ico", mme_src.."win32/winquake.rc" }
			
		configuration "windows"
			files 
			{  
				mme_src.."win32/glw_win.h",
				mme_src.."win32/resource.h",
				mme_src.."win32/win_gamma.c",
				mme_src.."win32/win_glimp.c",
				mme_src.."win32/win_input.c",
				mme_src.."win32/win_local.h",
				mme_src.."win32/win_main.c",
				mme_src.."win32/win_net.c",
				mme_src.."win32/win_qgl.c",
				mme_src.."win32/win_shared.c",
				mme_src.."win32/win_snd.c",
				mme_src.."win32/win_syscon.c",
				mme_src.."win32/win_wndproc.c"
			}
			
		configuration "x32"
			libdirs { mme_libs.."jpeg-turbo/x86", mme_libs.."freetype/x86" }
			
		configuration "x64"
			libdirs { mme_libs.."jpeg-turbo/x64", mme_libs.."freetype/x64" }
		
		configuration "vs*"
			links { "ws2_32", "winmm" }
			
		ApplyProjectSettings( false )
			
		
		
		
		
		

	
