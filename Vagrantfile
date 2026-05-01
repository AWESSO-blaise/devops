Vagrant.configure("2") do |config|
  config.vm.box = "debian/bookworm64"
  config.vm.hostname = "k3s-server"
  config.vm.network "private_network", ip: "192.168.56.10"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
    vb.cpus = 2
    vb.name = "k3s-server"
  end

  config.vm.provision "shell", inline: <<-SHELL
    apt-get update -y
    apt-get install -y curl

    curl -sfL https://get.k3s.io | sh -
    systemctl enable k3s
    systemctl start k3s

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
