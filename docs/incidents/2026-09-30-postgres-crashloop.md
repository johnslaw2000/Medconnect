# Postgres pod CrashLoopBackOff

**Date:** 2026-09-30
**Impact:** Database unavailable in the local Kubernetes cluster. No production impact.

## Symptom

The postgres pod entered CrashLoopBackOff after the development VM was restarted. Logs showed:

    error while loading shared libraries: /lib/x86_64-linux-gnu/libtinfo.so.6: file too short

## Investigation

1. `kubectl logs` showed a corrupt shared library inside the container.
2. `kubectl describe pod` confirmed the image pulled successfully and the container started, ruling out a pull failure.
3. `df -h` showed 8.7GB free on the host, ruling out disk exhaustion.
4. Deleting the pod produced an identical failure, so the fault was not a single damaged container.
5. Removing the cached image and forcing a fresh pull also failed, so the fault was not the cached copy.
6. Running the same image directly with `docker run postgres:15 postgres --version` succeeded.

Step 6 isolated the fault: the image was intact, so the problem lay in how the kind node was unpacking it.

## Root cause

The kind node's overlay filesystem was left inconsistent after the host VM was shut down while the cluster was running. Image layers unpacked inside the node were truncated, producing the "file too short" error.

## Fix

Rebuilt the cluster and reapplied the manifests:

    kind delete cluster --name medconnect
    kind create cluster --name medconnect
    kubectl apply -f k8s/

No configuration was lost, as all cluster state is defined in version-controlled manifests.

## Prevention

Stop the kind cluster cleanly before shutting down the host VM, rather than powering off while containers are running.
