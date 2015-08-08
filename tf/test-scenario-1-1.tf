provider "aws" {
    region = "ap-southeast-2"
}

resource "aws_dynamodb_table" "perf-test-table" {
    name = "node-perf-baseline"
    read_capacity = 100
    write_capacity = 100
    hash_key = "id"
    attribute {
      name = "id"
      type = "S"
    }
    attribute {
      name = "lookup"
      type = "N"
    }
    global_secondary_index {
      projection_type = "KEYS_ONLY"
      name = "lookupIndex"
      hash_key = "lookup"
      write_capacity = 1
      read_capacity = 1
    }
    
}

resource "aws_instance" "webserver" {
    ami = "ami-69631053"
    instance_type = "t2.small"
    key_name = "mobile-sandbox"
    iam_instance_profile = "dynamodb"
    security_groups = [ "perf" ]
    tags {
        Name = "Snowflake node-perf baseline webserver"
        Project = "Mobile"
        Owner = "dporter@seek.com.au"
        Stream = "mobile"
    }
    provisioner "remote-exec" {
        script = "install.sh"
        connection {
            user = "ubuntu"
            type = "ssh"
            key_file = "~/dev/mobile-sandbox.pem"
        } 
    }
}

resource "aws_instance" "stress-tester" {
    ami = "ami-69631053"
    instance_type = "m4.large"
    key_name = "mobile-sandbox"
    tags {
        Name = "Snowflake node-perf baseline load-generator"
        Project = "Mobile"
        Owner = "dporter@seek.com.au"
        Stream = "mobile"
    }
    provisioner "remote-exec" {
        script = "install-perf.sh"
        connection {
            user = "ubuntu"
            type = "ssh"
            key_file = "~/dev/mobile-sandbox.pem"
        } 
    }
}
