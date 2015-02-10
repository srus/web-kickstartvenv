#!/usr/bin/env bash

# Current path
proj_path="`pwd`"

# Project name
proj_name="`basename $proj_path`"

# Ruby version
ruby_version="`grep '^ruby ' Gemfile | awk '{print $2}' | cut -d"'" -f2`"

# Node version
node_version="`grep '"node":' package.json | awk '{print $2}' | tr -d '"<>='`"

# Prompt colors
txtrst='\e[0m'     # text reset
txtylw='\e[0;33m'  # regular yellow
txtgrn='\e[0;32m'  # regular green
bldgrn='\e[1;32m'  # bold green

# User prompt
echo ""
echo -en "${txtylw}Name of project's virtualenv: ${txtrst}"
read venv_name
echo ""

# Check if dir exists
if [[ ! -d "${proj_path}/conf" ]]; then
    mkdir "${proj_path}/conf"
fi

# Build virtualenv environment
source /usr/local/bin/virtualenvwrapper.sh
mkvirtualenv "$venv_name"

# Set and activate virtualenv postactivate script
cd "${proj_path}/boot/virtualenv/bin/"
cp postactivate.skel postactivate
cp postdeactivate.skel postdeactivate
path="${proj_path//\//\\/}"  # escape forward slashes
sed -i "s/{{proj_path}}/$path/g" postactivate
sed -i "s/{{node_version}}/$node_version/g" postactivate
sed -i "s/{{ruby_version}}/$ruby_version/g" postactivate
mv -f postactivate "${WORKON_HOME}/${venv_name}/bin/postactivate"
mv -f postdeactivate "${WORKON_HOME}/${venv_name}/bin/postdeactivate"
deactivate
source /usr/local/bin/virtualenvwrapper.sh
workon "$venv_name"

echo ""
echo -e "${txtgrn}Installing Python packages...${txtrst}"
echo ""

# Install Python packages
pip install -U -r "${proj_path}/requirements/development.txt"

# Create link to Python packages
ln -sf "$WORKON_HOME/${venv_name}/lib/python2.7/site-packages" "${proj_path}/python_packages"

# Install and set Ruby virtual environment: http://rvm.io/
curl -sSL https://get.rvm.io | bash
source "$HOME/.rvm/scripts/rvm"
rvm install $ruby_version
rvm use $ruby_version@$venv_name --create

echo ""
echo -e "${txtgrn}Installing Ruby packages...${txtrst}"
echo ""

# Install Ruby packages
bundle install

# Install and set Node.js virtual environment: https://github.com/creationix/nvm
curl https://raw.githubusercontent.com/creationix/nvm/v0.22.1/install.sh | bash
source ~/.nvm/nvm.sh
nvm install $node_version

# Install the latest NPM
curl -L https://npmjs.com/install.sh | sh

echo ""
echo -e "${txtgrn}Installing Node packages...${txtrst}"
echo ""

# Install Node packages
npm install

echo ""
echo -e "${txtgrn}Configuring IPython...${txtrst}"
echo ""

# Set IPython default profile
ipython profile create
ln -sf "${proj_path}/boot/ipython/ipython_config.py" "${proj_path}/conf/ipython/profile_default/ipython_config.py"

echo ""
echo -e "${bldgrn}OK, project deployed.${txtrst}"
echo ""

exit 0
