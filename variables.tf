variable "vpc_id" {
  description = "ID of the existing VPC"
  default = "vpc-0e18d285401c4e077" 
}

variable "subnet_ids" {
  type        = list(string)
  default     = [ "subnet-02bf6149ca95fac33",
                  "subnet-0376fc466948776f0",
                  "subnet-042407479ccdc4635",
                  "subnet-061cd939df049d25e",
                  "subnet-0799a5683fec1e200",
                  "subnet-0deaa09686a13c9ee"]
  description = "A list of public subnet ids."
  sensitive   = true
}

variable "vpc_security_group_ids" {
    type = string
    default = "sg-039da37dd0401a632"
  
}

variable "ec2_instance_ids" {
  type =list(string)
  default = [ "i-099e19dfec39fc89c",
              "i-014a594fffc39bab3"
            ]
}