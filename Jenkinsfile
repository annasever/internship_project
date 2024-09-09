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
        GITHUB_WEBHOOK_SECRET = credentials('webhook_secret_credentials')

        FRONTEND_REPO      = "${DOCKERHUB_USERNAME}/frontend"
        BACKEND_REPO       = "${DOCKERHUB_USERNAME}/backend"
    }

    triggers {
        githubPush()
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scmGit(branches: [[name: '*/develop']], extensions: [], userRemoteConfigs: [[credentialsId: 'jenkins-git-user', url: 'git@github.com:annasever/internship_project.git']])
            }
        }

        stage('Login to DockerHub') {
            steps {
                script {
                    sh "echo ${DOCKERHUB_CREDENTIALS_PSW} | docker login -u ${DOCKERHUB_CREDENTIALS_USR} --password-stdin"
                }
            }
        }

        stage('Build Frontend Image') {
            steps {
                script {
                    sh 'docker build -t ${FRONTEND_REPO}:latest -f frontend/Dockerfile .'
                }
            }
        }

        stage('Build Backend Image') {
            steps {
                script {
                    sh 'docker build -t ${BACKEND_REPO}:latest -f ./Dockerfile .'
                }
            }
        }

        stage('Push Frontend Image') {
            steps {
                script {
                    sh 'docker push ${FRONTEND_REPO}:latest'
                }
            }
        }

        stage('Push Backend Image') {
            steps {
                script {
                    sh 'docker push ${BACKEND_REPO}:latest'
                }
            }
        }

        stage('Build and Run') {
            steps {
                sh """
                    export POSTGRES_DB=${POSTGRES_DB}
                    export POSTGRES_USER=${POSTGRES_USER}
                    export POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
                    export MONGO_INITDB_DATABASE=${MONGO_INITDB_DATABASE}
                    docker-compose up -d
                """
            }
        }
    }

    post {
        success {
            echo 'Build and push completed successfully, shutting down containers...'
            sh 'docker-compose down'
        }

        failure {
            echo 'Build or push failed!'
        }
    }
}

