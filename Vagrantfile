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
  SHELL
end
