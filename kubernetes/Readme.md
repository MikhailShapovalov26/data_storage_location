#K8S

Перед применением этого файла YAML вам необходимо создать секрет с именем postgres-secret, содержащим пароль Postgres. Вы можете сделать это, запустив:

    kubectl create secret generic postgres-secret --from-literal=password=<your-password>

Запуск 

    kubectl apply -f postgres-ss.yaml

Приведенная выше команда создаст автономную службу и набор с отслеживанием состояния в вашем кластере. Вы можете проверить их, запустив:

    kubectl get svc
    kubectl get sts
    kubectl get pods
    kubectl get pvc -l app=postgres