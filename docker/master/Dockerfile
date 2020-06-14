FROM orion/hadoop-cluster-base
MAINTAINER orion

WORKDIR /root

# installing conda
RUN wget https://repo.anaconda.com/archive/Anaconda2-2019.10-Linux-x86_64.sh && \
	chmod +x Anaconda2-2019.10-Linux-x86_64.sh && \
	./Anaconda2-2019.10-Linux-x86_64.sh -b -p /root/anaconda2


# installing Spark
RUN wget http://apache.rediris.es/spark/spark-2.4.5/spark-2.4.5-bin-hadoop2.7.tgz && \
    tar -xvf spark-2.4.5-bin-hadoop2.7.tgz && \
    mv spark-2.4.5-bin-hadoop2.7 /usr/local/spark && \
    rm spark-2.4.5-bin-hadoop2.7.tgz

# installing hive 3.1.1
RUN wget https://archive.apache.org/dist/hive/hive-3.1.1/apache-hive-3.1.1-bin.tar.gz && \
    tar -xvf apache-hive-3.1.1-bin.tar.gz  && \
    mv apache-hive-3.1.1-bin /usr/local/hive && \
    rm apache-hive-3.1.1-bin.tar.gz

ENV HIVE_HOME=/usr/local/hive
ENV PATH=$PATH:/usr/local/hive/bin
ENV PYSPARK_PYTHON=python3

ADD config/hive-site.xml /usr/local/hive/conf
RUN chown root:root /usr/local/hive/conf/hive-site.xml

ENV PATH=$PATH:/usr/local/spark/bin
ENV SPARK_HOME=/usr/local/spark

ENV LD_LIBRARY_PATH=/usr/local/hadoop/lib/native:$LD_LIBRARY_PATH

ADD config/spark-defaults.conf /usr/local/spark/conf
RUN chown root:root /usr/local/spark/conf/spark-defaults.conf

ADD bin/stackanswer_2.12-1.0.jar /usr/local/spark/jars

ADD config/bootstrap.sh /etc/bootstrap.sh
RUN chown root:root /etc/bootstrap.sh
RUN chmod 700 /etc/bootstrap.sh

ENV BOOTSTRAP /etc/bootstrap.sh

ADD data /data

VOLUME /data

CMD ["/etc/bootstrap.sh", "-d"]

EXPOSE 18080 
# hive port
EXPOSE 10000 9083 9999
# Jupyter
EXPOSE 3333
# PySpark port
EXPOSE 41685
# SSH port
EXPOSE 2202

