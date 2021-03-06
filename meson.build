project('Aegisub', ['c', 'cpp'],
        license: 'BSD-3-Clause',
        meson_version: '>=0.50.0',
        # c_std=c11 should be here but it breaks Linux builds for some reason, needs investigation
        default_options: ['cpp_std=c++11', 'b_lto=true'],
        version: '3.3.2-2')

if host_machine.system() == 'windows'
    version_sh = find_program('tools/version.ps1')
else
    version_sh = find_program('tools/version.sh')
endif
version_inc = include_directories('.')
version_h = custom_target('git_version.h',
                          command: [version_sh, meson.source_root()],
                          build_by_default: true,
                          build_always_stale: true, # has internal check whether target file will be refreshed
                          output: ['git_version.h', 'git_version.xml'])

if host_machine.system() == 'darwin' and get_option('build_osx_bundle')
    prefix = meson.current_build_dir() / 'Aegisub.app' / 'Contents'
    bindir = prefix / 'MacOS'
    datadir = prefix / 'SharedSupport'
    localedir = prefix / 'Resources'
else
    prefix = get_option('prefix')
    bindir = prefix / get_option('bindir')
    datadir = prefix / get_option('datadir')
    localedir = prefix / get_option('localedir')
endif
docdir = prefix / 'doc'
dataroot = datadir / 'aegisub'
add_project_arguments('-DP_DATA="@0@"'.format(dataroot), language: 'cpp')

if host_machine.system() == 'windows'
    add_project_arguments('-DNOMINMAX', '-D_WIN32_WINNT=0x0602', language: 'cpp')
endif

conf = configuration_data()
conf.set_quoted('P_DATA', dataroot)
if get_option('credit') != ''
    conf.set_quoted('BUILD_CREDIT', get_option('credit'))
endif
conf.set('WITH_UPDATE_CHECKER', get_option('enable_update_checker'))
conf.set_quoted('UPDATE_CHECKER_SERVER', get_option('update_server'))
conf.set_quoted('UPDATE_CHECKER_BASE_URL', get_option('update_url'))

deps = []
deps_inc = []

if host_machine.system() == 'darwin'
    add_languages('objc', 'objcpp')
    add_project_arguments('-DGL_SILENCE_DEPRECATION', language: 'cpp')
    # meson does not currently support objcpp_std
    add_project_arguments('-std=c++11', language: 'objcpp')
elif host_machine.system() != 'windows'
    deps += dependency('fontconfig')
endif

cxx = meson.get_compiler('cpp')
cc = meson.get_compiler('c')
deps += cc.find_library('m', required: false)
deps += cc.find_library('dl', required: false)
iconv_dep = cc.find_library('iconv', required: false)
if not iconv_dep.found() and host_machine.system() == 'windows'
    iconv_sp = subproject('iconv') # this really needs to be replaced with a proper port
    deps_inc += iconv_sp.get_variable('iconv_incs')
    iconv_dep = iconv_sp.get_variable('libiconv_dep')
endif
deps += iconv_dep

deps += dependency('libass', version: '>=0.9.7',
                   fallback: ['libass', 'libass_dep'])

if get_option('enable_update_checker')
    deps += dependency('boost', version: '>=1.66.0',
                       modules: ['chrono', 'filesystem', 'locale', 'regex',
                                 'system', 'thread'])
    deps += dependency('openssl')
else
    deps += dependency('boost', version: '>=1.50.0',
                       modules: ['chrono', 'filesystem', 'locale', 'regex',
                                 'system', 'thread'])
endif

deps += dependency('zlib', fallback: ['zlib', 'zlib_dep'])

wx_dep = dependency('wxWidgets', version: '>=3.0.0',
                    required: cxx.get_id() != 'msvc',
                    modules: ['std', 'stc', 'gl'])
if not wx_dep.found() # this will only be hit with msvc
    if get_option('wx_path') != ''
        deps_inc += include_directories(get_option('wx_path') / 'include' / 'msvc', get_option('wx_path') / 'include')
        add_project_arguments('-DUNICODE', '-D_UNICODE', language: 'cpp')
        add_project_arguments('-DwxMSVC_VERSION_AUTO', '-DWXUSINGDLL', language: 'cpp')
    else
        error('wxWidgets not found and no wx_path defined.')
    endif
endif
deps += wx_dep

icu_uc_dep = dependency('icu-uc', version: '>=4.8.1.1', required: cxx.get_id() != 'msvc')
icu_i18n_dep = dependency('icu-i18n', version: '>=4.8.1.1', required: cxx.get_id() != 'msvc')
if not (icu_uc_dep.found() and icu_i18n_dep.found())
    if get_option('icu_path') != ''
        deps_inc += include_directories(get_option('icu_path') / 'include')
    else
        error('ICU not found and no icu_path defined.')
    endif
