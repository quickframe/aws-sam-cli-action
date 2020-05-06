# aws sam cli action

A github action that supports some (but not all) [AWS SAM CLI]((https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/what-is-sam.html)) commands.

It supports most importantly `build`, `package`, and `deploy`

## Example usage

``` yaml
name: Deploy to Amazon

jobs:
  deploy:
    name: Deploy
    runs-on: ubuntu-latest

    steps:
    - name: Checkout
      uses: actions/checkout@v2

    - name: Configure AWS credentials
      uses: aws-actions/configure-aws-credentials@v1
      with:
        aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
        aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        aws-region: us-east-1


    - name: SAM build
      uses: quickframe/aws-sam-action@v1
      with:
        sam_command: build

    - name: SAM package
      uses: quickframe/aws-sam-action@v1
      with:
        sam_command: package
        s3_bucket: lambdas
        s3_prefix: my-cool-lambda/dev

    - name: SAM deploy
      uses: quickframe/aws-sam-action@feature/improve
      with:
        sam_command: deploy
        stack_name: my-cool-lambda
        capabilities: CAPABILITY_IAM CAPABILITY_NAMED_IAM
        parameter_overrides: StageName=dev

```
