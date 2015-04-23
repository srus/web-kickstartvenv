# web-kickstartvenv [![Build status](https://travis-ci.org/srus/web-kickstartvenv.svg?branch=master)](https://travis-ci.org/srus/web-kickstartvenv)

Start your next web project with a pre-configured virtual environment in a few seconds.

## Main features

- Common skeleton for a broad range of web projects.
- Project deployment in one build step.
- Pre-configured virtual environments for Python (thanks to [Virtualenv](https://github.com/pypa/virtualenv) and [Virtualenvwrapper](https://bitbucket.org/dhellmann/virtualenvwrapper/)), Ruby (thanks to [RVM](https://github.com/wayneeseguin/rvm)) and Node.js (thanks to [Nodeenv](https://github.com/ekalinin/nodeenv)).
- Some useful tools included by default: [IPython](http://ipython.org/), [Sass](http://sass-lang.com/), [Bower](http://bower.io/), [Grunt](http://gruntjs.com/), [Gulp](http://gulpjs.com/), [Yeoman](http://yeoman.io/).
- IPython pre-configured for compatibility with Python 3 syntax.
- Some useful pre-configurations for Virtualenvwrapper [postactivate](http://virtualenvwrapper.readthedocs.org/en/latest/scripts.html#postactivate) script.

## System requirements

- [Python](https://www.python.org/)
- [Pip](https://pypi.python.org/pypi/pip/)
- [Virtualenv](https://pypi.python.org/pypi/virtualenv/)
- [Virtualenvwrapper](https://pypi.python.org/pypi/virtualenvwrapper/)

## Project deployment

- Download this project.
- Rename the folder as you want.
- Add your Python dependencies in the `requirements` folder.
- Add your Ruby dependencies in `Gemfile`.
- Add your Node.js dependencies in `package.json`. 
- Move to the project root folder and run: `./bin/build.sh`. You can run this script whenever you need to update the project.

Finally type `workon` and the name of your virtualenv to start working on your new project. See the [Virtualenvwrapper docs](http://virtualenvwrapper.readthedocs.org/) to learn more about the workflow with this virtual environments manager.

## Directory structure

- **bin/**: scripts.
- **boot/**: bootstrap templates for config files.
- **conf/**: config files; generated automatically on every build.
- **docs/**: project documentation.
- **requirements/**: Python dependencies.
- **src/**: your code goes here.

