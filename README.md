# e

Shell helper function to handle multiple environment setups.

## Setup

Add [this function](e-function.sh) to your profile, e.g., `.bashrc` or `.zshrc`.

### Environment files

Organize your project folder structure as you see fit. Create any number of folders named `.local` anywhere you like, and within it, create environment files with the `*.env` extension.

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
export CF_URL='https://api.cloud.pcftest.com'
```

## Usage

With the function loaded and the environment files in the right place, one can use the function to load any number of environments. Any environment file found traversing the folder structure up to the root folder will be applicable.

Following the example above, one can use:

```shell
e cf cicd
```

This command will load all environment variables from `.local/cf.env` and `.local/cicd.env`. You can use any sequence of environment "keys," each processed in sequence.

It is worth noting that the `.local/cf.env` example will prompt the user for some credentials, which will be stored in the environment.

### Environment search

This function can be used from any folder. It will traverse the folders up to the root folder, searching for environmental files with the pattern `.local/*.env`.

If an environment file cannot be found, this message will be shown:

```
Environment not found: .local/unknown.env
```

### Clean-up

Previously set environment variables are erased before the environment files are loaded. The environment files load always keeps track of what is set, which can later be undone.

This way, one can easily clean any environment loaded using just:

```shell
e
```

### Security

As a safeguard, If any environment file has _**g**roup_ or _**o**thers_ _**w**rite-permission_, the file is rejected, showing this message:

```
Security risk (-rw-----w-): .local/unsafe.env
```

Use command like this to set minimal permission to environment files:

```shell
chmod u=rw,go= .local/myfile.env
```

**Attention: never store sensible data in your environment files.**

## Final notes

Feel free to use, adapt, improve, and share this code.
