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

        DOCKERHUB_REPO       = "annasever/class_schedule"
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

        stage('Build Frontend Image') {
            steps {
                script {
                    dir('frontend') {
                        dockerImage = docker.build("${DOCKERHUB_REPO}-frontend")
                    }
                }
            }
        }

        stage('Build Backend Image') {
            steps {
                script {
                    dockerImage = docker.build("${DOCKERHUB_REPO}-backend")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub_credentials') {
                        docker.image("${DOCKERHUB_REPO}-frontend").push('latest')
                        docker.image("${DOCKERHUB_REPO}-backend").push('latest')
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    withEnv([
                        "POSTGRES_DB=${POSTGRES_DB}",
                        "POSTGRES_USER=${POSTGRES_USER}",
                        "POSTGRES_PASSWORD=${POSTGRES_PASSWORD}",
                        "MONGO_INITDB_DATABASE=${MONGO_INITDB_DATABASE}"
                    ]) {
                        sh 'docker-compose up -d'
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Build, push, and deployment completed successfully, shutting down containers...'
            script {
                sh 'docker-compose down'
            }
        }

        failure {
            echo 'Build, push, or deployment failed!'
        }
    }
}

