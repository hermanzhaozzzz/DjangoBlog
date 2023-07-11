#!/bin/bash
# 把环境放在最前
PATH=/home/zhaohuanan/0.apps/micromamba/envs/djangoblog/bin:$PATH
echo -e "--------------------\n"
echo "now, python=`which python`"
echo "now, gunicorn=`which gunicorn`"
echo -e "--------------------\n"
# 项目的名称
NAME="DjangoBlog"
# Django项目路径
DJANGODIR=/home/zhaohuanan/0.myblog/DjangoBlog/DjangoBlog  #Django project directory
# 用户名
USER=zhaohuanan # the user to run as
# 用户组，需要是sudo用户组的才可以
GROUP=sudo # the group to run as
NUM_WORKERS=1 # how many worker processes should Gunicorn spawn
DJANGO_SETTINGS_MODULE=DjangoBlog.settings # which settings file should Django use
DJANGO_WSGI_MODULE=DjangoBlog.wsgi # WSGI module name
echo -e "--------------------\n"
echo "Starting $NAME as `whoami`"
echo -e "--------------------\n"
# Activate the virtual environment
cd $DJANGODIR

export DJANGO_SETTINGS_MODULE=$DJANGO_SETTINGS_MODULE

export PYTHONPATH=`dirname $DJANGODIR`

# Create the run directory if it doesn't exist
RUNDIR=$(dirname $SOCKFILE)
test -d $RUNDIR || mkdir -p $RUNDIR
echo -e "--------------------\n"
echo "DJANGODIR=$DJANGODIR"
echo "RUNDIR=$RUNDIR"
echo "DJANGO_WSGI_MODULE=$DJANGO_WSGI_MODULE"
echo "DJANGO_SETTINGS_MODULE=$DJANGO_SETTINGS_MODULE"
echo "PYTHONPATH=$PYTHONPATH"
echo -e "--------------------\n"
# Start your Django Unicorn
# Programs meant to be run under supervisor should not daemonize themselves (do not use --daemon)
exec gunicorn  ${DJANGO_WSGI_MODULE}:application \
--name $NAME \
--workers $NUM_WORKERS \
--user=$USER --group=$GROUP \
--log-level=debug \
--log-file=-
echo -e "--------------------\n"
echo "exec done!"
echo -e "--------------------\n"
