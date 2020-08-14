# Imagem para resolução de problemas

## Ferramentas

- iproute2
- rsync
- vim
- python3
- go
- py3-pip
- bash
- sudo
- openssh
- bind-tools
- iputils
- busybox-extras
- less
- git

## Documentação

[General Container Image Guidelines](https://docs.openshift.com/container-platform/3.11/creating_images/guidelines.html)

[Build Inputs](https://docs.openshift.com/container-platform/3.11/dev_guide/builds/build_inputs.html#dev-guide-build-inputs)

[Build Output](https://docs.openshift.com/container-platform/3.11/dev_guide/builds/build_output.html)

[Builds and Image Streams](https://docs.openshift.com/container-platform/3.11/architecture/core_concepts/builds_and_image_streams.html)

[Creating a Source-to-Image build pipeline in OKD](https://opensource.com/article/19/5/creating-source-image-build-pipeline-okd)

## Pipeline

Exemplo: globo-ads-finance-contingency-api

## Comandos

oc start-build troubleshot --follow

oc rollout latest dc/troubleshot

## Alias Para o Shell

alias troubleshot='oc rsh $(oc get pods --field-selector status.phase=Running -l deploymentconfig=troubleshot -n sandbox-modolo --no-headers -o custom-columns=Name:.metadata.name)'
