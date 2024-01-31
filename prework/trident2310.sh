cd

if [ $(kubectl -n trident get tver -o=jsonpath='{.items[0].trident_version}') != "23.10.0" ]; then
    echo
    echo "############################################"
    echo "# download Trident package"
    echo "############################################"
    mv trident-installer trident-installer-23.07
    wget https://github.com/NetApp/trident/releases/download/v23.10.0/trident-installer-23.10.0.tar.gz
    tar -xf trident-installer-23.10.0.tar.gz
    cp trident-installer/tridentctl /usr/bin/

    echo
    echo "####################################################"
    echo "# launch the Trident upgrade on both RKE clusters"
    echo "####################################################"
    
    export KUBECONFIG=/root/kubeconfigs/rke1/kube_config_cluster.yml
    helm upgrade trident ~/trident-installer/helm/trident-operator-23.10.0.tgz --namespace trident
    export KUBECONFIG=/root/kubeconfigs/rke2/kube_config_cluster.yml
    helm upgrade trident ~/trident-installer/helm/trident-operator-23.10.0.tgz --namespace trident
  
    echo
    echo "############################################"
    echo "# check Trident on RKE1"
    echo "############################################"
    export KUBECONFIG=/root/kubeconfigs/rke1/kube_config_cluster.yml
    frames="/ | \\ -"
    until [ $(kubectl -n trident get tver -o=jsonpath='{.items[0].trident_version}') = "23.10.0" ]; do
      for frame in $frames; do
        sleep 1; printf "\rwaiting for the Trident upgrade to run $frame"
      done
    done
    echo
    while [ $(kubectl get -n trident pod | grep Running | grep -e '1/1' -e '2/2' -e '6/6' | wc -l) -ne 5 ]; do
      for frame in $frames; do
        sleep 0.5; printf "\rWaiting for Trident to be ready $frame" 
      done
    done

    echo
    echo "############################################"
    echo "# check Trident on RKE2"
    echo "############################################"
    export KUBECONFIG=/root/kubeconfigs/rke2/kube_config_cluster.yml
    frames="/ | \\ -"
    until [ $(kubectl -n trident get tver -o=jsonpath='{.items[0].trident_version}') = "23.10.0" ]; do
      for frame in $frames; do
        sleep 1; printf "\rwaiting for the Trident upgrade to run $frame"
      done
    done
    echo
    while [ $(kubectl get -n trident pod | grep Running | grep -e '1/1' -e '2/2' -e '6/6' | wc -l) -ne 5 ]; do
      for frame in $frames; do
        sleep 0.5; printf "\rWaiting for Trident to be ready $frame" 
      done
    done
fi
