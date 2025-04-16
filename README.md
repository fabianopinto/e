# e

Shell helper function to handle multiple environment setups.

## Setup

Add [this function](e-function.sh) to your profile, e.g., `.bashrc` or `.zshrc`.

### Environment files

Organize your project folder structure as you see fit. Create any number of folders named `.local` anywhere you like,
and within it, create environment files with the `.env` extension.

Here are some examples of these environment files:

`.local/cf.env`

```shell
export CF_USERNAME='johndoe'
echo -n 'CF password: '
read -rs CF_PASSWORD
export CF_PASSWORD
echo
```

`.local/cicd.env`

```shell
export NODE='cicd'
export AWS_REGION='eu-west-1'
export AWS_PROFILE='test'
export CF_URL='https://api.cloud.example.com'
```

Environment files need to have _**u**ser_ permissions to _**r**ead_ and _e**x**ecute_. Read the [Security](#Security)
section below for more information.

## Usage

With the function loaded and the environment files in the right place, you can use the function to load any number of
environment files. Any environment file found traversing the folder structure up to the root folder will be applied.

Following the example above, you can use:

```shell
e cf cicd
```

The function will load all environment variables from `.local/cf.env` and `.local/cicd.env`. You can use any sequence of
environment "keys," each processed in sequence.

It is worth noting that the `.local/cf.env` example will prompt the user for some credentials, which will be stored in
the environment.

### Options

| Option           | Description                      |
|------------------|----------------------------------|
| `-h` or `--help` | Show help message                |
| `-l` or `--list` | List all environment files found |
| `-d` or `--dump` | Dump the current environment     |

### Environment search

The function can be used from any folder. It will traverse the folders up to the root folder, searching for
environment files with the pattern `.local/*.env`.

If an environment file cannot be found, this message will be shown:

```
Environment not found: .local/unknown.env
```

Use the option `-l` or `--list` to show all environment files found and available.

### Clean-up

Previously set environment variables are erased before the environment files are loaded. The environment files load
always keeps track of what is set, which can be undone later.

This way, you can easily clean any loaded environment using:

```shell
e
```

Use the `-d` or `--dump` option to list all environment variables and their values, if any.

### Security

As a safeguard, If an environment file has _**g**roup_ or _**o**thers_ _**w**rite-permission_, it will be rejected,
showing this message:

```
Security risk (-rwx----w-): .local/unsafe.env
```

To set the correct permissions for an environment file, use the following command:

```shell
chmod u+rx,go-w .local/myfile.env
```

> This script uses `source` to load environment files, mainly setting environment variables. However, this can be risky
> if the environment files are not trusted. Always review the content of environment files before using them.
>
> **Never store sensible information in your environment files.**

## Final notes

Feel free to use, adapt, enhance, and share this code.
