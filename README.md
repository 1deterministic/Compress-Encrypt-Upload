# Compress-Encrypt-Upload
## Intro
**[Compress-Encrypt-Upload](#)** is a collection of scripts that I use to, well, compress, encrypt and upload a backup of my files to the cloud. You can run it manually or setup a systemd timer to do it automatically once per week with the included timer.

## Requirements
* tar
* gpg **with a working id**
* rclone **with a working remote**
* systemd

## Installation
Just run `./install.sh`. This will do the following
* copy all script files to the correct places
* install and activate a systemd script and a corresponding timer to run it once per week
* allow your user to run services even when not logged in

Similarly, run `./uninstall.sh` to undo everything

## Configuration
The config file is located at `$HOME/.config/ceu/config` and you need to customize it before using. The values you must set are:
* `gpgid` is your gpg id email
* `source` is the source folder
* `target` is the target file (after compressed and encrypted)
* `exclude` is an array of exclude parameters for tar, patterns you don't want to be included in the target file
* `remote` is the rclone remote and file location to upload to

## Running
The default install script will schedule a service to run every week (starts on the first Monday after installing, at midnight). It will sleep for 15 minutes to prevent competing for resources when booting up the machine and then run `compress`, `encrypt` and `upload`, using `&&` to stop everything if any of these commands fail. This will create a `target.tar.gz` compressed (unencrypted) file and a `target` encrypted file that will be uploaded to `remote`.

The same results can be achieved by running `compress && encrypt && upload` in the terminal. You can also run any of these commands alone if desired, just make sure that's what you want to do.

It is also included a combined `compress-and-encrypt` script that does the same as `compress && encrypt` but only outputs one file (so no `target.tar.gz`, only `target`), reducing the amount of storage used by the backups to basically half. **It is not used by default**, to use it you must edit `$HOME/.config/systemd/user/ceu.service` and edit the `ExecStart` parameter, commenting the current one and uncommenting the alternative one (right below) so that it looks like this:
```
# ExecStart=/usr/bin/bash -c 'sleep 900 && compress && encrypt && upload'

ExecStart=/usr/bin/bash -c 'sleep 900 && compress-and-encrypt && upload'
```
Then run `systemctl --user daemon-reload` and remove `target.tar.gz` if you want.

As the timer will only run the next Monday at midnight, you can also force the service to start immediately if you want with `systemctl --user start ceu.service`. I would not recommend this for testing purposes, manually running the scripts individually will skip the 15 minutes the service waits and also show you all command outputs in the terminal

## [1deterministic](https://github.com/1deterministic), 2020