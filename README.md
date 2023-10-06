# Prework

```console
cd /home/user
git clone https://github.com/ntap-johanneswagner/insight2023
cd /home/user/insight2023/prework
bash prework.sh
rke2
kubectl apply -f rke2-pacman.yml
rke1
```
=> setup acc for pacman in rke2 remember wildcard is .*mongo.*    


# show backends & scs
```console
kubectl get tbe -n trident
```
=> Backends zeigen
```console
cat 0-backend-san.yaml
kubectl get sc
```
=> SC zeigen
```console
cat 01-rke1_sc_san.yaml
```
=> sc anwenden
```console
kubectl apply -f 01-rke1_sc_san.yaml
```
=> sc zeigen
```console
kubectl get sc
```
# show app
```console
cat 02-pacman.yml
kubectl apply -f 02-pacman.yml
kubectl get -n pacman all,pvc
=> show ontap cluster and volume
```console
kubectl describe pvc mongo-storage -n pacman
=> resize volume
```console
kubectl patch -n pacman pvc mongo-storage -p '{"spec":{"resources":{"requests":{"storage":"10Gi"}}}}'
kubectl describe pvc mongo-storage -n pacman
=> show ontap
=> resize volume to be smaller
```console
kubectl patch -n pacman pvc mongo-storage -p '{"spec":{"resources":{"requests":{"storage":"8Gi"}}}}'
kubectl get svc -n pacman
=> show pacman


# demo snapshot
kubectl apply -f 03-busybox.yaml
kubectl get -n busybox all,pvc
kubectl exec -n busybox $(kubectl get pod -n busybox -o name) -- sh -c 'echo "Hello Roche" > /data/test.txt'
kubectl exec -n busybox $(kubectl get pod -n busybox -o name) -- more /data/test.txt
cat 04-pvc-snapshot.yaml
kubectl apply -f 04-pvc-snapshot.yaml
kubectl get volumesnapshot -n busybox
=> im Ontap zeigen
kubectl exec -n busybox $(kubectl get pod -n busybox -o name) -- rm -f /data/test.txt
kubectl exec -n busybox $(kubectl get pod -n busybox -o name) -- more /data/test.txt
cat 05-pvc_from_snap.yaml
kubectl apply -f 05-pvc_from_snap.yaml
kubectl get pvc -n busybox
=> show ontap
kubectl patch -n busybox deploy busybox -p '{"spec":{"template":{"spec":{"volumes":[{"name":"volume","persistentVolumeClaim":{"claimName":"mydata-from-snap"}}]}}}}'

kubectl exec -n busybox $(kubectl get pod -n busybox -o name) -- more /data/test.txt

=> demo acc remember, wildcards .*mongo.*

destroy pacman in rke2

first show highscores in pacman in rke2

```bash
rke2
kubectl exec -it -n pacman $(kubectl get pod -n pacman -l "name=mongo" -o name) -- mongo --eval 'db.highscore.updateMany({},{$set:{name:"EVIL",cloud:"YOU",zone:"HAVE BEEN",host:"HACKED",score:"666"}});' pacman
```

db.highscore.updateOne({"_id": ObjectId("651ec891683af30011f7f04b")}, {$set: {name: "GeorgeK"}})

db.highscore.replaceOne({"name": "CharlieG"}, {"score": "9999"})

kubectl exec -it -n pacman $(kubectl get pod -n pacman -l "name=mongo" -o name) -- mongo --eval 'db.highscore.updateMany({},{$set:{cloud:"Insight 2023",zone:"Vegas",host:"MGM"}});' pacman

kubectl exec -it -n pacman $(kubectl get pod -n pacman -l "name=mongo" -o name) -- mongo --eval 'db.highscore.replaceOne({"name": "CharlieG",}, {name:"CharlieG",cloud:"Vegas",zone:"MGM",host:"Insight2023",score:80});' pacman

kubectl exec -it -n pacman $(kubectl get pod -n pacman -l "name=mongo" -o name) -- mongo --eval 'db.highscore.replaceOne({"name": "CharlieG",}, {name:"CharlieG",cloud:"Vegas",zone:"MGM",host:"Insight2023",score:9999});' pacman

