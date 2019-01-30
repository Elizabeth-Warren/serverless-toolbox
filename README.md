# serverless-toolbox 🛠

Serverless Toolbox is a project that provides a small utility layer over the [Serverless Framework](https://serverless.com/) to make local setup simpler and consistent between developer machines.

**NOTE**: This project requires [Docker](https://www.docker.com/) installed on your developer machine.

```sh
$ cp .env.example .env # Fill out the AWS credentials in the .env file
$ make build           
```

Feel free to store additional .env files for various AWS accounts, as they will be caught by the gitignore.

```
.env.development
.env.staging
.env.production
```

Any command that interacts with source code requires you to specify the project directory before the make command, eg:

```sh
$ SRC=~/dev/example-function make toolbox
$ root@...:/ sls       # Run the 'sls' command for the help prompt
```

Full CLI documentation can be found [here](https://serverless.com/framework/docs/providers/aws/cli-reference/).
