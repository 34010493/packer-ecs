.PHONY: build
.ONESHELL:

build:
	@ $(if $(AWS_PROFILE),$(call assume_role))
	packer build packer.json

# Dynamically assumes role and injects credentials into environment
define assume_role
  export AWS_DEFAULT_REGION=$$(aws --profile 4219 configure get region)
  eval $$(aws --profile 4219 sts get-session-token \
    --query "Credentials.[ \
        [join('=',['export AWS_ACCESS_KEY_ID',AccessKeyId])], \
        [join('=',['export AWS_SECRET_ACCESS_KEY',SecretAccessKey])], \
        [join('=',['export AWS_SESSION_TOKEN',SessionToken])] \
      ]" \
    --output text)
endef