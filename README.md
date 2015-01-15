# web-kickstartvenv

Web project skeleton with [Virtualenv](https://github.com/pypa/virtualenv), [Nodeenv](https://github.com/ekalinin/nodeenv), [NVM](https://github.com/creationix/nvm) and [RVM](https://github.com/wayneeseguin/rvm).

## Main features

- Common skeleton for a broad range of web projects.
- Virtual environments for Python, Ruby and Node.js.
- Project deployment in one build step.
- Some useful tools included by default: [IPython](http://ipython.org/), [Sass](http://sass-lang.com/), [Bower](http://bower.io/), [Grunt](http://gruntjs.com/), [Gulp](http://gulpjs.com/), [Yeoman](http://yeoman.io/).
- IPython pre-configured for compatibility with Python 3 syntax.
- Some useful pre-configurations for your Virtualenv postactivate script.

## System requirements

- Python >=2.7.3
- Pip >=1.5.3
- Virtualenv >=1.11.6
- Virtualenvwrapper >=4.2

## Project deployment

Move to the same path as this file and run: `./bin/build.sh`. And don't forget to **use the same name for your virtualenv and your project directory**.

## Directory structure

- **bin/**: scripts.
- **boot/**: bootstrap templates for config files.
- **conf/**: config files; generated automatically on every build.
- **docs/**: project documentation.
- **requirements/**: Python dependencies.
- **src/**: your code goes here.

