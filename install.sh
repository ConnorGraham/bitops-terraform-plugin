#!/usr/bin/env bash

export TERRAFORM_VERSIONS=$(cat terraform-versions.yaml | shyaml get-values terraform.versions)

while IFS='' read -r version; do
    TERRAFORM_DOWNLOAD_URL="https://releases.hashicorp.com/terraform/${version}/terraform_${version}_linux_amd64.zip"
    echo ${TERRAFORM_DOWNLOAD_URL}
    curl -LO ${TERRAFORM_DOWNLOAD_URL} && unzip terraform_${version}_linux_amd64.zip -d ./
    mv terraform /usr/local/bin/terraform-${version}
    chmod +x /usr/local/bin/terraform-${version}
done <<< "$TERRAFORM_VERSIONS"