endif
if not icu_uc_dep.found()
    icu_uc_dep = cxx.find_library('icuuc', dirs: get_option('icu_path') / 'lib64')
endif
deps += icu_uc_dep
if not icu_i18n_dep.found()
    icu_i18n_dep = cxx.find_library('icuin', dirs: get_option('icu_path') / 'lib64')
endif
deps += icu_i18n_dep

dep_avail = []
foreach dep: [
    # audio, in order of precedence
    ['libpulse', '', 'PulseAudio'],
    ['alsa', '', 'ALSA'],
    ['portaudio-2.0', '', 'PortAudio'],
    ['openal', '>=0.0.8', 'OpenAL'],
    # video
    ['ffms2', '', 'FFMS2'], # needs a proper port
    # other
    ['fftw3', '', 'FFTW3'],
    ['hunspell', '', 'Hunspell'], # needs a proper port
    ['uchardet', '', 'uchardet'], # needs a proper port
]
    d = dependency(dep[0], version: dep[1] != '' ? dep[1]: '>=0',
                   required: false)

    optname = dep[0].split('-')[0]
    if d.found() and not get_option(optname).disabled()
        deps += d
        conf.set('WITH_@0@'.format(dep[0].split('-')[0].to_upper()), '1')
        dep_avail += dep[2]
    elif get_option(optname).enabled()
        error('@0@ enabled but not found'.format(dep[2]))
    endif
endforeach

if host_machine.system() == 'windows' and not get_option('directsound').disabled()
    dsound_dep = cc.find_library('dsound', required: get_option('directsound'))
    winmm_dep = cc.find_library('winmm', required: get_option('directsound'))
    ole32_dep = cc.find_library('ole32', required: get_option('directsound'))
    have_dsound_h = cc.has_header('dsound.h')
    if not have_dsound_h and get_option('directsound').enabled()
        error('DirectSound enabled but dsound.h not found')
    endif
    if dsound_dep.found() and winmm_dep.found() and ole32_dep.found() and have_dsound_h
        deps += [dsound_dep, winmm_dep, ole32_dep]
        conf.set('WITH_DIRECTSOUND', '1')
        dep_avail += 'DirectSound'
    endif
endif

if host_machine.system() == 'darwin'
    frameworks_dep = dependency('appleframeworks', modules : ['CoreText', 'CoreFoundation'])
    deps += frameworks_dep
endif

# TODO: OSS

def_audio = get_option('default_audio_output')
if def_audio != 'auto'
    if not dep_avail.contains(def_audio)
        error('Default audio output "@0@" selected but not available'.format(def_audio))
    endif
elif dep_avail.length() != 0
    def_audio = dep_avail[0]
else
    def_audio = ''
endif

conf_platform = configuration_data()
conf_platform.set('DEFAULT_PLAYER_AUDIO', def_audio)

luajit = dependency('luajit', version: '>=2.0.0', required: get_option('system_luajit'))
if luajit.found()
    luajit_test = cc.run('''#include <lauxlib.h>
int main(void)
{
    lua_State *L = luaL_newstate();
    if (!L) return 1;
    // This is valid in lua 5.2, but a syntax error in 5.1
    const char testprogram[] = "function foo() while true do break return end end";
    return luaL_loadstring(L, testprogram) == LUA_ERRSYNTAX;
}''', dependencies: luajit)

    if luajit_test.returncode() == 1
        if get_option('system_luajit')
            error('System luajit found but not compiled in 5.2 mode')
        else
            message('System luajit found but not compiled in 5.2 mode; using built-in luajit')
        endif
    else
        deps += luajit
    endif
else
    message('System luajit not found; using built-in luajit')
endif

if not deps.contains(luajit)
    luajit_sp = subproject('luajit')
    luajit_inc = luajit_sp.get_variable('incdir')
    deps += luajit_sp.get_variable('luajit_dep')
else
    luajit_inc = include_directories(luajit.get_pkgconfig_variable('includedir'))
endif
subdir('subprojects/luabins/src')

dep_gl = dependency('gl', required: false)
if not dep_gl.found()
    if host_machine.system() == 'windows'
        dep_gl = cc.find_library('opengl32', required: false)
    else
        dep_gl = cc.find_library('GL', required: false)
    endif

    if not cc.has_header('GL/gl.h')
        dep_gl = dependency('', required: false)
    endif
endif
if host_machine.system() == 'darwin'
    conf.set('HAVE_OPENGL_GL_H', 1)
endif

if not dep_gl.found()
    error('OpenGL implementation not found')
endif

deps += dep_gl

# TODO: csri

acconf = configure_file(output: 'acconf.h', configuration: conf)

subdir('automation')
subdir('libaegisub')
subdir('packages')
subdir('po')
subdir('src')
