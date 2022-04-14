Three node mongo cluster with jupyter notebook.

To start:
- To create the keyfile, run `openssl rand -base64 756 > mongo_keyfile`
- Run `docker-compose up -d`
- To initalize cluster, run: 
```
docker exec -it mongo1 mongosh -u root -p example --eval "rs.initiate({
 _id: \"myReplicaSet\",
 members: [
   {_id: 0, host: \"mongo1\"},
   {_id: 1, host: \"mongo2\"},
   {_id: 2, host: \"mongo3\"}
 ]
})"
```
- To confirm cluster is running, run:
```
docker-compose exec mongo1 mongosh -u root -p example --eval "rs.status()"
```
- Navigate to localhost:8888 in browser to use Jupyter Notebook to interact with Mongo