pipeline {

agent any

stages {

stage (“terraform init”) {

steps {

sh (‘terraform init’)

}

}

stage (“terraform Plan”) {

steps {

echo “Terraform action is –> plan”

sh (‘terraform plan –auto-approve’)

}

}

stage (“terraform Apply”) {

steps {

echo “Terraform action is –> apply”

sh (‘terraform apply –auto-approve’)

}

}

stage (“terraform Destroy”) {

steps {

echo “Terraform action is –> Destroy”

sh (‘terraform Destroy –auto-approve’)

}

}

}

}
