#!/usr/bin/env bash

set -u

function runSam(){
    exit_code="0"
    echo "Run sam ${INPUT_SAM_COMMAND}"
    if [ "${INPUT_SAM_COMMAND}" == "package" ]; then
	if [[ -z "${INPUT_S3_BUCKET}" ]]; then
	    echo "The sam_command 'package' requires the s3_prefix"
	    exit 1
	else
	    if  [[ ! -z "${INPUT_S3_PREFIX}" ]]; then
		sam package --s3-bucket "${INPUT_S3_BUCKET}" --s3-prefix "${INPUT_S3_PREFIX}" --output-template-file packaged.yaml
	    else
		sam package --s3-bucket "${INPUT_S3_BUCKET}" --output-template-file packaged.yaml
	    fi
	fi
    elif [ "${INPUT_SAM_COMMAND}" == "deploy" ]; then
	if [[ -z "${INPUT_STACK_NAME}" ]]; then
	    echo "The sam_command 'deploy' requires a stack_name"
	    exit 1
	elif [[ ! -z "${INPUT_PARAMETER_OVERRIDES}" ]]; then
	    if [[ -z "${INPUT_CAPABILITIES}" ]]; then
		sam deploy --stack-name "${INPUT_STACK_NAME}" --parameter-overrides "${INPUT_PARAMETER_OVERRIDES}" --template packaged.yaml
	    else
		sam deploy --stack-name "${INPUT_STACK_NAME}" --parameter-overrides "${INPUT_PARAMETER_OVERRIDES}" --capabilities $INPUT_CAPABILITIES --template packaged.yaml
	    fi
	else
	    sam deploy --stack-name "${INPUT_STACK_NAME}"--template packaged.yaml
	fi
    else
	sam ${INPUT_SAM_COMMAND}
    fi

    exit $?
}

function main(){
    if [ "${INPUT_SAM_COMMAND}" == "" ]; then
	echo "Input sam_subcommand cannot be empty"
	exit 1
    fi
    runSam
}

main
