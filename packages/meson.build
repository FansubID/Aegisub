c_pkg = configuration_data()
c_pkg.set('AEGISUB_COMMAND', 'aegisub')

if host_machine.system() == 'windows'
elif host_machine.system() == 'darwin'
else
    configure_file(input: 'desktop/aegisub.desktop.template.in',
                   output: 'aegisub.desktop',
                   configuration: c_pkg,
                   install_dir: get_option('datadir') / 'applications')
endif

aegisub_logos = ['16x16.png', '22x22.png', '24x24.png', '32x32.png', '48x48.png', '64x64.png', 'scalable.svg']

foreach s: aegisub_logos
    dir = s.split('.')[0]
    ext = s.split('.')[1]
    install_data('desktop' / dir / 'aegisub.' + ext, 
                 install_dir: get_option('datadir') / 'icons' / 'hicolor' / dir / 'apps')
endforeach