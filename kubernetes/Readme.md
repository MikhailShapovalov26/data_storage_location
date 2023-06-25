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
    kubectl get pods


Для сборки докер и отправки в github regestry

    docker tag go:v0.1 mshapovalov/lesson1:v01
    docker push mshapovalov/lesson1:v01

Далее делаем деплой

docker pull mshapovalov/lesson1:v01

В данном случае, мы императивно создали Деплоймент first-deployment, используя для Пода образ который запушили выше в докер хаб

Проверить можно 

kubectl get deployments

kubectl get pod

Для переключения между кластером Кубернетес используйте команды :

    kubectl config get-contexts                          # показать список контекстов
    kubectl config current-context                       # показать текущий контекст (current-context)
    kubectl config use-context my-cluster-name           # установить my-cluster-name как контекст по умолчанию

Создание объектов

    kubectl apply -f ./my-manifest.yaml            # создать объект из файла
    kubectl create deployment nginx --image=nginx  # запустить один экземпляр nginx

Просмотр информации

    kubectl get pods -o wide                      # Вывести все поды и показать, на каких они нодах
    kubectl describe pods my-pod                  # Просмотреть информацию о поде такую как время                                                                 # старта, количество и причины рестартов, QoS-класс и прочее
    kubectl logs -f my-pod                        # Просмотр логов в режиме реального времени
    kubectl top pods                              # Вывести информацию об утилизации ресурсов подами

Изменение объектов

    kubectl edit pod my-pod                       # Изменение .yaml манифеста пода

Удаление объектов 

    kubectl delete pod my-pod                       # Удаление пода

Погружение в командную оболочку Пода (проваливаемся вовнутрь)

    kubectl exec -it -n namespace-name podname sh   # На конце выбираем оболочку, если нет sh, ставим bash

Копируем файл в под

    kubectl cp {{namespace}}/{{podname}}:path/to/directory /local/path  # Копирование файла из Пода
    kubectl cp /local/path namespace/podname:path/to/directory          # Копирования файла в Под

Проброс портов

    kubectl port-forward pods/mongo-75f59d57f4-4nd6q 28015:27017  # Проброс порта Пода
    kubectl port-forward mongo-75f59d57f4-4nd6q 28015:27017       # Проброс порта Сервиса

создание namespace

    apiVersion: v1
    kind: Namespace
    metadata:
    name: lesson14

    kubectl get ns

    kubectl get pod -n lesson14 -o wide 

Для просмотра более детальной информации о Поде с точки зрения Кубернетес, нам надо использовать команду 

    kubectl describe pod -n lesson14

    kubectl -n lesson14 port-forward pod/static-web 8080:8080

Посмотреть логи 

    kubectl logs -f -n kube-system static-web -n lesson14

посмотреть yml манифест Пода

    kubectl get pods -n lesson14 static-web -o yaml

подключиться к поду

    kubectl exec -it -n lesson14 pod/static-web -c web sh 

посмотреть утилизацию ресурсов Подами

    kubectl top pods -n lesson14

Deployment имеет возможность делать плавающие/постепенные обновления. То есть, сначала ставить Под с новой версией приложения, и когда она поднимется, убивать реплику старой версии приложения.

    apiVersion: apps/v1
    kind: Deployment
    metadata:
    name: goapp-deployment
    namespace: rolling
    labels:
        app: goapp
    spec:
    replicas: 3
    strategy:
        type: RollingUpdate
        rollingUpdate:
        maxUnavailable: 1
    selector:
    #####отрывок манифеста#####

## Rollout

    kubectl rollout history deployment/goapp-deployment     # Проверить историю деплоймента
    kubectl rollout undo deployment/goapp-deployment        # Откатиться к предыдущей версии деплоймента
    kubectl rollout restart deployment/goapp-deployment     # Плавающий рестарт Подов в деплойменте 

### DaemonSet

    apiVersion: apps/v1
    kind: DaemonSet
    metadata:
    name: fluentd-elasticsearch
    namespace: kube-system
    labels:
        k8s-app: fluentd-logging
    spec:
    selector:
        matchLabels:
        name: fluentd-elasticsearch
    template:
        metadata:
        labels:
            name: fluentd-elasticsearch
        spec:
        containers:
        - name: fluentd-elasticsearch
            image: quay.io/fluentd_elasticsearch/fluentd:v2.5.2

