import org.apache.hadoop.conf.Configuration
import org.bson.BSONObject
import org.bson.BasicBSONObject
import org.elasticsearch.spark.rdd.EsSpark
import org.elasticsearch.spark.sql._

val sqlContext = new org.apache.spark.sql.SQLContext(sc)
val config = new Configuration()
config.set("mongo.input.uri", "mongodb://localhost:27017/sparktest.btest")
config.set("mongo.job.input.format", "com.mongodb.hadoop.MongoInputFormat")

val mongoRDD = sc.newAPIHadoopRDD(config, classOf[com.mongodb.hadoop.MongoInputFormat], classOf[Object], classOf[BSONObject])

// Convert BSON to JSON
val bsonRDD = mongoRDD.map(x => x._2)	// Array[(Object, org.bson.BSONObject)] --> Array[org.bson.BSONObject]
val jsonStringRDD = bsonRDD.map(x => x.toString())	// org.apache.spark.rdd.RDD[org.bson.BSONObject] --> org.apache.spark.rdd.RDD[String]
val jsonRDD = sqlContext.jsonRDD(jsonStringRDD)	// org.apache.spark.rdd.RDD[String] --> org.apache.spark.sql.DataFrame
val jsonRDD_mod = jsonRDD.withColumnRenamed("_id", "mongoDB_id")	// modify Mongo column name to avoid conflict with ES

jsonRDD_mod.saveToEs("sparkmongo/mdocs")
//, Map("es.nodes" -> "xx.x.xx.xx", "es.index.auto.create" -> "true", "es.nodes.client.only" -> "true", "es.mapping.date.rich" -> "false"))
//EsSpark.saveToEs(jsonRDD_mod, "sparkmongo/mdocs")
EsSpark.esRDD(sc, "sparkmongo/mdocs").count()

//done
