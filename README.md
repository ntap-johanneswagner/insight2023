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


# show app
```console
cat 02-pacman.yml
kubectl apply -f 02-pacman.yml
kubectl get -n pacman all,pvc




=> demo acc remember, wildcards .*mongo.*

# demo snapshot (all in rke2)
kubectl apply -f 03-busybox.yaml
kubectl get all,pvc -n busybox 
kubectl patch -n busybox pvc mydata -p '{"spec":{"resources":{"requests":{"storage":"20Gi"}}}}'
kubectl get pvc -n busybox 
kubectl patch -n busybox pvc mydata -p '{"spec":{"resources":{"requests":{"storage":"10Gi"}}}}'
kubectl exec -n busybox $(kubectl get pod -n busybox -o name) -- sh -c 'echo "Hello Insight 2023 audience! you are awesome!" > /data/insight2023message.txt'
kubectl exec -n busybox $(kubectl get pod -n busybox -o name) -- more /data/insight2023message.txt
cat 04-pvc-snapshot.yaml
kubectl apply -f 04-pvc-snapshot.yaml
kubectl get volumesnapshot -n busybox
=> im Ontap zeigen
kubectl exec -n busybox $(kubectl get pod -n busybox -o name) -- rm -f /data/insight2023message.txt
kubectl exec -n busybox $(kubectl get pod -n busybox -o name) -- more /data/insight2023message.txt
cat 05-pvc_from_snap.yaml
kubectl apply -f 05-pvc_from_snap.yaml
kubectl get pvc -n busybox
=> show ontap
kubectl patch -n busybox deploy busybox -p '{"spec":{"template":{"spec":{"volumes":[{"name":"volume","persistentVolumeClaim":{"claimName":"mydata-from-snap"}}]}}}}'

kubectl exec -n busybox $(kubectl get pod -n busybox -o name) -- more /data/insight2023message.txt

=> demo acc remember, wildcards .*mongo.*

destroy pacman in rke2

first show highscores in pacman in rke2


kubectl exec -it -n pacman $(kubectl get pod -n pacman -l "name=mongo" -o name) -- mongo --eval 'db.highscore.updateMany({"name": "CharlieG"},{$set:{name:"CharlieG",cloud:"Insight 2023",zone:"Vegas",host:"MGM",score:9999}});' pacman

```bash
rke2
kubectl exec -it -n pacman $(kubectl get pod -n pacman -l "name=mongo" -o name) -- mongo --eval 'db.highscore.updateMany({},{$set:{name:"EVIL",cloud:"YOU",zone:"HAVE BEEN",host:"HACKED",score:"666"}});' pacman
```

db.highscore.updateOne({"_id": ObjectId("651ec891683af30011f7f04b")}, {$set: {name: "GeorgeK"}})

db.highscore.replaceOne({"name": "CharlieG"}, {"score": "9999"})

kubectl exec -it -n pacman $(kubectl get pod -n pacman -l "name=mongo" -o name) -- mongo --eval 'db.highscore.updateMany({},{$set:{cloud:"Insight 2023",zone:"Vegas",host:"MGM"}});' pacman

kubectl exec -it -n pacman $(kubectl get pod -n pacman -l "name=mongo" -o name) -- mongo --eval 'db.highscore.replaceOne({"name": "CharlieG",}, {name:"CharlieG",cloud:"Vegas",zone:"MGM",host:"Insight2023",score:80});' pacman

kubectl exec -it -n pacman $(kubectl get pod -n pacman -l "name=mongo" -o name) -- mongo --eval 'db.highscore.replaceOne({"name": "CharlieG",}, {name:"CharlieG",cloud:"Vegas",zone:"MGM",host:"Insight2023",score:9999});' pacman

