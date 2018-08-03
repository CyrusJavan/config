# ----------------------------------------------------------------------------
#
# Description: This file holds all my BASH configurations and aliases
#
# 1. Environment Configuration
# 2. Terminal Configurations
# 3. File and Folder Management
# 4. Searching
# 5. Perfoce
# 6. Archive
#
# ----------------------------------------------------------------------------

# ----------------------------
# 1. Environment Configuration
# ----------------------------
export PROMPT_COMMAND='history -a' #Appends ALL terminal changes
export EDITOR=vim

# Adjust history sizes
export HISTSIZE=5000 # Size, in lines, of the history that bash will keep in memory for the current session
export HISTFILESIZE=10000 # Size, in lines, of the history that bash will keep on disk, in .bash_history

# Keeps my terminal colors even when coming in from putty session
if [ "$COLORTERM" == "gnome-terminal" ]; then
  export TERM=xterm-256color
fi

# ----------------------------
# 1a. Accuray Configuration
# ----------------------------
export QT_PLUGIN_PATH=/usr/local/Trolltech/Qt-5.9.1/qtbase/plugins
export QT4DIR=/usr/local/Trolltech/Qt-4.7.2
export QT5DIR=/usr/local/Trolltech/Qt-5.9.1
export QTDIR=/usr/local/qt-x11-commercial-3.3.4
if [ ! -d $QTDIR ]; then
  if [ -d /usr/local/qt ]; then
    export QTDIR=/usr/local/qt
  else
    echo "===== ERROR: QTDIR does not exist: $QTDIR"
  fi
fi

path=
path=$path:/bin
path=$path:/sbin
path=$path:/usr/bin
path=$path:/usr/sbin
path=$path:/usr/atria/bin
path=$path:/usr/local/bin
path=$path:/etc
path=$path:/usr/etc
path=$path:/usr/local/cuda/bin
path=$path:$QT4DIR/bin
path=$path:$QT5DIR/bin
path=$path:$QTDIR/bin
path=$path:/opt/intel/composer_xe_2015/bin
export PATH=$path

export CUDA_INSTALL_PATH=/usr/local/cuda
export INTEL_LICENSE_FILE=/opt/intel/licenses

# ----------------------------
# 5. Perfoce
# ----------------------------
# Runs script to determine which perforce ws is currently active
export P4USER=${USER}
export P4CLIENT=`~/Tools/perforce/sws.sh -a`
export P4ROOT="/usr/local/perforce/${P4USER}"
export P4PORT=10.20.10.190:1666
export P4EDITOR=$EDITOR
export P4DIFF=p4merge
export P4MERGE=p4merge
export P4IGNORE="${ws}/.p4ignore"
export ws=${P4ROOT}/$P4CLIENT;

alias p4v='p4v &disown;'

# Sync file and print date
LogFolder=~/Logs
if [ ! -d $LogFolder ]; then
  mkdir $LogFolder;
fi

mk()
{
  if [ `pwd` == "${ws}/devel" ]; then
    read -p "Are you sure that's what you want? (y/n): " resp
    if [ $resp != "y" ]; then
      return
    fi
  fi
  make -j6 2>&1 | tee $LogFolder/make.txt;
}

p4s()
{
  syncFile=$LogFolder/sync.txt
  date >> ${syncFile}
  p4 sync 2>&1 | tee -a ${syncFile}
  echo "" >> ${syncFile}
}

# Diffs the files in the specified change list
pdiff()
{
  readList="default"
  if [ $# -ne 0 ]; then
    readList="$@"
  fi
  p4 opened -c "${readList}" | awk 'BEGIN { FS = "#" } // \
    { print "p4 diff " $1 }' | csh
}
p4e() { p4 open ${@: -1}; e ${@: -1}; }

# ----------------------------
# 8 Shortcuts
# ----------------------------
vc() { ~/verm.sh; }
alias did="vim +'normal Go' +'r!date' ~/did.txt"
alias tmtdel='ui deliveryAutomationWidget'
alias plugins='devel && cd QtDisplayPlugins'
alias restartvnc='vncserver -kill :1 && vncserver'
wk() { cd /accuray/wkstn/${@: -1}; }
dataf() { cd /accuray/datafiles/${@: -1}; }
ws() { cd $ws/${@: -1}; }
atk() { cd ${ws}/atk/${@: -1}; }
image() { cd ${ws}/devel/ImageView/${@: -1}; }
tmt() { cd ${ws}/devel/tmt/${@: -1}; }
#test() { cd ${ws}/devel/tmt/TmtTest/CTPhaseUITest/${@: -1}; }
test() { cd ${ws}/devel/tmt/TmtTest/RightWidgetScreenTest/${@: -1}; }
mm() { pushd ${ws}/devel/tmt/TmtTest/TmtModelManipulator/; r; popd;}
cui() { cd ${ws}/devel/tmt/Ui/ctwidget${@: -1}; }
ui() { cd ${ws}/devel/tmt/Ui/${@: -1}; }
cbct() { cd ${ws}/devel/cbct_app/Ui/${@: -1}; }
devel() { cd ${ws}/devel/${@: -1}; }
ver() { cd ${ws}/devel/tools/versionCheck/${@: -1}; }

sws() { ~/Tools/perforce/sws.sh ${@} && . ~/.bashrc; }

if [ -f ~/.bashTools.sh ]; then
  source ~/.bashTools.sh
fi
