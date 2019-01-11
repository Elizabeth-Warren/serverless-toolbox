# serverless-toolbox

Serverless Toolbox is a project that provides a small utility layer over [AWS SAM](https://aws.amazon.com/serverless/sam/) to improve developer workflow. Fork of [Apex/actions/sam](https://github.com/apex/actions/tree/master/aws/sam) :sparkles:.

## Usage Requirements

All projects relying on the serverless toolbox must be defined with AWS SAM templates. An easy way to bootstrap a new project would be the following,

```sh
$ mkdir ~/dev/ew/my-cool-function
$ SRC=~/dev/ew/my-cool-function make sam
$ root@...:/ sam init -r nodejs8.10 -o ../tmp -n template && mv -v /tmp/template/* /app/
```

You can find the list of Lambda runtimes [here](https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtimes.html) if you're not building a NodeJS service. Full `init` command documentation can be found [here](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/sam-cli-command-reference-sam-init.html).

## Local CLI

The serverless-toolbox local cli is a Docker container that wraps over AWS Sam to simplify the setup required for local development of serverless functions. You still get full access to the aws sam cli.

```sh
$ cp .env.example .env # Fill out the AWS credentials in the .env file
$ make build           # The first time you do this it will take a few minutes
```

Any command that interacts with source code requires you to specify the project directory before the make command, eg:

```sh
$ SRC=~/dev/example-function make sam
...
$ root@...:/ sam       # Run the 'sam' command for the help prompt
```

Full CLI documentation can be found [here](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-command-reference.html).

When using the `sam local start-api` command, make sure to set the host parameter to `0.0.0.0` so your sibling container is properly exposed to the host.

```sh
$ root@...:/ sam local start-api --host 0.0.0.0
```

The serverless-toolbox CLI container is bult with a Python image, but also includes `node` and `npm` for JS projects.

Lastly as a suggestion, the toolbox gitignore file will cover any `.env.*` file except for the example template, so feel free to save your various account credentials in standalone env files that you copy into the main `.env` as needed.

## Github Actions

The serverless-toolbox github actions provide a clear workflow for testing and deploying your serverless functions. To get started, create a Github workflow file in your project folder.

```sh
$ mkdir .github
$ touch .github/main.workflow
```

Then add the following to your workflow template,

```
workflow "Deployment" {
  on = "push"
  resolves = [
    "Build Notification",
    "Deploy Notification",
  ]
}

action "Build" {
  uses = "apex/actions/aws/sam@master"
  secrets = ["AWS_SECRET_ACCESS_KEY", "AWS_ACCESS_KEY_ID"]
  args = "package --template-file template.yml --output-template-file out.yml --s3-bucket my-bucket-name"
}

action "Build Notification" {
  needs = "Build"
  uses = "apex/actions/slack@master"
  secrets = ["SLACK_WEBHOOK_URL"]
}

action "Deploy" {
  uses = "apex/actions/aws/sam@master"
  needs = ["Build"]
  secrets = ["AWS_ACCESS_KEY_ID", "AWS_SECRET_ACCESS_KEY"]
  args = "deploy --stack-name myapp --capabilities CAPABILITY_IAM --template-file out.yml"
  env = {
    AWS_DEFAULT_REGION = "us-west-2"
  }
}

action "Deploy Notification" {
  uses = "apex/actions/slack@master"
  needs = ["Deploy"]
  secrets = ["SLACK_WEBHOOK_URL"]
}
```

This workflow requires the following secrets configured,

- `AWS_ACCESS_KEY_ID` - Required.
- `AWS_SECRET_ACCESS_KEY` - Required.
- `SLACK_WEBHOOK_URL` - Optional.


Ideal workflow

1. Create PR
2. [Test process]
 - slack notification
 - pr check
3. Merge PR
4. Function built and deployed to AWS
 - slack notification
 - apply label to PR?
5. "api gateway staging" points at "latest" tag
6. write a comment in the PR to promote it to production (or revert)
 - slack notification
 - apply label to PR?
