Sharded MongoDB Docker-Compose Setup with MongoCfg, MongoS, and Three-Node Mongod replica-set (5 nodes total).  Paired with a Jupyter Notebook container for exploration and interaction with MongoDB in Python


To start:
- To create the keyfile, run `openssl rand -base64 756 > mongo_keyfile`
- Run `docker-compose up -d`

- To initialize configserver cluster (single-node), run:
```
docker-compose exec mongocfg mongosh mongodb://localhost:27019 --eval "rs.initiate({
 _id: \"cfgReplicaSet\",
 configsvr:true,
 members: [
   {_id: 0, host: \"mongocfg:27019\"}
 ]
})"
```

- To initalize shard cluster, run: 
```
docker-compose exec mongo1 mongosh mongodb://localhost:27018 --eval "rs.initiate({
 _id: \"shardReplicaSet\",
 members: [
   {_id: 0, host: \"mongo1:27018\"},
   {_id: 1, host: \"mongo2:27018\"},
   {_id: 2, host: \"mongo3:27018\"}
 ]
})"
```
- To confirm shard replica-set cluster is running, run:
```
docker-compose exec mongo1 mongosh mongodb://localhost:27018 --eval "rs.status()"
```

- To create the user-admin, cluster-admin, and root-permission user as a single user in mongos, run:
```
docker-compose exec mongos mongosh --eval "admin=db.getSiblingDB(\"admin\");
admin.createUser({
  user:\"root\",
  pwd:\"example\",
  roles: [{role:\"userAdminAnyDatabase\", db:\"admin\"},{role:\"clusterAdmin\",db:\"admin\"}, \"root\"]
})"
```

- To add shards to the cluster, run:
```
docker-compose exec mongos mongosh -u root -p example --eval "sh.addShard(\"myReplicaSet/mongo1:27018\")
"
```

- To create additional users, run:
```
docker-compose exec mongos mongosh -u root -p example --eval "admin=db.getSiblingDB(\"admin\");
admin.createUser({
  user:\"user1\",
  pwd:\"example\",
  roles: [\"root\"]
})"
```

- Navigate to localhost:8888 in browser to use Jupyter Notebook to interact with Mongo