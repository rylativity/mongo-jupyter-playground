Sharded MongoDB Docker-Compose Setup with mongocfg, mongos, and two two-node replica sets (6 nodes total).  Paired with a Jupyter Notebook container for exploration and interaction with MongoDB in Python

***
## Setup
### 1) Create the Mongo Keyfile (for intra-cluster communication)
To create the keyfile, run `openssl rand -base64 756 > mongo_keyfile`
### 2) Start the Containers
Run `docker-compose up -d`
### 3) Initialize the Cluster
To initialize the cluster, ensure that the 'cluster_init.sh' script is executable (`chmod +x ./cluster_init.sh`) and then run `./cluster_init.sh`

The 'cluster_init.sh` script performs the following initialization steps:
- Initializes the single-node configserver cluster
- Initializes the mongod replicasets (these are the data nodes; two primary servers, each with a replica for a total of 4 nodes)
- Creates a single "root" user with user-admin, cluster-admin, and root permissions
- Adds one shard to each of the two replicasets

Take a look at the contents of the 'cluster_init.sh' script if you want to see exactly how each step is performed.

**At this point, there is a single superuser with the credentials username=root password=example.  If you want to use a different username/password, modify the values in the appropriate step of the cluster_init.sh script before running**

### 4) Follow PyMongo Examples in Jupyter
- Navigate to http://localhost:8888 in browser to use Jupyter Notebook to interact with Mongo.
***
## Additional Useful Commands

### To connect to mongosh in the mongos server, run:
`docker-compose exec mongos mongosh -u root -p example`

or to run a single mongosh command, run

`docker-compose exec mongos mongosh -u root -p example --eval "<YOUR_MONGOSH_COMMAND_HERE>"`

### To view detailed shard status, including sharding of collections, run:
`docker-compose exec mongos mongosh -u root -p example --eval "sh.status()"`

### To confirm shard replica-set cluster is running, run:
`docker-compose exec mongo1 mongosh mongodb://localhost:27018 --eval "rs.status()"`

or 

`docker-compose exec mongo3 mongosh mongodb://localhost:27018 --eval "rs.status()"`

### To add additional shards to a replicaset, run:
`docker-compose exec mongos mongosh -u root -p example --eval "sh.addShard(\"shardReplicaSet1/mongo1:27018\")"`

or

`docker-compose exec mongos mongosh -u root -p example --eval "sh.addShard(\"shardReplicaSet2/mongo1:27018\")"`

### To create additional users, run:
```
docker-compose exec mongos mongosh -u root -p example --eval "admin=db.getSiblingDB(\"admin\");
admin.createUser({
  user:\"user1\",
  pwd:\"example\",
  roles: [\"root\"]
})"
```
Make sure to modify the user, pwd, and roles values as needed.  See https://www.mongodb.com/docs/manual/reference/built-in-roles/ for a list of built-in roles.

## Troubleshooting & Tips
- To completely wipe everything and start over, run `docker-compose down` followed by `sudo rm -rf mongo_data*` to bring the containers down and wipe out existing data (which is persisted on the host machine)

- See examples under "Additional Useful Commands" section above for examples on how to issue commands to mongos or mongod nodes

- Any commands issued to mongos (including those through `docker-compose exec mongos ...`) require you to provide a username and password.  This is because we create a user in the 'cluster_init.sh' script, which closes the localhost exception.  See https://www.mongodb.com/docs/manual/core/localhost-exception/ for additional details

- Any commands issued to any of the mongod nodes (mongo1, mongo2, mongo3, and mongo4) do not require username and password because the localhost exception is still open. See https://www.mongodb.com/docs/manual/core/localhost-exception/ for additional details
