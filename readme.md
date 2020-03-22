## gcp k3d deploiment

requirement download gcp account credentials json file. Name it 
account.json and place it at repository root.

to use :

```shell script
terraform init

terraform apply
```

The terraform provisionning script will try to set 

* ~/.ssh/config

```shell script
Host gcp-1
 Hostname <public_ip>
 User <username>
```

* ~/.kube/config-gcp-mycluster.kubeconfig.yml

```shell script
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: <hidden part>
    server: https://<public_ip>:6443
  name: mycluster
contexts:
- context:
    cluster: mycluster
    user: mycluster
  name: mycluster
current-context: mycluster
kind: Config
preferences: {}
users:
- name: mycluster
  user:
    password: <hidden_part>
    username: admin
```