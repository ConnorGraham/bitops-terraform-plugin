#!/usr/bin/env bash
set -e

bash $PLUGIN_DIR/scripts/validate_env.sh

# Copy Default Terraform values
echo "Copying defaults"
$PLUGIN_DIR/scripts/copy_defaults.sh "$ENVIRONMENT_DIR"

echo "cd Terraform Root: $ENVIRONMENT_DIR"
cd $ENVIRONMENT_DIR

# Set terraform version
echo "Using terraform version $TERRAFORM_VERSION"
ln -s /usr/local/bin/terraform-$TERRAFORM_VERSION /usr/local/bin/terraform

# always init first
echo "Running terraform init"
terraform init -input=false

if [ -n "$TERRAFORM_WORKSPACE" ]; then
  echo "Running Terraform Workspace"
  bash $PLUGIN_DIR/scripts/terraform_workspace.sh $TERRAFORM_WORKSPACE
fi

if [ "${TERRAFORM_COMMAND}" == "plan" ]; then
  echo "Running Terraform Plan"
  bash $PLUGIN_DIR/scripts/terraform_plan.sh "$CLI_OPTIONS"
fi

if [ "${TERRAFORM_COMMAND}" == "apply" ] || [ "${TERRAFORM_APPLY}" == "true" ]; then
  # always plan first
  echo "Running Terraform Plan"
  bash $PLUGIN_DIR/scripts/terraform_plan.sh "$CLI_OPTIONS"

  echo "Running Terraform Apply"
  bash $PLUGIN_DIR/scripts/terraform_apply.sh "$CLI_OPTIONS"
fi

if [ "${TERRAFORM_COMMAND}" == "destroy" ] || [ "${TERRAFORM_DESTROY}" == "true" ]; then
  # always plan first
  echo "Running Terraform Plan"
  bash $PLUGIN_DIR/scripts/terraform_plan.sh "-destroy $CLI_OPTIONS"
  
  echo "Running Terraform Destroy"
  bash $PLUGIN_DIR/scripts/terraform_destroy.sh "$CLI_OPTIONS"
fi



