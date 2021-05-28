helm install strimzi-kafka strimzi/strimzi-kafka-operator

kubectl create ns kafka

kubectl create ns my-kafka-project

kubectl create -f install/cluster-operator/ -n kafka

kubectl create -f install/cluster-operator/020-RoleBinding-strimzi-cluster-operator.yaml -n my-kafka-project

kubectl create -f install/cluster-operator/032-RoleBinding-strimzi-cluster-operator-topic-operator-delegation.yaml -n my-kafka-project

kubectl create -f install/cluster-operator/031-RoleBinding-strimzi-cluster-operator-entity-operator-delegation.yaml -n my-kafka-project

sh my_config.sh

kubectl wait kafka/my-cluster --for=condition=Ready --timeout=600s -n my-kafka-project
