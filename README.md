# terraform-testing

1. Upgrade terraform - download terraform 0.12.29 executable, copy to /usr/local/bin
2. ``` chmod 775 terraform ```
3. Create respoistory for plugins (as behind proxy)
4. Copy docker provider to /usr/local/bin/terraform_plugins
5.  ``` chmod 775 terraform-provider-docker ```
6. ``` vi main.tf ```

``` 
resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = false
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.latest
  name  = "tutorial"
  ports {
    internal = 80
    external = 8000
  }
}
```

7. ``` tarraform init ```
8. ``` tarraform apply ```
