cat << EOF | kubectl create -n my-kafka-project -f -
apiVersion: kafka.strimzi.io/v1beta2
kind: Kafka
metadata:
  name: my-cluster
spec:
  kafka:
    replicas: 1
    logging:
      type: inline
      loggers:
        kafka.root.logger.level: "INFO"
    resources:
      requests:
        memory: 16Gi
        cpu: "8"
      limits:
        memory: 32Gi
        cpu: "12"
    readinessProbe:
      initialDelaySeconds: 15
      timeoutSeconds: 5
    livenessProbe:
      initialDelaySeconds: 15
      timeoutSeconds: 5
    listeners:
      - name: plain
        port: 9092
        type: internal
        tls: false
      - name: tls
        port: 9093
        type: internal
        tls: true
        authentication:
          type: tls
      - name: external
        port: 9094
        type: nodeport
        configuration:
          brokers:
            - broker: 0
              advertisedHost: 127.0.0.1
            - broker: 1
              advertisedHost: 127.0.0.2
          bootstrap:
            nodePort: 30478
        tls: false
    config:
      auto.create.topics.enable: "true"
      offsets.topic.replication.factor: 1
      transaction.state.log.replication.factor: 1
      transaction.state.log.min.isr: 1
      log.message.format.version: "2.7.0"
    storage:
      type: jbod
      volumes:
      - id: 0
        type: persistent-claim
        size: 1Gi
        deleteClaim: false
    config:
      offsets.topic.replication.factor: 1
      transaction.state.log.replication.factor: 1
      transaction.state.log.min.isr: 1
  zookeeper:
    replicas: 1
    logging:
      type: inline
      loggers:
        zookeeper.root.logger: "INFO"
    resources:
      requests:
        memory: 8Gi
        cpu: "2"
      limits:
        memory: 8Gi
        cpu: "2"
    storage:
      type: persistent-claim
      size: 1Gi
      deleteClaim: false
  entityOperator:
    topicOperator: {}
    userOperator: {}
EOF