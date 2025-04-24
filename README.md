# MicroK8s Container Image Pruner DaemonSet

This project provides a Kubernetes DaemonSet designed to run on each node in a MicroK8s cluster. Its purpose is to periodically prune unused container images using the crictl rmi --prune command, helping to reclaim disk space on your nodes.
How it Works

The application consists of a Docker image and a Kubernetes DaemonSet:

    Docker Image: A lightweight Docker image based on Ubuntu that includes the crictl binary. It also contains a simple shell script that executes the crictl rmi --prune command and then sleeps for a specified duration (defaulting to 1 hour) in an infinite loop.

    DaemonSet: A Kubernetes DaemonSet resource that ensures a single instance of the Docker container runs on every node in your cluster. The DaemonSet mounts the host's containerd socket (/var/snap/microk8s/common/run/containerd.sock) into the container, allowing the crictl command inside the container to communicate directly with the node's container runtime. Tolerations are included to allow the pod to schedule on nodes with common taints, such as control plane nodes.

By running as a DaemonSet, the pruning task is distributed across all nodes, ensuring that image cleanup happens locally where the images reside. The infinite loop within the script, combined with the DaemonSet's Always restart policy (which is the default), ensures the pruning command is executed repeatedly on each node.
Prerequisites

    A running MicroK8s cluster.

    Docker or Buildx installed on your local machine to build the Docker image.

    microk8s kubectl configured to interact with your cluster.

Building the Docker Image

The Dockerfile defines the container image. It installs crictl and includes the pruning script.

# Refer to the 'Dockerfile for crictl pruner (Built-in Script)' immersive for the complete content.

To build the image, navigate to the directory containing your Dockerfile and prune_loop.sh script and run:

docker build -t your-docker-registry/crictl-image-pruner-built-in:latest .

Replace your-docker-registry/crictl-image-pruner-built-in:latest with your desired image name and tag. If you are not using a Docker registry, you will need to ensure this image is available on every node in your MicroK8s cluster (e.g., by building it locally on each node or using microk8s ctr image import).

If you are using a registry, push the image:

docker push your-docker-registry/crictl-image-pruner-built-in:latest

Deploying the DaemonSet

The DaemonSet YAML defines how the pruning container is deployed across your cluster.

# Refer to the 'DaemonSet for crictl pruner (Built-in Script) with Universal Toleration' immersive for the complete content.

Before deploying, edit the DaemonSet YAML and replace your-docker-registry/crictl-image-pruner-built-in:latest in the spec.template.spec.containers.image field with the image name and tag you used when building the Docker image.

Save the YAML as crictl-pruner-daemonset.yaml.

Apply the DaemonSet to your MicroK8s cluster:

microk8s kubectl apply -f crictl-pruner-daemonset.yaml

Kubernetes will create a pod on each node that matches the DaemonSet's selector.
Verifying the Deployment

You can check the status of the DaemonSet and the created pods:

microk8s kubectl get daemonset crictl-image-pruner -n kube-system
microk8s kubectl get pods -l app=crictl-image-pruner -n kube-system

To see the output of the pruning script (including execution times and any errors), check the logs of one of the pods:

microk8s kubectl logs <pod-name> -n kube-system

Replace <pod-name> with the actual name of one of the crictl-image-pruner pods.
Customization

    Pruning Frequency: Modify the sleep duration in the prune_loop.sh script to change how often the prune command runs. The value is in seconds.

    crictl Version: Update the CRICTL_VERSION ARG in the Dockerfile to use a different version of crictl.

    crictl Timeout: Adjust the --timeout flag in the crictl command within the prune_loop.sh script if you continue to see DeadlineExceeded errors.

    Containerd Socket Path: Verify that the hostPath.path in the DaemonSet YAML (/var/snap/microk8s/common/run/containerd.sock) matches the actual location of the containerd socket on your MicroK8s nodes.

    Tolerations: The current DaemonSet uses a universal toleration (operator: Exists) to run on any node. If you need more granular control, you can replace this with specific tolerations for the taints present in your cluster (as shown in a previous version of the DaemonSet YAML).

Cleanup

To remove the DaemonSet and the running pods:

microk8s kubectl delete -f crictl-pruner-daemonset.yaml

To remove the Docker image from your nodes, you would typically use docker rmi or microk8s ctr images rm depending on your setup.
