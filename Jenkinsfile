pipeline {
    agent {
        label 'internship_project'
    }

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-key')
        POSTGRES_DB           = credentials('mydatabase')
        POSTGRES_USER         = credentials('myuser')
        POSTGRES_PASSWORD     = credentials('mypassword')
        MONGO_INITDB_DATABASE = credentials('my_mongo_database')
    }


    stages {
        stage('Checkout') {
            steps {
                checkout scmGit(branches: [[name: '*/develop']], extensions: [], userRemoteConfigs: [[credentialsId: 'jenkins-git-user', url: 'git@github.com:annasever/internship_project.git']])
            }
        }

     stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t internship_project_image .'
                }
            }
        }

    stage('Run Docker Compose') {
        steps {
            script {
                sh 'docker-compose up -d'
                }
            }
        }
    }

    post {
        always {
            sh 'docker-compose down' 
        }
    }
}
