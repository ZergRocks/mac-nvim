" Treesitter 파서 수동 설치 스크립트
" Neovim 내에서 실행: :source install_treesitter.vim

echo "Installing Treesitter SQL parser..."
:TSInstall sql

echo "Installing other parsers..."
:TSInstall lua python javascript typescript yaml json markdown

echo "Treesitter parsers installed!"
echo "Run :TSInstallInfo to check status"