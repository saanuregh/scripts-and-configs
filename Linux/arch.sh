sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zplugin/master/doc/install.sh)"
yay -S pyenv unzip fzf --noconfirm
curl -sSL https://raw.githubusercontent.com/sdispater/poetry/master/get-poetry.py > get-poetry.py
python get-poetry.py --preview
git clone https://github.com/momo-lab/pyenv-install-latest.git "$(pyenv root)"/plugins/pyenv-install-latest
mkdir $(pyenv root)/completions
curl -sL --proto-redir -all,https https://raw.githubusercontent.com/pyenv/pyenv/master/completions/pyenv.zsh > $(pyenv root)/completions/pyenv.zsh
latest=$(pyenv install --list | grep -vE "(^Available versions:|-src|dev|rc|alpha|beta|(a|b)[0-9]+)" | grep -E "^\s*[0-9]" | sed 's/^\s\+//' | tail -1 )
pyenv install $latest
pyenv global $latest
exec $SHELL
touch ~/.zprofile
curl -sL --proto-redir -all,https https://raw.githubusercontent.com/kornicameister/dotfiles/master/zsh/zlogin > ~/.zlogin
curl -sL --proto-redir -all,https https://raw.githubusercontent.com/kornicameister/dotfiles/master/zsh/zshenv > ~/.zshenv
echo fs.inotify.max_user_watches=524288 | sudo tee /etc/sysctl.d/40-max-user-watches.conf && sudo sysctl --system