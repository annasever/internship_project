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
        DOCKERHUB_CREDENTIALS = credentials('dockerhub_credentials')
        BACKEND_IMAGE = 'annasever/backend'
        FRONTEND_IMAGE = 'annasever/frontend'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scmGit(branches: [[name: '*/develop']], extensions: [], userRemoteConfigs: [[credentialsId: 'jenkins-git-user', url: 'git@github.com:annasever/internship_project.git']])
            }
        }

        stage('Build Backend Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', DOCKERHUB_CREDENTIALS) {
                        def backendImage = docker.build(BACKEND_IMAGE)
                        backendImage.push()
                    }
                }
            }
        }

        stage('Build Frontend Docker Image') {
            steps {
                dir('frontend') {
                    script {
                        docker.withRegistry('https://registry.hub.docker.com', DOCKERHUB_CREDENTIALS) {
                            def frontendImage = docker.build(FRONTEND_IMAGE)
                            frontendImage.push()
                        }
                    }
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
            script {
                sh 'docker-compose down'
            }
        }
    }
}

