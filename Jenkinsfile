pipeline {
    agent any
    parameters {
        choice(name: 'IMAGE_TAG', choices: ['1.1.0', '3.2.4', 'latest'], description: 'iMAGE VERSION')
    }    
    environment {
        AWS_ACCOUNT_ID="297797860062"
        AWS_DEFAULT_REGION="eu-central-1" 
        IMAGE_TAG="${params.IMAGE_TAG}"
        IMAGE_REPO_NAME="myapp"
        REPOSITORY_URL = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}"
        AWS_API_KEY = credentials('aws_credentials')
    }
   
    stages {
        
        
        stage('Cloning Git') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'github-ssh-key', url: 'git@github.com:averbuh/AppFlaskPrivate.git']]])     
            }
        }
  
    // Building Docker images
    stage('Building image') {
      steps{
        script {
          sh 'docker --version'
          dockerImage = docker.build "${IMAGE_REPO_NAME}:${IMAGE_TAG}"
        }
        cleanWs()
      }
    }

    stage('Clean Workspace') {
        steps {
            cleanWs notFailBuild: true, patterns: [[pattern: '', type: 'INCLUDE']]
        }
    }
   
    // Uploading Docker images into AWS ECR
    stage('Pushing to ECR') {
     steps{  
         script {
            docker.withRegistry("https://${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com", "ecr:eu-central-1:aws_credentials") {
                    dockerImage.push()
                }
         }
        }
      }
    }
}
