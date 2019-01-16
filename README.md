# serverless-toolbox 🛠

Serverless Toolbox is a project that provides a small utility layer over [AWS SAM](https://aws.amazon.com/serverless/sam/) to make local setup simpler.

## Local CLI

The serverless-toolbox local cli is a Docker container that wraps over AWS Sam to simplify the setup required for local development of serverless functions. You still get full access to the aws sam cli.

```sh
$ cp .env.example .env # Fill out the AWS credentials in the .env file
$ make build           # The first time you do this it will take a few minutes
```

Any command that interacts with source code requires you to specify the project directory before the make command, eg:

```sh
$ SRC=~/dev/example-function make toolbox
...
$ root@...:/ sam       # Run the 'sam' command for the help prompt
```

Full AWS SAM CLI documentation can be found [here](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-command-reference.html).

**WARNING**: The `sam local start-api` command is not recommended. Use unit tests locally and integration tests on development stacks.

### Local CLI Tips

The serverless-toolbox CLI container is bult with a Python image, but also includes `node` and `npm` for JS projects. Feel free to run `npm install|test (etc)` within the toolbox on your project using the same Node version as the Lambda environment.

Lastly as a suggestion, the toolbox gitignore file will cover any `.env.*` file except for the example template, so feel free to save your various account credentials in standalone env files that you copy into the main `.env` as needed.

### Bootstrap new serverless project

To bootstrap a new serverless project, you can take advantage of the `new-api` command.

```sh
$ mkdir ~/dev/ew/my-cool-function
$ SRC=~/dev/ew/my-cool-function make toolbox
$ root@...:/ new-api
```
