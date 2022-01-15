# Project initialization

Setting up a project involves several steps such as making sure all the tools you use are installed, setting up your username and email in git, etc.

## Prerequisites

Before we get started, we need to make sure we have all the required tools installed. Below is a list of the tools that will be used.

- [aws-cli](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) - The AWS Command Line Interface (CLI) is a unified tool to manage your AWS services.
- [docker](https://docs.docker.com/get-docker/) - Docker is a set of platform as a service products that use OS-level virtualization to deliver software in packages called containers.
- [lerna](https://github.com/lerna/lerna#getting-started) - Lerna is a tool that optimizes the workflow around managing multi-package repositories with git and npm.
- [terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) - Terraform is an open-source infrastructure as code software tool that provides a consistent CLI workflow to manage hundreds of cloud services.

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

## Global packages

Global packages are those that we intend to reuse throughout the project with the same configuration. Now is a good time to add packages that help you format your code (e.g. [prettier](https://www.npmjs.com/package/prettier)), help you manage package.json files (e.g. [syncpack](https://www.npmjs.com/package/syncpack)) or take care of commit quality (e.g. [commitlint](https://www.npmjs.com/package/@commitlint/cli)).

## Create packages

Now it's time to create the applications. I'm going to create an SPA application in React and a Node.js server in Nest.js but technology does not really matter here. If you want, you can just as well create an SPA application using Angular or Vue, and the Node.js server can be replaced by a server written in Express.js, Koa.js, etc.

To create applications, go to the `packages` folder and in it, run the commands given below.

I will create an app in React using [create-react-app](https://create-react-app.dev/). I'm going to use TypeScript template.

```shell
create-react-app my-app --template typescript
```

I will create the application in Nest.js using [nest cli](https://docs.nestjs.com/cli/overview).

```shell
nest new api
```

NOTE: The `create-react-app` and `nest` packages must be installed locally to create projects. Alternatively, we can also use the `npx` utility.

## Write code

The final step in initializing the project is to write code that will allow us to deploy applications that more closely resemble production applications. Typical web applications communicate through REST APIs with backend applications. The data in the backend application is validated, and then the business logic is executed and written to the database.

In my case, I will create an app that will allow me to save posts that will be displayed in the browser. I will be using `docker` and `docker-compose` during application development.
