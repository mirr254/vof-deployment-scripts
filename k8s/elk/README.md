## How to set up on GCP
- Clone the repo `git clone https://github.com/andela/vof-deployment-scripts.git`
- cd to `vof-deployment-scripts`
- Checkout to this branch `git checkout ft-setup-elk-on-gke-161717613`
- Authenticate with GCP on any project and create a cluster named `shared-elk-cluster` with nose size of 2 and 4 vCPU
- create a `.env` file with all the required keys for the certificates as shown in the example `.env.sample`
- Use `kubectl apply -f` on all the folders. From 1-7. for example `kubectl apply -f 1_k8s_global`
- Use `envsubst < file-to-replace-values.yaml | kubectl apply -f -` for 2 two folders. i.e 
`6_logstash` and `7_oauth2-proxy`. This will substitute the certifacate env variables in the files

## Connecting to the ELK
- Download the clients certificate from GCP bucket from andela-learning in the folder `/apprenticeship/elk-ssl/client certs`
- Place them in a directory of your choice on the server
- Install filebeat - instructions on how to install can be found [here](https://www.elastic.co/guide/en/beats/filebeat/current/filebeat-installation.html) and configure the output part of `filebeat.yml` to reflect as shown below. An example of the file can be found [here](https://github.com/elastic/beats/blob/master/filebeat/filebeat.yml)
```
output.logstash:
  enabled: true
  hosts: ["test-logstash.andela.com:8751"]
  ssl:
    enabled: true
    certificate_authorities: [".../ca.crt"] ##directory in which the certs are stored 
    certificate: ".../client.crt"           ## same here
    key: ".../client.key"                   ## same here
```

NOTE: Make sure there is only one `output` parameter in the `filebeat.yml`

- restart filebeat
