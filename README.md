## Fulfillment Integration Tests
This repository contains a workflow that runs an isolated [integration-environment](https://github.com/get-fabric/integration-environment) and calls a test runner in order to verify sanity flow is working.
The integration environments are deployed as a [vclusters](https://www.vcluster.com/) named `integration-tests-1`, `integration-tests-2` and so on under [fabric-test integration cluster](https://console.cloud.google.com/kubernetes/clusters/details/us-east4/integration/details?orgonly=true&project=fabric-global-test&supportedpurview=organizationId)

### Usage
Every participating service should be added to the [integration-environment](https://github.com/get-fabric/integration-environment) repository. Then, in order to run the test you just run the [integration-test](https://github.com/get-fabric/fulfillment-integration-tests/blob/main/.github/workflows/integration-test.yaml) workflow

1. Make sure the service is [added](https://github.com/get-fabric/fulfillment-integration-tests#adding-services) to the integration environmen repository.

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

### Adding New Integration Environments
1. Follow the guide in [integration-environment](https://github.com/get-fabric/integration-environment) in order to create a new vcluster. Make sure you are naming the cluster correctly (i.e if there's a integration-tests-1 then you should add integration-tests-2)

2. Define a self hosted GitHub runner that will run only on this vcluster

## FAQ
**Question:** My test run failed, how to a understand why?

**Answer:**
If a test run failed, look for the `traceId` of the integration test runner (see [this run](https://github.com/get-fabric/insert-totes/runs/5786078519?check_suite_focus=true#step:14:19) for an example)
Once you have your traceId you can use it in [LogDNA](c4c0974e-0d75-4ba8-9d69-25d42b13f22f) for further research
Notice that also successfull runs will have traceId
