resource "aws_instance" "test-server" {
  ami           = "ami-0f5ee92e2d63afc18" 
  instance_type = "t2.micro" 
  key_name = "myownkey"
  vpc_security_group_ids= ["sg-088585bb55f0856c0"]
  connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = file("./myownkey.pem")
    host     = self.public_ip
  }
  provisioner "remote-exec" {
    inline = [ "echo 'wait to start instance' "]
  }
  tags = {
    Name = "test-server"
  }
  provisioner "local-exec" {
        command = " echo ${aws_instance.test-server.public_ip} > inventory "
  }
   provisioner "local-exec" {
  command = "ansible-playbook /var/lib/jenkins/workspace/Banking-Finance/my-serverfiles/finance-playbook.yml "
  } 
}
