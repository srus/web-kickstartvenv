#!/usr/bin/env bash

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

# Check system dependencies

if [[ -z "`which python`" ]]; then
    echo "FATAL: Could not find 'python'"
    echo "Please install Python: https://www.python.org/downloads/"
    exit 1
fi

if [[ -z "`which pip`" ]]; then
    echo "FATAL: Could not find 'pip'"
    echo "Please install Pip: https://pypi.python.org/pypi/pip/"
    exit 1
fi

if [[ -z "`which virtualenv`" ]]; then
    echo "FATAL: Could not find 'virtualenv'"
    echo "Please install Virtualenv: https://pypi.python.org/pypi/virtualenv/"
    exit 1
fi

venvwrapper="`which virtualenvwrapper.sh`"

if [[ -z "$venvwrapper" ]]; then
    echo "FATAL: Could not find 'virtualenvwrapper.sh'"
    echo "Please install Virtualenvwrapper: https://pypi.python.org/pypi/virtualenvwrapper/"
    exit 1
fi

# Node version
node_version="`grep '"node":' package.json | awk '{print $2}' | tr -d '"<>='`"
test "$node_version" == "" && { echo "FATAL: Could not fetch Node.js version"; exit 1; }
echo ""
echo -e "${txtgrn}Using Node.js ${node_version} ...${txtrst}"
echo ""

# Ruby version
ruby_version="`grep '^ruby ' Gemfile | awk '{print $2}' | cut -d"'" -f2`"
test "$ruby_version" == "" && { echo "FATAL: Could not fetch Ruby version"; exit 1; }
echo ""
echo -e "${txtgrn}Using Ruby ${ruby_version} ...${txtrst}"
echo ""

# Current path
proj_path="`pwd`"

# Check if dir exists
if [[ ! -d "${proj_path}/conf" ]]; then
    mkdir "${proj_path}/conf" || { echo "FATAL: Could not create 'conf' directory"; exit 1; }
fi

# Build virtualenv environment
source "$venvwrapper"
mkvirtualenv "$venv_name"

# Set and activate virtualenv postactivate script
cd "${proj_path}/boot/virtualenv/bin/"
cp postactivate.skel postactivate
cp postdeactivate.skel postdeactivate
path="${proj_path//\//\\/}"  # escape forward slashes
sed -i "s/{{proj_path}}/$path/g" postactivate
sed -i "s/{{node_version}}/$node_version/g" postactivate
sed -i "s/{{ruby_version}}/$ruby_version/g" postactivate
sed -i "s/{{env_name}}/$venv_name/g" postactivate
mv -f postactivate "${VIRTUAL_ENV}/bin/postactivate"
mv -f postdeactivate "${VIRTUAL_ENV}/bin/postdeactivate"
deactivate
source "$venvwrapper"
workon "$venv_name"

echo ""
echo -e "${txtgrn}Installing Python packages...${txtrst}"
echo ""

# Install Python packages
pip install -U -r "${proj_path}/requirements/development.txt" || { echo "FATAL: Could not install Python packages"; exit 1; }

# Create link to Python packages
ln -sf "${VIRTUAL_ENV}/lib/python2.7/site-packages" "${proj_path}/python_packages"

# Install and set Ruby virtual environment: http://rvm.io/
curl -sSL https://get.rvm.io | bash || { echo "FATAL: Could not install RVM"; exit 1; }
source "$HOME/.rvm/scripts/rvm"
rvm install $ruby_version
rvm use "${ruby_version}@${venv_name}" --create

echo ""
echo -e "${txtgrn}Installing Ruby packages...${txtrst}"
echo ""

# Install Ruby packages
bundle install || { echo "FATAL: Could not install Ruby packages"; exit 1; }

# Install and set Node.js virtual environment: https://github.com/creationix/nvm
curl https://raw.githubusercontent.com/creationix/nvm/v0.24.0/install.sh | bash
source ~/.nvm/nvm.sh || { echo "FATAL: Could not install NVM"; exit 1; }
nvm install $node_version

echo ""
echo -e "${txtgrn}Installing Node packages...${txtrst}"
echo ""

# Install Node packages
npm install || { echo "FATAL: Could not install Node packages"; exit 1; }

echo ""
echo -e "${txtgrn}Configuring IPython...${txtrst}"
echo ""

# Set IPython default profile
ipython profile create || { echo "FATAL: Could not create IPython profile"; exit 1; }
ln -sf "${proj_path}/boot/ipython/ipython_config.py" "${proj_path}/conf/ipython/profile_default/ipython_config.py"

echo ""
echo -e "${bldgrn}OK, project deployed.${txtrst}"
echo ""

exit 0
