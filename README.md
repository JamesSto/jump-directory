# Jump Directory Tool

This tool was written to allow quick access to commonly used 
directories without any additional effort or memory on the part of the user.

It works by adding a wrapper on top of `cd` that records all directories you visit.
This means that `jd` won't be very useful until it's been installed and used for
a bit, but to mitigate that, on installation jump directory will look in your bash_history
and record any absolute filepaths it sees there.

Usage is very simple:

```
jd MyDirectory
```

This will move to MyDirectory no matter what the current working directory is. If there are multiple
MyDirectory's on the system, `jd` will move to the one that is most often visited.

If you'd like to be more specific, you can!

```
jd MyProject/src
```

Will move to MyProject/src, even if there are many `src` directories on the system and `MyProject/src`
is not the most visited.


## Setup

To setup, first clone the repository wherever you wish

```
git clone https://github.com/JamesSto/jump-directory.git
```
If you are on OSX, you will need to install the following brew packages:
```
brew install coreutils
brew install bash-completion
```

Then, run the setup.sh script. If you'd like to use a different bash login file than bashrc, you
can specify it as a command line argument. Note the the setup requires that repository stays in whatever absolute filepath it is first put in.

```
sudo ./setup/setup.sh
```

Finally, restart your session to complete the setup.

And you're done! Start navigating your filesystem as you normally would - the longer that `jd` is installed
on your system, the more useful to you it becomes.

## Contributing

Feel free to fork the repository and contribute! There are no particularly requirements for pull requests, but
try to keep good style and readable code in mind as much as possible.
