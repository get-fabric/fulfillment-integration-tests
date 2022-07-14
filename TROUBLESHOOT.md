# Troubleshooting

Integration test failures can be divided into two main reasons:
- The integration environment failed to initialize (the test waits until **all** service pods get to a "ready" state before starting the actual test)
- The integration test(s) itself didn't pass

<br/>

## Understanding the test failure

Start by opening the failed GitHub workflow.

A GitHub integration test run usually takes less than 10 minutes to complete. The workflow has a timeout of 20 minutes so a ***cancelled*** run of that long might hint an environment initialization failure.

The environment has failed to initialized if:
- The "deploy service" step ended with `(Y<X)/X pods ready` and then `Error: The operation was canceled`
- The "teardown -> report cancelled" step ran

The test itself failed if:
- The "run test" step ran and failed
- The "teardown -> report failure" step ran

<br/>

## Integration environment initialization failures

### Finding the initialization failure cause

- In the cancelled GitHub workflow, go to the "cleanup" step output
- In the list of pods, search for
  - Pods in any failed status (not `Running` or `Completed`)
  - Pods in a `Running` status with `0/1` ready pods

You should find at least one naughty pod that prevented your environment from initializing properly.

### Fixing the initialization failure cause

1. **Question:** Why is my service's kafka-consumer pod showing a `0/1 Running` status?

    **Answer:**
If your service is using new Kafka topics you should add them to the integration environment Kafka deployment [here](https://github.com/get-fabric/integration-environment/blob/main/deployments/default/kafka.yaml). Add both the consumed and the produced topics.


2. **Question:** Why is some other service in a `CrashLoopBackOff` status?

    **Answer:**
The pod couldn't start or the k8s cluster **thought** it couldn't and kept restarting it. Try running the workflow again and it the same pod is failing again then there might be an issue with that specific service. Share this issue in the integration test Slack channel.

<br/>

## Integration test failures

1. **Question:** My test run failed. How can I find the reason?

    **Answer:**
In the "run test" step output, look for the `traceId` of the integration test runner. Use it to search [LogDNA](https://app.logdna.com/b131d67c61/logs/view) to see the run logs.<br/>
Note that successful runs will also have a trace id.

<br/>

---

Please reach out with any more questions or issues to the integration tests Slack channel.
