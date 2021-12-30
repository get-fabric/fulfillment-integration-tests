## Fulfillment Integration Tests
This repository contains a workflow that runs an isolated [fulfillment integration](https://github.com/get-fabric/fulfillment-integration) environment and calls the [flow monitor](https://github.com/get-fabric/fulfillment-flow-monitor) in order to verify sanity flow is working.

### Usage
Every participating service should be added to the [fulfillment-integration](https://github.com/get-fabric/fulfillment-integration) repo. Then in order to run the integration tests you just run the [integration-test](https://github.com/get-fabric/fulfillment-integration-tests-github-action/blob/main/.github/workflows/integration-test.yaml) workflow

1. Make sure the service is [added](https://github.com/get-fabric/fulfillment-integration#adding-service) to the fulfillment-integration repo.

2. Copy this `integration-test` step into your service `tests.yaml` workflow:
```
  integration-test:
    uses: get-fabric/fulfillment-integration-tests-github-action/.github/workflows/integration-test.yaml@main
    with:
      service_name: ${{ github.event.repository.name }}
      branch: ${{ github.branch }}
      test_runner_service_name: fulfillment-flow-monitor      
      test_runner_endpoint: /healthcheck
    secrets:
      git_token: ${{ secrets.ORG_GITHUB_ADMIN_TOKEN }}
      gcloud_token: ${{ secrets.FULFILLMENMT_INTEGRATION_GCLOUD_SERVICE_ACCOUNT }}    
```

Full example of `deploy.yaml` can be found in the [worker-template](https://github.com/get-fabric/worker-template/blob/main/.github/workflows/deploy.yml)
