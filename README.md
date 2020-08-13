# terraform-testing

deploy docker nginx container

1. Terraform installed on CentOS VM, requires upgrade - download terraform 0.12.29 executable, copy to /usr/local/bin
2. ``` chmod 775 terraform ```
3. Unable to download/install providers as behind proxy - Manually create respository for plugins /usr/local/bin/terraform_plugins/
4. Copy docker provider to /usr/local/bin/terraform_plugins
5.  ``` chmod 775 terraform-provider-docker ```
6. ``` mkdir tarraform-docker-demo ```
7. ``` vi main.tf ```

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

8. ``` tarraform init ```
9. ``` tarraform apply ```

```
An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # docker_container.nginx will be created
  + resource "docker_container" "nginx" {
      + attach           = false
      + bridge           = (known after apply)
      + command          = (known after apply)
      + container_logs   = (known after apply)
      + entrypoint       = (known after apply)
      + env              = (known after apply)
      + exit_code        = (known after apply)
      + gateway          = (known after apply)
      + hostname         = (known after apply)
      + id               = (known after apply)
      + image            = (known after apply)
      + ip_address       = (known after apply)
      + ip_prefix_length = (known after apply)
      + ipc_mode         = (known after apply)
      + log_driver       = (known after apply)
      + log_opts         = (known after apply)
      + logs             = false
      + must_run         = true
      + name             = "tutorial"
      + network_data     = (known after apply)
      + read_only        = false
      + restart          = "no"
      + rm               = false
      + shm_size         = (known after apply)
      + start            = true
      + user             = (known after apply)

      + labels {
          + label = (known after apply)
          + value = (known after apply)
        }

      + ports {
          + external = 8000
          + internal = 80
          + ip       = "0.0.0.0"
          + protocol = "tcp"
        }
    }

  # docker_image.nginx will be created
  + resource "docker_image" "nginx" {
      + id           = (known after apply)
      + keep_locally = false
      + latest       = (known after apply)
      + name         = "nginx:latest"
    }

Plan: 2 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

docker_image.nginx: Creating...
docker_image.nginx: Still creating... [10s elapsed]
docker_image.nginx: Creation complete after 17s [id=sha256:08393e824c32d456ff69aec72c64d1ab63fecdad060ab0e8d3d42640fc3d64c5nginx:latest]
docker_container.nginx: Creating...
docker_container.nginx: Creation complete after 2s [id=642380f0cca3e122f377a176c30c9a3ac4e4b78703282f6dbc3b3212ec88704c]

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

```

10. ``` docker ps ```

```
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                  NAMES
642380f0cca3        08393e824c32        "/docker-entrypoint.…"   57 seconds ago      Up 55 seconds       0.0.0.0:8000->80/tcp   tutorial
```

11. ``` terraform destroy ```




