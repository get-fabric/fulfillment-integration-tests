## Fulfillment Integration Tests
This repository contains a workflow that runs an isolated [fulfillment integration](https://github.com/get-fabric/fulfillment-integration) environment and calls a test runner in order to verify sanity flow is working.

### Usage
Every participating service should be added to the [fulfillment-integration](https://github.com/get-fabric/fulfillment-integration) repo. Then in order to run the integration tests you just run the [integration-test](https://github.com/get-fabric/fulfillment-integration-tests-github-action/blob/main/.github/workflows/integration-test.yaml) workflow

1. Make sure the service is [added](https://github.com/get-fabric/fulfillment-integration#adding-services) to the fulfillment-integration repo.

2. Copy this `integration-test` step into your service `tests.yaml` workflow:
```
  integration-test:
    uses: get-fabric/fulfillment-integration-tests-github-action/.github/workflows/integration-test.yaml@main
    with:
      service_name: ${{ github.event.repository.name }}
      branch: ${{ github.branch }}
    secrets:
      git_token: ${{ secrets.ORG_GITHUB_ADMIN_TOKEN }}
      gcloud_token: ${{ secrets.FULFILLMENMT_INTEGRATION_GCLOUD_SERVICE_ACCOUNT }}
      slack_token: ${{ secrets.FULFILLMENT_INTEGRATION_TESTS_SLACK_BOT_TOKEN }}
```

### Adding services

Each fulfillment service should update the deployments folder with its spec. The spec is auto-generated and pushed by the [update-fulfillment-integration](https://github.com/get-fabric/update-fulfillment-integration) GitHub action.

To add a service to the deployments folder add a file named `update-fulfillment-integration.yaml` to your github workflows:
```
name: update-fulfillment-integration

on:
  push:
    paths:
      - 'deployment/**'
    branches: [main]

  workflow_dispatch:

jobs:
  update-fulfillment-integration:
    uses: get-fabric/update-fulfillment-integration/.github/workflows/update-fulfillment-integration.yml@main
    with:
      service_name: ${{ github.event.repository.name }}
    secrets:
      git_token: ${{ secrets.ORG_GITHUB_ADMIN_TOKEN }}

```

Full example of `deploy.yaml` can be found in the [worker-template](https://github.com/get-fabric/worker-template/blob/main/.github/workflows/deploy.yml).
