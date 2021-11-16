dotfilespath="$HOME/me/dotfiles/nvim"
configpath="$HOME/.config/nvim"

echo "cp -r $configpath/after $dotfilespath"
cp -r "$configpath/after" "$dotfilespath"

echo "cp -r $configpath/lua $dotfilespath"
cp -r "$configpath/lua" "$dotfilespath"

echo "cp $configpath/init.vim $dotfilespath"
cp "$configpath/init.vim" "$dotfilespath"
