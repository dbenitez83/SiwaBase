# SiwaBase
Proyecto base de proyecto Orion

Proceso de descarga y arranque de Cluster Siwa en entornos OSX y Linux:

Para descargar el cluster hay que acceder al repositorio:

https://github.com/dbenitez83/SiwaBase.git

y descargarse el proyecto.

Para lanzar el cluster de hadoop se debe ir a la carpeta 

 

/SiwaBase


Para tener una carpeta compartida entre el hosts y la máquina Hadoop-master hay que editar el archivo start-cluster.sh y poner la carpeta indicada en el lugar de "/Volumes/Disco Externo/Orion" en la línea 39


sudo docker run --hostname=hadoop-master --name hadoop-master --privileged=true -itd -v "/Volumes/Disco Externo/Orion":/src -p 8888:8888 -p 8088:8088 -p 3333:3333 -p 50070:50070 -p 18080:18080 --publish-all=true --network=OrionNetwork  orion/hadoop-cluster-master

Guardar y lanzar el script

$./start-cluster.sh

Una vez arrancado, se crear tres máquinas y se arrancan

Hadoop-master

Hadoop-slave1

Hadoop-slave2

Además en la máquina Hadoop-master se ejecuta un Jupyter-notebook en el puerto 3333

Para acceder al jupyter-notebook hay que ir al navegador de la máquina Host y ir a la Url:

http://0.0.0.0:3333

Una vez dentro, se requiere un token, para conocerlo hay que ir a la máquina hadoop-master y lanzar la siguiente instrucción:

$./root/anaconda2/bin/jupyter-notebook list

Aparecerá la url de jupyter-notebook así como su token.


Una vez arrancada la máquina, se pueden cargar archivos en el Hadoop file system utilizando las instrucciones siguientes:

$HADOOP_HOME/hadoop fs -put file.csv /folder

Y luego dentro del jupyter-notebook

file = hiveContext.read.format('com.databricks.spark.csv').\

options(header='true', inferSchema='true',delimiter='\t').\

load("hdfs://hadoop-master:9000/folder/file.csv")

de este modo tendremos el dataframe con el fichero cargado.
