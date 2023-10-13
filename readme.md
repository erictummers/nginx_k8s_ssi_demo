# Show container info on hosted static webpage with nginx server side includes

## Environment variable

We'll put the version information in an environment variable called ```CONTAINER_VERSION``` during deployment. See [deployment.yaml](deployment.yaml)

## Server Side Includes

Since docker image nginx 1.19 the server side includes can be used. For this you'll need to enable it. This is done via a template.

## Template

The template file overwrites the config file with the same name. So we call the template default.conf.template to overwrite the default.conf and enable server side includes (ssi) this way.

see [default.conf.template](default.conf.template)

## HTML

Now we have the environment variable converted into a server side include variable we can put it into the html. The syntaxt can be found here https://nginx.org/en/docs/http/ngx_http_ssi_module.html

```html
<p>
    Hello there you are running container version 
    <!--# echo var="version" default="unknown" -->
</p>   
```

## Docker build

In the Dockerfile we copy the template and the html into the container and apply a tag based on the date.
```bash
docker build -t site:20231013.1 .
```

## Putting it all together

After the docker build we change the version tag for the container in the deployment. Now we can deploy the new version and see the version is reported in the html.

```bash
kubectl apply -f ./deployment.yaml
kubectl port-forward deploy/site 8080:80
```

Now browse to http://localhost:8080 and see the version reported.

## Future

We still need to provide the text value for the environment variable. There is no selector for the image/version available according to the [kubernetes.io docs](https://kubernetes.io/docs/tasks/inject-data-application/environment-variable-expose-pod-information/)

Since we automate the build in a pipeline and have the option to replace values, we replace the value for the image in the deployment.yaml together with the environment variable. This works great until the selector is added (if ever)