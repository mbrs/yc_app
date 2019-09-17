#!/bin/bash

NAME="yc_app"                              #Name of the application (*)
DJANGODIR=~/Github/Moonbird/yc_app/yc_app             # Django project directory (*)
SOCKFILE=~/Github/Moonbird/yc_app/yc_app/run/gunicorn.sock        # we will communicate using this unix socket (*)
USER=Mich                                        # the user to run as (*)
GROUP=webdata                                     # the group to run as (*)
NUM_WORKERS=1                                     # how many worker processes should Gunicorn spawn (*)
DJANGO_SETTINGS_MODULE=yc_app.settings             # which settings file should Django use (*)
DJANGO_WSGI_MODULE=yc_app.wsgi                     # WSGI module name (*)

echo "Starting $NAME as Mich"

# Activate the virtual environment
cd $DJANGODIR
source ~/Github/Moonbird/moonbird/bin/activate
export DJANGO_SETTINGS_MODULE=$DJANGO_SETTINGS_MODULE
export PYTHONPATH=$DJANGODIR:$PYTHONPATH

# Create the run directory if it doesn't exist
RUNDIR=$(dirname $SOCKFILE)
test -d $RUNDIR || mkdir -p $RUNDIR

# Start your Django Unicorn
# Programs meant to be run under supervisor should not daemonize themselves (do not use --daemon)
exec ~/Github/Moonbird/moonbird/bin/gunicorn ${DJANGO_WSGI_MODULE}:application \
  --name $NAME \
  --workers $NUM_WORKERS \
  --user $USER \
  --bind=unix:$SOCKFILE
