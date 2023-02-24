#locals {
#  settings = yamldecode(file("values.yaml"))
#}
module "data_ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"
  name = "testvm"
  ami                    = "${var.ami}"
  instance_type          = "${var.instancetype}"
  key_name               = "${var.keypair}"
  monitoring             = true
  #user_data = <<EOF
#<powershell>
#Set-AWSCredential -AccessKey "${var.accesskey}" -SecretKey "${var.secretkey}" -Region "${var.region}"
#Restart-Computer
#</powershell>
#EOF
  vpc_security_group_ids = [var.securitygroupid, aws_security_group.datainstancesg.id]
  root_block_device = [{
           delete_on_termination = "true"
		   device_name           = "/dev/sda1"
           encrypted             = "true"
           volume_size           = "100"
  }]
  ebs_block_device = [{
           delete_on_termination = "true"
		   device_name           = "/dev/xvdf"
           encrypted             = "true"
           volume_size           = "100"
  }]
  subnet_id              = "${var.subnet}"
  tags = {
    Description               = "Database Instance for EAMI Rx with EFT Prenote Middle 3 Tier TARB 275 RFC 32",
	"DHCS:SupportContact"       = "gonuguntavishnu@gmail.com",
	"DHCS:ManagedBy"            = "gonuguntavishnu@gmail.com",
	"DHCS:ProgramContact"       = "gonuguntavishnu@gmail.com",
	"DHCS:Environment"          = "Capman Dev 3285",
	"DHCS:ApplicationName"      = "EAMI Rx with EFT Prenote Middle 3 Tier TARB 275 RFC 32",
	"DHCS:BackupPolicy"         = "Group C",
	"DHCS:DataClassification"   = "PHI,PII",
	"DHCS:SupportGroup"         = "genady.gidenko@dhcs.ca.gov",
	"Dhcs:Fips199Categorization" = "High",
	"DHCS:Description"          = "Database Instance for EAMI Rx with EFT Prenote Middle 3 Tier TARB 275 RFC 32"
  }
}

resource "aws_security_group" "datainstancesg" {
  name                   = "securityGroupdatainstance22"
  description            = "datansg"
  vpc_id                 = "${var.vpc}"


  ingress {
    from_port            = "1433"
    to_port              = "1433"
    protocol             = "tcp"
    cidr_blocks          = ["10.0.0.0/8"]
  }
  ingress {
    from_port            = "3389"
    to_port              = "3389"
    protocol             = "tcp"
    cidr_blocks          = ["10.0.0.0/8"]
  }
  ingress {
    from_port            = "1433"
    to_port              = "1433"
    protocol             = "tcp"
    cidr_blocks          = ["10.0.0.0/8"]
  }
}
