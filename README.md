# MicroK8s Container Image Pruner DaemonSet

* This project provides a Kubernetes DaemonSet designed to run on each node in a MicroK8s cluster. Its purpose is to periodically prune unused container images using the `crictl rmi --prune` command, helping to reclaim disk space on your nodes.
* It contains the daemonset.yaml you can deploy, which is currently deploying "develop", but we can tag and release it after review.
* Tolerations: The current DaemonSet uses a universal toleration (operator: Exists) to run on any node. If you need more granular control, you can replace this with specific tolerations for the taints present in your cluster (as shown in a previous version of the DaemonSet YAML).
