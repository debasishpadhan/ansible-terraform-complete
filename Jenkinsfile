pipeline {
    agent any

    stages {
        stage ("checkout from GIT") {
            steps {
                git "https://github.com/debasishpadhan/ansible-terraform-complete.git'"            }
        }
        stage ("terraform init") {
            steps {
                sh 'terraform init'
            }
        }
        stage ("terrafrom plan") {
            steps {
                sh 'terraform plan '
            }
        }
        stage ("terraform apply") {
            steps {
                sh 'terraform apply --auto-approve'
            }
        }
    }
}
