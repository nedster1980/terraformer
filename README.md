# Terraformer
Creates an Alpine based Docker image that has Terraformer (reverse terraform) as the entrypoint.

Image only works with the Azure cloud provider (image was generated with `go run build/main.go azure`).

Image uses the versions.tf file to download the desired azurerm version.

Image runs as a non-root user called nonroot and uses specific image tags.

In the near-future the image will be based on "Distroless".

## Requirements

Ensure that the following environment vars are passed into the Docker image:

- ARM_CLIENT_ID
- ARM_CLIENT_SECRET
- ARM_SUBSCRIPTION_ID
- ARM_TENANT_ID

Only tested with version **0.13.x** of Terraform.

## Usage

### Display Terraformer version number
`docker run -it nedster1980/terraformer-azure:release-v0.1.0 "import azure list" -e ARM_CLIENT_ID=<ARM_CLIENT_ID> -e ARM_CLIENT_SECRET=<ARM_CLIENT_SECRET> -e ARM_SUBSCRIPTION_ID=<ARM_SUBSCRIPTION_ID> -e ARM_TENANT_ID=<ARM_TENANT_ID>`

### Display commands
`docker run -it nedster1980/terraformer-azure:release-v0.1.0 "import azure list" -e ARM_CLIENT_ID=<ARM_CLIENT_ID> -e ARM_CLIENT_SECRET=<ARM_CLIENT_SECRET> -e ARM_SUBSCRIPTION_ID=<ARM_SUBSCRIPTION_ID> -e ARM_TENANT_ID=<ARM_TENANT_ID> --help`

### Display import command help
`docker run -it nedster1980/terraformer-azure:release-v0.1.0 "import azure list" -e ARM_CLIENT_ID=<ARM_CLIENT_ID> -e ARM_CLIENT_SECRET=<ARM_CLIENT_SECRET> -e ARM_SUBSCRIPTION_ID=<ARM_SUBSCRIPTION_ID> -e ARM_TENANT_ID=<ARM_TENANT_ID> import --help`

### Display supported resources for azurerm provider
`docker run -it nedster1980/terraformer-azure:release-v0.1.0 "import azure list" -e ARM_CLIENT_ID=<ARM_CLIENT_ID> -e ARM_CLIENT_SECRET=<ARM_CLIENT_SECRET> -e ARM_SUBSCRIPTION_ID=<ARM_SUBSCRIPTION_ID> -e ARM_TENANT_ID=<ARM_TENANT_ID> import azure list`

### Get all resoutces for a particular resourcegroup, this places all the generated code in the mounted directory
`docker run -e ARM_CLIENT_ID=<ARM_CLIENT_ID> -e ARM_CLIENT_SECRET=<ARM_CLIENT_SECRET> -e ARM_SUBSCRIPTION_ID=<ARM_SUBSCRIPTION_ID> -e ARM_TENANT_ID=<ARM_TENANT_ID> -v <BIND-MOUNT>:/home/nonroot/generated nedster1980/terraformer-azure:release-v0.1.0 import azure -R <resource-groupname> -r="*"`









