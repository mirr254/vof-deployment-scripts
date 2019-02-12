create_filebeat_config_file(){

  sudo mv /etc/filebeat/filebeat.yml /etc/filebeat/filebeat_old.yml
  sudo bash -c "cat <<EOF > /etc/filebeat/filebeat.yml
filebeat:
  prospectors:
    -
      paths:
        - /home/vof/app/log/logstash_*.log

      exclude_lines: ['/health{1}']
      #  - /var/log/*.log

      input_type: log

      document_type: syslog

  registry_file: /var/lib/filebeat/registry

output.logstash:
  enabled: true
  hosts: ["test-logstash.andela.com:8751"]
  ssl:
    enabled: true
    certificate_authorities: ["/etc/pki/tls/certs/ca.crt"]
    certificate: "/etc/pki/tls/certs/client.crt"
    key: "/etc/pki/tls/certs/client.key"

shipper:

logging:
  files:
    rotateeverybytes: 10485760 # = 10MB
EOF"

}

setup_filebeat(){
  sudo mkdir -p /etc/pki/tls/certs
  sudo gsutil cp gs://${BUCKET_NAME}/elk-ssl/client.crt /etc/pki/tls/certs/client.crt
  sudo gsutil cp gs://${BUCKET_NAME}/elk-ssl/client.key /etc/pki/tls/certs/client.key
  sudo gsutil cp gs://${BUCKET_NAME}/elk-ssl/ca.crt /etc/pki/tls/certs/ca.crt
  create_filebeat_config_file
  sudo systemctl restart filebeat
  sudo systemctl enable filebeat
}
