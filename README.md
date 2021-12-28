## Fulfillment Integration Tests
This repository contains a workflow that runs an [isolated fulfillment environment](https://github.com/get-fabric/fulfillment-integration) and calls the [flow monitor](https://github.com/get-fabric/fulfillment-flow-monitor) in order to verify sanity flow is working.

### Usage
Every participating service updates [fulfillment-integration deployments folder](https://github.com/get-fabric/fulfillment-integration/tree/master/deployments) with its spec. The spec is generated and pushed by [update-fulfillment-integration]() step. Then in order to run the integration tests you just run the [integration-test](https://github.com/get-fabric/fulfillment-integration-tests-github-action/blob/main/.github/workflows/integration-test.yaml) step

1. Add `update-fulfillment-integration` step into your service `deploy.yaml` workflow:
```
  update-fulfillment-integration:
    needs:
      - update-image
    uses: get-fabric/update-fulfillment-integration/.github/workflows/update-fulfillment-integration.yml@main
    with:
      service_name: ${{ github.event.repository.name }}
      commit_message: 'updated ${{ github.event.repository.name }} with image ${{ needs.update-image.outputs.tag }}'
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
      flow_monitor_endpoint: /healthcheck
    secrets:
      git_token: ${{ secrets.ORG_GITHUB_ADMIN_TOKEN }}
      gcloud_token: ${{ secrets.FULFILLMENMT_INTEGRATION_GCLOUD_SERVICE_ACCOUNT }}     
```
