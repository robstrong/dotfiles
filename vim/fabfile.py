from fabric.api import *
from fabric.context_managers import cd

env.use_ssh_config = True

def install():
    with cd('~'):
        run('git clone git@github.com:robstrong/vim-config .vim')
        run('ln -s ~/.vim/vimrc .vimrc')
    put('~/.wakatime.cfg', '~/.wakatime.cfg')
    with cd('~/.vim'):
        run('git submodule init')
        run('git submodule update')
        run('vim +PluginInstall +qall')
