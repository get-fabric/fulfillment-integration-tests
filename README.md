## Fulfillment Integration Tests
This repository contains a workflow that runs an isolated [fulfillment integration](https://github.com/get-fabric/fulfillment-integration) environment and calls the [flow monitor](https://github.com/get-fabric/fulfillment-flow-monitor) in order to verify sanity flow is working.

### Usage
Every participating service updates [fulfillment-integration](https://github.com/get-fabric/fulfillment-integration) deployments folder with its spec. The spec is generated and pushed by [update-fulfillment-integration](https://github.com/get-fabric/update-fulfillment-integration) step. Then in order to run the integration tests you just run the [integration-test](https://github.com/get-fabric/fulfillment-integration-tests-github-action/blob/main/.github/workflows/integration-test.yaml) workflow

1. Copy this `update-fulfillment-integration` job into your service `deploy.yaml` workflow, right below the update-image job
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

2. Copy this `integration-test` step into your service `tests.yaml` workflow:
```
  integration-test:
    uses: get-fabric/fulfillment-integration-tests-github-action/.github/workflows/integration-test.yaml@main
    with:
      service_name: ${{ github.event.repository.name }}
      branch: ${{ github.branch }}
      flow_monitor_endpoint: /flows/sanity
    secrets:
      git_token: ${{ secrets.ORG_GITHUB_ADMIN_TOKEN }}
      gcloud_token: ${{ secrets.FULFILLMENMT_INTEGRATION_GCLOUD_SERVICE_ACCOUNT }}     
```

Full example of `deploy.yaml` can be found in the [worker-template](https://github.com/get-fabric/worker-template/blob/main/.github/workflows/deploy.yml)
