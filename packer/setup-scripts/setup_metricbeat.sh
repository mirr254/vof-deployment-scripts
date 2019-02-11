setup_metricbeat(){

  sudo bash -c 'cat <<EOF > /etc/metricbeat/metricbeat.yml
metricbeat.modules:
- module: system
  metricsets:
    - cpu
    - filesystem
    - memory
    - network
    - process
    - core
    - diskio
    - fsstat
    - load
    - process_summary
    - raid
    - socket
    - uptime
  enabled: true
  period: 60s
  processes: ['.*']
  cpu_ticks: false

output.logstash:
  enabled: true
  hosts: ["test-logstash.andela.com"]
  ssl:
    enabled: true
    certificate_authorities: ["/etc/pki/tls/certs/ca.crt"]
    certificate: "/etc/pki/tls/certs/client.crt"
    key: "/etc/pki/tls/certs/client.key"

shipper:

logging:
  files:
    rotateeverybytes: 10485760 # = 10MB

setup.kibana:
  host: "test-vof-kibana.andela.com"
EOF'

  sudo systemctl start metricbeat
  sudo systemctl enable metricbeat

}
