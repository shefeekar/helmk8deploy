## prerequisites

install git,docker,helm, k3d

pull the code for simple helloworld nodejs application for this repository https://github.com/johnpapa/node-hello using

```jsx
    git clone https://github.com/johnpapa/node-hello command
```

### then build a docker image using Dockerfile

# Stage 1: Build
FROM node:latest AS build
WORKDIR /app
COPY package*.json /app/
RUN npm install
COPY . /app/

# Stage 2: deploy
FROM  node:alpine
WORKDIR /app
COPY --from=build /app/ .
EXPOSE 3000
CMD ["npm", "start"]

```

save this file named as Dockerfile inside the  application directory ten build the image using the  command

```jsx
 **docker build -t multibuild:latest** 
```

### tag and push the image  into docker hub repo named shefeeekar

Log in to Docker Hub:

```jsx
docker login
```

Tag the image:

```jsx
docker tag multibuild:latest shefeekar/multibuild:latest
```

 Push the image:

```jsx
docker push shefeekar/multibuild:latest
```

## **create helm for deploying app in k8**

using command

```jsx
 helm create myappnew3
```

then edit the value of values.yaml with repository ‘shefeekar/myappnew and service port 3000 

```yaml
image:
  repository: shefeekar/multibuild
  pullPolicy: IfNotPresent
  # Overrides the image tag whose default is the chart appVersion.
  tag: ""

service:
type: ClusterIP
port: 3000
```

edit the deployment.yaml  for adding env port 3000 

```yaml
containers:
        - name: {{ .Chart.Name }}
          securityContext:
            {{- toYaml .Values.securityContext | nindent 12 }}
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag | default .Chart.AppVersion }}"
          imagePullPolicy: {{ .Values.image.pullPolicy }}
          ports:
            - name: http
              containerPort: {{ .Values.service.port }}
              protocol: TCP
          env:
            - name: PORT
              value: "3000"    
```

delploy helm chart using the command

```jsx
helm  install myapp3 ./myapp
```

Get the application URL by running these commands:
export POD_NAME=$(kubectl get pods --namespace default -l "[app.kubernetes.io/name=myapp3,app.kubernetes.io/instance=myappv4](http://app.kubernetes.io/name=myapp3,app.kubernetes.io/instance=myappv4)" -o jsonpath="{.items[0].metadata.name}")
export CONTAINER_PORT=$(kubectl get pod --namespace default $POD_NAME -o jsonpath="{.spec.containers[0].ports[0].containerPort}")
echo "Visit [http://127.0.0.1:8080](http://127.0.0.1:8080/) to use your application"
kubectl --namespace default port-forward $POD_NAME 8080:$CONTAINER_PORT
