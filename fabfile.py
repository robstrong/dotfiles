from fabric.api import *
from fabric.context_managers import cd

env.use_ssh_config = True

def install():
    run('sh -c "$(curl -fsSL https://raw.github.com/robstrong/dotfiles/master/install.sh)"')
    put('~/.wakatime.cfg', '~/.wakatime.cfg')
