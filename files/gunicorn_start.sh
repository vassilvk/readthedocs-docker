#!/bin/bash

NAME="readthedocs"                                  # Name of the application
DJANGODIR=/www/readthedocs.org                      # Django project directory
SOCKFILE=/www/readthedocs.org/run/gunicorn.sock     # We will communicate using this unix socket
USER=root                                           # The user to run as
GROUP=root                                          # The group to run as
NUM_WORKERS=3                                       # How many worker processes should Gunicorn spawn
DJANGO_SETTINGS_MODULE=readthedocs.settings.sqlite  # Which settings file should Django use
DJANGO_WSGI_MODULE=readthedocs.wsgi                 # WSGI module name

echo "Starting $NAME as `whoami`"

# Activate the virtual environment
cd $DJANGODIR

export DJANGO_SETTINGS_MODULE=$DJANGO_SETTINGS_MODULE
export PYTHONPATH=$DJANGODIR:$PYTHONPATH

# Create the run directory if it doesn't exist
RUNDIR=$(dirname $SOCKFILE)
test -d $RUNDIR || mkdir -p $RUNDIR

# Start your Django Unicorn
# Programs meant to be run under supervisor should not daemonize themselves (do not use --daemon)
exec gunicorn ${DJANGO_WSGI_MODULE}:application \
  --name $NAME \
  --workers $NUM_WORKERS \
  --user=$USER \
  --group=$GROUP \
  --bind=unix:$SOCKFILE \
  --timeout=300 \
  --log-level=debug \
  --log-file=-
