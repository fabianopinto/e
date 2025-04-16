# e

Shell helper function to handle multiple environment setups.

## Setup

Add [this function](e-function.sh) to your profile, e.g., `.bashrc` or `.zshrc`.

### Environment files

Organize your project folder structure as you see fit. Create any number of folders named `.local` anywhere you like,
and within it, create environment files with the `.env` extension.

Here are some examples of these environment files:

`~/.local/cf.env`

```shell
export CF_USERNAME='johndoe'
echo -n 'CF password: '
read -rs CF_PASSWORD
export CF_PASSWORD
echo
```

`~/projects/someproject/.local/cicd.env`

```shell
export NODE='cicd'
export AWS_REGION='eu-west-1'
export AWS_PROFILE='test'
export CF_URL='https://api.cloud.example.com'
```

Environment files need to have _**u**ser_ permissions to _**r**ead_ and _e**x**ecute_. Read the [Security](#Security)
section below for more information.

## Usage

With the function loaded and the environment files in the right place, one can use the function to load any number of
environments files. Any environment file found traversing the folder structure up to the root folder will be applicable.

Following the example above, one can use:

```shell
cd ~/projects/someproject
e cf cicd
```

This command will load all environment variables from `~/.local/cf.env` and `~/projects/someproject/.local/cicd.env`. You can use any sequence of
environment "keys," each processed in sequence.

It is worth noting that the `~/.local/cf.env` example will prompt the user for some credentials, which will be stored in
the environment.

### Options

| Option           | Description                      |
|------------------|----------------------------------|
| `-h` or `--help` | Show help message                |
| `-l` or `--list` | List all environment files found |
| `-d` or `--dump` | Dump the current environment     |

### Environment search

This function can be used from any folder. It will traverse the folders up to the root folder, searching for
environment files with the pattern `.local/*.env`.

If an environment file cannot be found, this message will be shown:

```
Environment not found: .local/unknown.env
```

Use the option `-l` or `--list` to show all environment files found and available.

### Clean-up

Previously set environment variables are erased before the environment files are loaded. The environment files load
always keeps track of what is set, which can later be undone.

This way, one can easily clean any environment loaded using just:

```shell
e
```

Use the option `-d` or `--dump` to list all environment variables and values set, if any.

### Security

As a safeguard, If an environment file has _**g**roup_ or _**o**thers_ _**w**rite-permission_, the file is rejected,
showing this message:

```
Security risk (-rwx----w-): .local/unsafe.env
```

Use the following command to set permissions to an environment file:

```shell
chmod u+rx,go-w .local/myfile.env
```

> This script uses `source` to load environment files, mainly setting environment variables. However, this can be risky
> if the environment files are not trusted. Always review the content of the environment files before trusting them.
>
> **Never store sensible information in your environment files.**

## Troubleshooting

### Missing GNU Core Utils

To traverse the folder structure and process environment files, the utilities `cut`, `sed`, and `sort` are utilized.
These require the GNU versions, which may necessitate installing
the [GNU core utilities](https://www.gnu.org/software/coreutils/).

On macOS, you can use [Homebrew](https://brew.sh/) to install the GNU Core Utils, and the GNU implementation of `sed`:

```shell
brew install coreutils gnu-sed
```

If you have installed the GNU core utilities using Homebrew, these commands will be available in your `PATH`.

If necessary, set the environment variables `CUT`, `SED`, and `SORT` to the paths of these utilities. Alternatively,
adjust the script by modifying the paths where these variables are set.

## Final notes

Feel free to use, adapt, improve, and share this code.
