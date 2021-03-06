See the [troubleshooting](TROUBLESHOOT.md) section for dealing with failed test runs.

<br/>

## Fulfillment Integration Tests
This repository contains a workflow that runs an isolated [integration-environment](https://github.com/get-fabric/integration-environment) and calls a test runner in order to verify sanity flow is working.
The integration environments are deployed as a [vclusters](https://www.vcluster.com/) named `integration-tests-1`, `integration-tests-2` and so on under [fabric-test integration cluster](https://console.cloud.google.com/kubernetes/clusters/details/us-east4/integration/details?orgonly=true&project=fabric-global-test&supportedpurview=organizationId)

### Usage
Every participating service should be added to the [integration-environment](https://github.com/get-fabric/integration-environment) repository. Then, in order to run the test you just run the [integration-test](https://github.com/get-fabric/fulfillment-integration-tests/blob/main/.github/workflows/integration-test.yaml) workflow

1. Make sure the service is [added to the integration environmen repository](https://github.com/get-fabric/update-integration-environment).

2. Copy this `integration-test` step into your service `integration-test.yaml` workflow:
```
  integration-test:
    uses: get-fabric/fulfillment-integration-tests-github-action/.github/workflows/integration-test.yaml@main
    with:
      service_name: ${{ github.event.repository.name }}
      branch: ${{ github.branch }}
    secrets:
      git_token: ${{ secrets.ORG_GITHUB_ADMIN_TOKEN }}
      gcr_token: ${{ secrets.ORG_GCR_ADMIN_JSON }}
      gcloud_token: ${{ secrets.INTEGRATION_TESTS_SERVICE_ACCOUNT_KEY }}
      slack_token: ${{ secrets.FULFILLMENT_INTEGRATION_TESTS_SLACK_BOT_TOKEN }}
```

## FAQ

**Question:** How do I login to the integration tests cluster?

**Answer:**
The integration tests are running in [fabric-test integration cluster](https://console.cloud.google.com/kubernetes/clusters/details/us-east4/integration/details?orgonly=true&project=fabric-global-test&supportedpurview=organizationId). In this cluster you will find vclusters named `integration-test-1`, `integration-test-2` etc.
For instancem, if you wantto connect to a `integration-tests-1` vcluster from you machine do:
```
vcluster connect vcluster-1 --namespace integration-tests-1 & 
```
Now you can do any `kubectl` operation with the vcluster, i.e:
```
kubectl get pods -A
```
Once you are done cleanup vcluter connection by running:
```
kill $(jobs -p)
export KUBECONFIG=
```

## Adding New Integration Environments
1. Follow the guide in [integration-environment](https://github.com/get-fabric/integration-environment) in order to create a new vcluster. Make sure you are naming the cluster correctly (i.e if there's a integration-tests-1 then you should add integration-tests-2)

2. Define a self hosted GitHub runner that will run only on this vcluster
