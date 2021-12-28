## Fulfillment Integration Tests
This repository contains a workflow that runs an [isolated fulfillment environment](https://github.com/get-fabric/fulfillment-integration) and calls the [flow monitor](https://github.com/get-fabric/fulfillment-flow-monitor) in order to verify sanity flow is working.
The repository also includes a workflow that adds service to be a participant in `fulfillment-integration` and therefore a participant in the integration test

### Usage
Every participating service updates [fulfillment-integration deployments folder](https://github.com/get-fabric/fulfillment-integration/tree/master/deployments) with its spec. The spec is generated and pushed by [update-fulfillment-integration]() step. Then in order to run the integration tests you just run the [integration-test](https://github.com/get-fabric/fulfillment-integration-tests-github-action/blob/main/.github/workflows/integration-test.yaml) step

1. Add `update-fulfillment-integration` step into your service `deploy.yaml` workflow:
```
  update-fulfillment-integration:
    needs:
      - update-image
    uses: get-fabric/helm-template-and-push-action/.github/workflows/helm-template-and-push.yml@main
    with:
      service_name: ${{ github.event.repository.name }}
    secrets:
      git_token: ${{ secrets.ORG_GITHUB_ADMIN_TOKEN }}      
```

2. Add `integration-test` step into your service `tests.yaml` workflow:
```
  integration-test:
    uses: get-fabric/fulfillment-integration-tests-github-action/.github/workflows/integration-test.yaml@main
    with:
      service_name: ${{ github.event.repository.name }}
      branch: ${{ github.branch }}
      flow_monitor_endpoint: /flows/sanity
    secrets:
      git_token: ${{ secrets.ORG_GITHUB_ADMIN_TOKEN }}      
```
