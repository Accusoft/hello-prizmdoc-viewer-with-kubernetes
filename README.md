# Hello PrizmDoc Viewer with Kubernetes

This example provides manifest files that allow you to get a PrizmDoc Viewer cluster up and running in Kubernetes.

## Pre-requisites

1. Kubernetes cluster where PrizmDoc Viewer application will be deployed. Also see [Supported Kubernetes Versions].
2. Your [kubectl] tool should be configured to use your Kubernetes server. Your Kubernetes server provider may provide a tool to generate a [kubeconfig] file for this.
3. [Ingress controller] to manage external access to the services in the cluster. You can choose the ingress controller implementation that best fits your cluster, but you may start from installing [NGINX Ingress Controller] with [helm] package manager:
    ```sh
    $ helm repo add bitnami https://charts.bitnami.com/bitnami
    $ helm repo update
    $ helm upgrade nginx-ingress-controller \
    bitnami/nginx-ingress-controller \
    --install --wait --namespace kube-system \
    --set ingressClassResource.default=true \
    --set defaultBackend.enabled=false \
    --set watchIngressWithoutClass=true
    ```
4. [Dynamic Volume Provisioning] being enabled, or a manually created [Persistent Volume]. Usually cloud environments provide Dynamic Volume Provisioning.

## Deploying PrizmDoc Viewer

### 1. Customize your configuration

All manifest files can be found in the [prizmdoc-viewer-app](./prizmdoc-viewer-app) folder. See [Deployment to Kubernetes Guidance] documentation for informantion about resources used in the manifest files.

PrizmDoc Server is configured with `prizmdoc-server-config` in the [prizmdoc-server.yaml](prizmdoc-viewer-app/prizmdoc-server.yaml) manifest file. See the [Configure the PrizmDoc Server] for information about available options. At a minimum, for a production deployment, you will want to at least configure your license with `license.key` and `license.solutionName`. 

Additionally, if you want to integrate your PrizmDoc Server cluster with the [Accusoft PDF Viewer], you will need to enable ["v3" Viewing Packages API] in the `prizmdoc-server-config` and set your AWS credentials (env variables `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` and `AWS_REGION`). See [Integration with the Accusoft PDF Viewer] for configuration details.

_**NOTE:** this sample uses `ReadWriteOnce` access mode for `prizmdoc-application-services-data` Persistent Volume Claim, and it will only work on a single-node cluster. We recommend you to use S3 or Azure Blob for the PAS storage in a multiple nodes cluster, take a look at the [Configuring Storage] topic for further details._

### 2. Deploy PrizmDoc Viewer to Kubernetes

First, create a namespace for the PrizmDoc Viewer:
```sh
kubectl create ns prizmdoc
```

Then deploy all manifest files with:
```sh
kubectl apply --filename ./prizmdoc-viewer-app --namespace prizmdoc
```

You can review deployed resources with command:
```sh
kubectl get all --namespace prizmdoc
```

### 3. Check health

It may take a few minutes to pull all the container images and complete the deployment. But, once fully started, you can use the following HTTP requests to check application health:
* `GET http://<your-ingress-address>:<port>/prizmdoc-server/PCCIS/V1/Service/Current/Health` should return HTTP 200, indicating PrizmDoc Server is healthy (while starting, this request will return nothing or an error).
* `GET http://<your-ingress-address>:<port>/prizmdoc-application-services/health` should return HTTP 200, indicating PrizmDoc Application Services component is healthy.

Use external IP address and port of your Ingress controller service. The PrizmDoc Server API should be available at `/prizmdoc-server` route, the PAS API should be available at `/prizmdoc-application-services` route.

### 4. Run the Viewer Sample

Now you can run one of [Sample Applications] with your PrizmDoc Viewer deployed to Kubernetes. Follow Self-Hosted steps when configuring connection to the PrizmDoc Viewer.

## Product Documentation

* [Copyright Information]
* [PrizmDoc Viewer Overview]
* [PrizmDoc Kubernetes Guidance]


[kubectl]: https://kubernetes.io/docs/reference/kubectl/kubectl/
[kubeconfig]: https://kubernetes.io/docs/concepts/configuration/organize-cluster-access-kubeconfig/
[Dynamic Volume Provisioning]: https://kubernetes.io/docs/concepts/storage/dynamic-provisioning/
[Persistent Volume]: https://kubernetes.io/docs/concepts/storage/persistent-volumes/
[Ingress controller]: https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/
[NGINX Ingress Controller]: https://bitnami.com/stack/nginx-ingress-controller/helm
[helm]: https://helm.sh/
[Deployment to Kubernetes Guidance]: https://help.accusoft.com/PrizmDoc/latest/HTML/deployment-to-kubernetes-guidance.html
[Configure the PrizmDoc Server]: https://help.accusoft.com/PrizmDoc/latest/HTML/configure-the-prizmdoc-server.html
[Accusoft PDF Viewer]: https://www.accusoft.com/products/pdf-collection/accusoft-pdf-viewer/
[Integration with the Accusoft PDF Viewer]: https://help.accusoft.com/PrizmDoc/latest/HTML/integration-with-pdf-viewer.html
["v3" Viewing Packages API]: https://help.accusoft.com/PrizmDoc/latest/HTML/pre-convert-documents-for-pdf-viewer.html
[Sample Applications]: https://help.accusoft.com/PrizmDoc/latest/HTML/viewer-samples.html
[Configuring Storage]: https://help.accusoft.com/PrizmDoc/latest/HTML/pas-configuration.html#configuring-storage
[Copyright Information]: https://help.accusoft.com/PrizmDoc/latest/HTML/copyright-information.html
[PrizmDoc Viewer Overview]: https://help.accusoft.com/PrizmDoc/latest/HTML/prizmdoc-overview.html
[PrizmDoc Kubernetes Guidance]: https://help.accusoft.com/PrizmDoc/latest/HTML/kubernetes-overview.html
[Supported Kubernetes Versions]: https://help.accusoft.com/PrizmDoc/latest/HTML/supported-kubernetes.html
