pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-2'
    }

        stage('Checkout SCM') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init-Plan') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'jenkins-test'
                ]]) {
                    sh '''
                        aws sts get-caller-identity

                        terraform version
                        terraform init
                        terraform plan -out=tfplan
                    '''
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                input message: 'Approve Terraform Apply?', ok: 'Deploy'
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'jenkins-test'
                ]]) {
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }
    }
}