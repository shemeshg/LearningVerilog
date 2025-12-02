#!/bin/zsh
script_dir=$(dirname $(realpath "$0"))

cd "$script_dir/.."
if [ ! -d ".venv" ]; then
    python3 -m venv .venv
    source .venv/bin/activate
    pip install cogapp Jinja2
else
    source .venv/bin/activate
fi


cd "$script_dir/.."
cd Bal/prptHpp
cog -r *.hpp

cd "$script_dir/.."
cd  Bal/
cog -r CMakeLists.txt

cd "$script_dir/.."
cog -r CMakeLists.txt

cd "$script_dir/../Design/DesignContent"
python3  genQmlDirAndCMake.py

cd "$script_dir/../Design/Playground"
python3  genQmlDirAndCMake.py

cd "$script_dir/../Design/Core"
python3  genQmlDirAndCMake.py