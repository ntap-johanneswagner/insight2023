1. Add Trident helm repo:

helm repo add netapp-trident https://netapp.github.io/trident-helm-chart

2. Ask helm to install trident in the namespace trident

helm install trident netapp-trident/trident-operator --version 23.07.1 --create-namespace --namespace trident

3. Create a yaml file for a secret with your ontap credentials

apiVersion: v1
kind: Secret
metadata:
  name: my-secret-svm-ontap-credentials
type: Opaque
stringData:
  username: vsadmin
  password: I-love-NetApp!

4. Create a yaml file for a backend

apiVersion: trident.netapp.io/v1
kind: TridentBackendConfig
metadata:
  name: svm1_nas
spec:
  version: 1
  backendName: svm1_nas
  storageDriverName: ontap-nas
  managementLIF: 192.168.0.133
  credentials:
    name: my-secret-svm-ontap-credentials

5. Apply both yaml files to the Trident namespace

6. Create a yaml file for a storage class 

apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: sc-nas-svm1
  annotations:
    storageclass.kubernetes.io/is-default-class: "true"
provisioner: csi.trident.netapp.io
parameters:
  backendType: "ontap-nas"
allowVolumeExpansion: true