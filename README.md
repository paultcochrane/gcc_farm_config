Configurations used for smoke testing Perl on the GCC compile farm.  The
configuration for each relevant node in the farm is stored in a separate branch
of this repository.  The list of branches is currently as follows:

   * gcc10
   * gcc12
   * gcc14
   * gcc110

## Smoke testing setup

### ensure that `ssh` is set up to connect to GitHub

    $ ssh-keygen -t rsa -b 2048
    # copy key to GitHub

### make a `p5smoke` directory to contain the smoke-related information for Perl5

    $ mkdir $HOME/p5smoke

### clone the `gcc_farm_config` repo and link the relevant files:

    $ cd $HOME/p5smoke
    $ git clone git@github.com:paultcochrane/gcc_farm_config.git
    $ $HOME/p5smoke/gcc_farm_config/link_dotfiles.sh

### install `perlbrew` (http://perlbrew.pl)

    $ cd $HOME
    $ \curl -L http://install.perlbrew.pl | bash

### Log in again to get the new `perlbrew` goodness

    $ exit
    home-machine$ ssh gcc<nnn>

### install a recent `perl` version

    # e.g.
    $ perlbrew install perl-5.20.1
    ...
    $ perlbrew switch perl-5.20.1

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
    # - CC to me on fail
    # - enter a space for SMTP server option (i.e. local sendmail is used)
    # - use nice 10
    # - use verbose level 2
    # Remove the comment line in `smokecurrent.skiptests`

### make a branch for the relevant architecture/machine and check new config into branch

    $ cd $HOME/p5smoke/gcc_farm_config
    $ git co -b gcc<nnn>
    $ ./copy_config_files_to_git_branch.sh
    $ git ci -a -m "Adding configuration for gcc<nnn>"
    $ git push origin gcc<nnn>

### link the version-controlled config files back into the smoke dir

Now if the files are changed in the `smoke` dir, then we can keep track of
the changes.

    $ for file in perlcurrent.cfg perlcurrent.cfg.bak smokecurrent_config \
                  smokecurrent.patchup smokecurrent.sh smokecurrent.skiptests \
                  smokecurrent.usernote
      do
          ln -sf $HOME/p5smoke/gcc_farm_config/$file $HOME/p5smoke/smoke/$file
      done

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
