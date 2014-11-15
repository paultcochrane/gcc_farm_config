Configurations used for smoke testing Perl on the GCC compile farm.  The
configuration for each relevant node in the farm is stored in a separate branch
of this repository.  The list of branches is currently as follows:

   * gcc10
   * gcc12

## Smoke testing setup

### ensure that `ssh` is set up to connect to GitHub

    $ ssh-keygen -t rsa -b 2048
    # copy key to GitHub

### clone the `dotfiles` repo and link the relevant files:

    $ git clone git@github.com:paultcochrane/dotfiles.git
    $ ln -s $HOME/dotfiles/.gitconfig $HOME/.gitconfig
    $ ln -s $HOME/dotfiles/.bashrc $HOME/.bashrc
    $ ln -s $HOME/dotfiles/.vimrc $HOME/.vimrc

### install `perlbrew`

    $ \curl -L http://install.perlbrew.pl | bash

### install a recent `perl` version

    # e.g.
    $ perlbrew install perl-5.20.1
    ...
    $ perlbrew use perl-5.20.1

### make a `p5smoke` directory to contain the smoke-related information for Perl5

    $ mkdir $HOME/p5smoke

### clone the `Test::Smoke` repo, and change into the `ptc_master` branch

    $ cd $HOME/p5smoke
    $ git clone git@github.com:paultcochrane/Test-Smoke.git
    $ cd Test-Smoke
    # git 1.5.x
    $ git fetch origin ptc_master:ptc_master  # fetches relevant branch
    # git 1.7.x
    $ git fetch origin ptc_master  # fetches relevant branch
    $ git co ptc_master

### install `Test::Smoke`

    $ cd $HOME/p5smoke/Test-Smoke
    $ perl Makefile.PL
    $ make install   # will create a "smoke" dir in parent dir

### configure the smoke-tester

    $ cd $HOME/p5smoke/smoke
    $ perl configsmoke.pl
    # follow prompts
    # - use blead branch
    # - use rsync as the syncer
    # - mail results to mailing list; ensure From field is entered
    # - enter a space for SMTP server option (i.e. local sendmail is used)
    # - use nice 10
    # - use verbose level 2

### clone the `gcc_farm_config` repo

    $ cd $HOME/p5smoke
    $ git clone git@github.com:paultcochrane/gcc_farm_config.git

### make a branch for the relevant architecture/machine and check new config into branch

    $ git co -b gcc<nnn>
    $ for file in perlcurrent.cfg perlcurrent.cfg.bak smokecurrent_config \
                  smokecurrent.patchup smokecurrent.sh smokecurrent.skiptests \
                  smokecurrent.usernote
      do
          cp ../smoke/$file .
      done
    $ git ci -a -m "Adding configuration for gcc<nnn>"
    $ git push origin gcc<nnn>

## Running the smoker by hand

    $ ssh gcc<nnn>
    $ screen -list
    # if there is no screen process running
    $ screen
    # if there is a screen process running
    $ screen -dr <process_id>
    $ cd $HOME/p5smoke/smoke
    $ $HOME/p5smoke/smoke/smokecurrent.sh
    $ <Ctrl-A> c   # start a new screen window
    $ tail -f $HOME/p5smoke/smoke/smokecurrent.log
