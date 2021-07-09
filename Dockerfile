FROM alpine:3.14.0 AS BASE

ARG USER=nonroot
ARG RELEASE=0.8.15
ARG TERRAFORM_VERSION="0.13.6"
ARG OS_ARCH=linux_amd64
ENV HOME /home/$USER

RUN apk add --no-cache go git curl unzip gnupg perl-utils

RUN adduser -D $USER

WORKDIR $HOME

RUN git clone https://github.com/GoogleCloudPlatform/terraformer --branch $RELEASE
RUN cd terraformer && go mod download && go run build/main.go azure

RUN curl -Os https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_${OS_ARCH}.zip
RUN curl -Os https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_SHA256SUMS
RUN curl -s https://keybase.io/hashicorp/pgp_keys.asc | gpg --import
RUN curl -Os https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_SHA256SUMS.72D7468F.sig
RUN gpg --verify terraform_${TERRAFORM_VERSION}_SHA256SUMS.72D7468F.sig terraform_${TERRAFORM_VERSION}_SHA256SUMS
RUN shasum -a 256 -c terraform_${TERRAFORM_VERSION}_SHA256SUMS 2>&1 | grep "${TERRAFORM_VERSION}_${OS_ARCH}.zip:\sOK"
RUN unzip -o terraform_${TERRAFORM_VERSION}_${OS_ARCH}.zip -d /usr/local/bin

COPY versions.tf .
RUN terraform init

FROM alpine:3.14.0
ARG USER=nonroot
ARG OS_ARCH=linux_amd64
ENV HOME /home/$USER

COPY --from=BASE $HOME/terraformer/terraformer-azure /usr/local/bin/terraformer
COPY --from=BASE $HOME/.terraform/plugins/registry.terraform.io/hashicorp/azurerm/2.47.0/${OS_ARCH} $HOME/.terraform.d/plugins/${OS_ARCH}/
RUN chmod +x /usr/local/bin/terraformer
RUN adduser -D $USER
USER $USER
WORKDIR $HOME
ENTRYPOINT ["terraformer"]
CMD ["version"]