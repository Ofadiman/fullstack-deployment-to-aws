# Project initialization

Setting up a project involves several steps such as making sure all the tools you use are installed, setting up your username and email in git, etc.

## Initialize lerna

The first step will be to initialize a new project that uses monorepo to manage packages.

```shell
# Create a project folder in the selected location.
mkdir project-name
# Navigate to the project folder.
cd project-name
# Initialize new lerna project.
npx lerna init
# Install dependencies.
npm install
```

After executing the above commands, a new project will be created that contains the basic configuration.

## Configure git

The next step will be to verify that we have a properly configured `username` and `email` in the [git](https://git-scm.com/) version control system.

Run the `git config -l` command and make sure git is configured correctly. If you 

```shell
# Add the username that git will use.
git config --local user.name "your_name"
# Add the email address that git will use. 
git config --local user.email "your_email@example.com"
```

## Resources

- [Official lerna documentation on GitHub.](https://github.com/lerna/lerna)