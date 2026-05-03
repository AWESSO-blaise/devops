Vagrant.configure("2") do |config|

  # VM 1 - k3s
  config.vm.define "k3s" do |k3s|
    k3s.vm.box = "debian/bookworm64"
    k3s.vm.hostname = "k3s-server"
    k3s.vm.network "private_network", ip: "192.168.56.10"

    k3s.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.cpus = 2
      vb.name = "k3s-server"
    end

    k3s.vm.provision "shell", inline: <<-SHELL
      apt-get update -y
      apt-get install -y curl

      curl -sfL https://get.k3s.io | sh -
      systemctl enable k3s
      systemctl start k3s

      # Node Exporter
      useradd --no-create-home --shell /bin/false node_exporter
      curl -LO https://github.com/prometheus/node_exporter/releases/download/v1.7.0/node_exporter-1.7.0.linux-amd64.tar.gz
      tar xzf node_exporter-1.7.0.linux-amd64.tar.gz
      cp node_exporter-1.7.0.linux-amd64/node_exporter /usr/local/bin/
      chown node_exporter:node_exporter /usr/local/bin/node_exporter
      cat > /etc/systemd/system/node_exporter.service << EOF
[Unit]
Description=Node Exporter
After=network.target

[Service]
User=node_exporter
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOF
      systemctl daemon-reload
      systemctl enable node_exporter
      systemctl start node_exporter

      # GitHub Actions Runner
      mkdir -p /home/vagrant/actions-runner
      cd /home/vagrant/actions-runner
      curl -o actions-runner.tar.gz -L https://github.com/actions/runner/releases/download/v2.334.0/actions-runner-linux-x64-2.334.0.tar.gz
      tar xzf actions-runner.tar.gz
      chown -R vagrant:vagrant /home/vagrant/actions-runner
      sudo -u vagrant /home/vagrant/actions-runner/config.sh --url https://github.com/AWESSO-blaise/devops --token BCMOSYGBUMN7BNJMMOZSFCLJ6UAIS --unattended --name k3s-server --labels self-hosted
      /home/vagrant/actions-runner/svc.sh install vagrant
      /home/vagrant/actions-runner/svc.sh start
    SHELL
  end

  # VM 2 - Monitoring
  config.vm.define "monitoring" do |mon|
    mon.vm.box = "debian/bookworm64"
    mon.vm.hostname = "monitoring"
    mon.vm.network "private_network", ip: "192.168.56.11"

    mon.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.cpus = 2
      vb.name = "monitoring"
    end

    mon.vm.provision "shell", inline: <<-SHELL
      apt-get update -y
      apt-get install -y curl wget

      # Node Exporter
      useradd --no-create-home --shell /bin/false node_exporter
      curl -LO https://github.com/prometheus/node_exporter/releases/download/v1.7.0/node_exporter-1.7.0.linux-amd64.tar.gz
      tar xzf node_exporter-1.7.0.linux-amd64.tar.gz
      cp node_exporter-1.7.0.linux-amd64/node_exporter /usr/local/bin/
      chown node_exporter:node_exporter /usr/local/bin/node_exporter
      cat > /etc/systemd/system/node_exporter.service << EOF
[Unit]
Description=Node Exporter
After=network.target

[Service]
User=node_exporter
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOF
      systemctl daemon-reload
      systemctl enable node_exporter
      systemctl start node_exporter

      # Prometheus
      useradd --no-create-home --shell /bin/false prometheus
      mkdir /etc/prometheus /var/lib/prometheus
      curl -LO https://github.com/prometheus/prometheus/releases/download/v2.49.0/prometheus-2.49.0.linux-amd64.tar.gz
      tar xzf prometheus-2.49.0.linux-amd64.tar.gz
      cp prometheus-2.49.0.linux-amd64/prometheus /usr/local/bin/
      cp prometheus-2.49.0.linux-amd64/promtool /usr/local/bin/
      cp -r prometheus-2.49.0.linux-amd64/consoles /etc/prometheus
      cp -r prometheus-2.49.0.linux-amd64/console_libraries /etc/prometheus
      chown -R prometheus:prometheus /etc/prometheus /var/lib/prometheus

      cat > /etc/prometheus/prometheus.yml << EOF
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'k3s-server'
    static_configs:
      - targets: ['192.168.56.10:9100']

  - job_name: 'monitoring'
    static_configs:
      - targets: ['192.168.56.11:9100']
EOF

      cat > /etc/systemd/system/prometheus.service << EOF
[Unit]
Description=Prometheus
After=network.target

[Service]
User=prometheus
ExecStart=/usr/local/bin/prometheus --config.file=/etc/prometheus/prometheus.yml --storage.tsdb.path=/var/lib/prometheus
Restart=always

[Install]
WantedBy=multi-user.target
EOF
      systemctl daemon-reload
      systemctl enable prometheus
      systemctl start prometheus

      # Grafana
      apt-get install -y apt-transport-https software-properties-common
      wget -q -O /usr/share/keyrings/grafana.key https://apt.grafana.com/gpg.key
      echo "deb [signed-by=/usr/share/keyrings/grafana.key] https://apt.grafana.com stable main" > /etc/apt/sources.list.d/grafana.list
      apt-get update -y
      apt-get install -y grafana
      systemctl enable grafana-server
      systemctl start grafana-server
    SHELL
  end

end
