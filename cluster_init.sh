#!/bin/bash

# Initialize the configServer cluster(single node)
docker-compose exec mongocfg mongosh mongodb://localhost:27019 --eval "rs.initiate({
 _id: \"cfgReplicaSet\",
 configsvr:true,
 members: [
   {_id: 0, host: \"mongocfg:27019\"}
 ]
})"

#Initalize shardReplicaSet1 (mongo1 and mongo2)
docker-compose exec mongo1 mongosh mongodb://localhost:27018 --eval "rs.initiate({
 _id: \"shardReplicaSet1\",
 members: [
   {_id: 0, host: \"mongo1:27018\"},
   {_id: 1, host: \"mongo2:27018\"}
 ]
})"

#Initialize shardReplicaSet2 (mongo3 and mongo4)
docker-compose exec mongo3 mongosh mongodb://localhost:27018 --eval "rs.initiate({
 _id: \"shardReplicaSet2\",
 members: [
   {_id: 0, host: \"mongo3:27018\"},
   {_id: 1, host: \"mongo4:27018\"}
 ]
})"

# Create user-admin, cluster-admin, and root-permission user as single user
docker-compose exec mongos mongosh --eval "admin=db.getSiblingDB(\"admin\");
admin.createUser({
  user:\"root\",
  pwd:\"example\",
  roles: [{role:\"userAdminAnyDatabase\", db:\"admin\"},{role:\"clusterAdmin\",db:\"admin\"}, \"root\"]
})"

# Add shards to the two replica sets
docker-compose exec mongos mongosh -u root -p example --eval "sh.addShard(\"shardReplicaSet1/mongo1:27018\")"
docker-compose exec mongos mongosh -u root -p example --eval "sh.addShard(\"shardReplicaSet2/mongo3:27018\")"