"kind: Job" Джоба поднимает под, отрабатывает и пом    spec:
    containers:
        - name: web
        image: ksxack/lesson1:v0.2
        ports:
            - containerPort: 8080
        volumeMounts:                      # Здесь описано монтирование volume'а к контейнеру
            - name: secret-volume
            mountPath: "/usr/secrets/"
            readOnly: true
    volumes:                               # Здесь описан сам volume (том)
        - name: secret-volume
        secret:
            secretName: first-secreton) в системе Unix. Он периодически запускает задание по заданному расписанию, записанному в формате Cron .

    apiVersion: batch/v1
    kind: CronJob
    metadata:
    name: hello
    spec:
    schedule: "* * * * *"
    jobTemplate:
        spec:
        template:
            spec:
            containers:
            - name: hello
                image: busybox:1.28
                imagePullPolicy: IfNotPresent
                command:
                - /bin/sh
                - -c
                - date; echo Hello from the Kubernetes cluster
            restartPolicy: OnFailure

Просмотр Деплойментов, также как и просмотр других ресурсов в k8s осуществляется командой kubectl get 

    kubectl get deployments -n lesson15

Чтобы просмотреть описание Деплоймента, воспользуйтесь командой:

    kubectl describe deployment -n lesson15 goapp-deployment

Здесь можно просмотреть стратегии обновления, события, количество реплик и т.д.

Что бы изменить кол-во Подов

    kubectl scale deployment -n lesson15 goapp-deployment --replicas=5

### Secrets

Kubernetes позволяет хранить Вам пароли и логины с помощью ресурса Secrets:

    apiVersion: v1
    kind: Secret
    metadata:
    name: first-secret
    namespace: lesson16
    stringData:
    password: qwerty

Использование Секретов в качестве переменной окружения

    apiVersion: apps/v1
    kind: Deployment
    metadata:
    name: goapp-deployment
    namespace: lesson16
    labels:
        app: goapp
    spec:
    replicas: 3
    selector:
        matchLabels:
        app: goapp
    template:
        metadata:
        labels:
            app: goapp
        spec:         ## В последующих примерах я буду оставлять манифест, начиная со spec.template.spec
        containers:
        - name: web
            image: ksxack/lesson1:v0.2
            ports:
            - containerPort: 8080
            env:
            - name: SECRETENV
                valueFrom:
                secretKeyRef:
                    name: first-secret
                    key: password

Запись Secrets в файлы в контейнерах

    spec:
    containers:
        - name: web
        image: ksxack/lesson1:v0.2
        ports:
            - containerPort: 8080
        volumeMounts:                      # Здесь описано монтирование volume'а к контейнеру
            - name: secret-volume
            mountPath: "/usr/secrets/"
            readOnly: true
    volumes:                               # Здесь описан сам volume (том)
        - name: secret-volume
        secret:
            secretName: first-secret

### ConfigMap

Использование ConfigMap в качестве переменной окружения

    spec:
    containers:
        - name: web
        image: ksxack/lesson1:v0.2
        ports:
            - containerPort: 8080
        env:
            - name: COLORGOOD
            valueFrom:
                configMapKeyRef:
                name: env-cm
                key: colorgood
            - name: COLORBAD
            valueFrom:
                configMapKeyRef:
                name: env-cm
                key: colorbad

КонфигМапы удобнее создавать из файла:

    kubectl create cm test-config -n lesson16 --from-file=root-ca.pem  # Вы можете писать cm вместо configmap

Примонтируем КонфигМап к деплойменту: 

    spec:
    containers:
        - name: web
        image: ksxack/lesson1:v0.2
        ports:
            - containerPort: 8080
        volumeMounts:
            - name: cm-volume
            mountPath: "/etc/ssl/certs/"
            readOnly: true
    volumes:
        - name: cm-volume
        configMap:
            name: test-config

После по пути /etc/ssl/certs/ окажется файл root-ca.pem

Persistent Volume Claim - данный тип ресурса позволяет хранить персистентные данные Ваших приложений. Для того что бы использовать PVC Вам необходимо, чтобы в кластере был реализован интерфейс CSI Contorl Storage Interface. Persisten Volume Claim своего рода запрос необходимого постоянного тома -диска. 
Что бы написать PVC необходимо

    apiVersion: v1
    kind: PersistentVolumeClaim
    metadata:
    name: my-pvc
    spec:
    accessModes:
        - ReadWriteOnce
    storageClassName: "default"  # default используется по умолчанию, можно прописать тот класс, 
    resources:                   # который сообщит Вам администратор
        requests:
        storage: 30Gi
    
Далее необходимо примонтировать наш PVC к нашему Pod

    spec:
    containers:
        - name: web
        image: ksxack/lesson1:v0.2
        ports:
            - containerPort: 8080
        volumeMounts:
        - mountPath: "/data"
            name: my-volume
    volumes:
        - name: my-volume
        persistentVolumeClaim:
            claimName: my-pvc