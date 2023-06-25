# Step

### Requests, Limits

Реквесты - это то количество ресурсов, которые Под занимает на ноде (воркере). Если CPU не достаточно но scheduler отправит новый под который больше чем доступно на новую ноду. </br>
Лимиты Приложения в моменте может давать много нагрузки, например при старте. Можно сделать реквест на 400 i CPU а лимит 2000 чтоб сервис быстрее поднялся. </br>
Если приложение дойдет до лимита памяти, то его убъект OOM Killer. А если приложение дойдет до лимита CPU то будет троттлить.
 посыл в том, что Kubernetes вообще никак не мешает приложению выходить за рамки реквестов.</br>

В Кубернетесе есть такое понятие как QoS (Quality of Service). Существует три типа QoS:

* Best Effort - такой класс присваивается, когда Вы вообще не указываете реквесты и лимиты;
* Burstable - данный класс будет присвоен, если лимиты и реквесты отличаются;
* Guaranted - когда лимиты и реквесты равны друг-другу.

    resources:
    requests:
        memory: "100Mi"
        cpu: "200m"
    limits:
        memory: "100Mi"
        cpu: "200m"

liveness - проба позволяет Кубернетусу делать Health-check'и и при непрохождении определенного в описании Пробы количества проверок Kubernetes перезагрузит контейнер в Поде.

    apiVersion: v1
    kind: Pod
    metadata:
    labels:
        test: my-pod
    name: my-pod-http
    spec:
    containers:
    - name: containername
        image: k8s.gcr.io/liveness
        args:
        - /server
        livenessProbe:
        httpGet:
            path: /healthz
            port: 8080
            httpHeaders:
            - name: Custom-Header
            value: Awesome
        initialDelaySeconds: 3
        periodSeconds: 2

initialDelaySeconds: 3 - означает, что после запуска Пода и перед первой Проверкой пройдет 3 секунды. По умолчанию - 0 секунд.</br>
periodSeconds: 2 - означает, что проверки будут происходить каждый 2 секунды. По умолчанию - 10 секунд.</br>
failureThreshold:  количество повторных Проверок перед рестартом. По умолчанию 3</br>
timeoutSeconds: Количество секунд ожидания ответа на Проверке. По умолчанию 1 секунда. </br>
successThreshold: Минимальное количество последовательных проверок, чтобы проба считалась успешной после неудачной. По умолчанию 1. </br>

readinessProbe - позволяет не трогать под пока он не отработает запрос лучае ее непрохождение, Kubernetes Service не будет посылать запросы на Под.

    readinessProbe:
    exec:
        command:
        - cat
        - /tmp/healthy
    initialDelaySeconds: 5
    periodSeconds: 5
startupProbe - при старте мало выделели лимит и приложение долго запускаеться, чтоб кубернетес дождался загрузки и потом только начал проверять доступность приложения. 

    startupProbe:
    httpGet:
        path: /healthz
        port: liveness-port
    failureThreshold: 30
    periodSeconds: 10

### Horizontal Pod Autoscaler

    apiVersion: autoscaling/v2beta2
    kind: HorizontalPodAutoscaler
    metadata:
    name: php-apache
    spec:
    scaleTargetRef:
        apiVersion: apps/v1
        kind: Deployment
        name: php-apache
    minReplicas: 1
    maxReplicas: 5
    metrics:
    - type: Resource
        resource:
        name: cpu
        target:
            type: Utilization
            averageUtilization: 80

 Минимальное количество реплик - 1, максимальное - 5, и в случае, если CPU у одного из Подов дойдет до 80% от реквеста, то HPA добавит еще одну реплику

### RBAC
 Role Based Access Contol - основной механизм управления доступами в Kubernetes.

RoleBinding

    kind: RoleBinding
    apiVersion: rbac.authorization.k8s.io/v1
    metadata:
    name: ivanov_aa-reader-pods
    namespace: lesson2
    subjects:
    - kind: User
    name: ivanov_aa
    apiGroup: rbac.authorization.k8s.io
    roleRef:
    kind: Role
    name: pod-reader
    apiGroup: rbac.authorization.k8s.io
Таким образом мы разрешили пользователю Ivanov_aa смотреть Поды в неймспейсе lesson2.

#### ServiceAccount

ServiceAccount, разница пользователя и SA в том, что SA существует лишь в рамках неймспейса.  

    apiVersion: v1
    kind: ServiceAccount
    metadata:
    name: demo-sa
    automountServiceAccountToken: false

чтобы дать Сервис Аккаунту права, используйте подобный манифест:

    kind: RoleBinding
    apiVersion: rbac.authorization.k8s.io/v1
    metadata:
    name: ivanov_aa-reader-pods
    namespace: lesson2
    subjects:
    - kind: ServiceAccount
    name: demo-sa
    namespace: lesson2
    roleRef:
    kind: Role
    name: pod-reader
    apiGroup: rbac.authorization.k8s.io

### kubectl-debug
https://github.com/aylei/kubectl-debug
https://learnk8s.io/troubleshooting-deployments

### Control Plane

правляющий уровень Kubernetes состоит из 4-х объектов, которые расположены на Мастер-Нодах. Для отказоустойчивости кластера рекомендуем соблюдать кворум Мастеров например, 3 Мастер-Ноды.

![Alt text](image.png)

Data Plane
Компонентами на Воркер-Нодах являются runtime, kubelet и kube-proxy.

![Alt text](image-1.png)

поиск проблемы в поде если нет ответа в логах и describe

    sudo journalctl -u kubelet | grep <podname>